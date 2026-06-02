import 'dart:math' as math;
import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/daos/traffic_violations_dao.dart';
import 'package:driving_test_prep/data/models/traffic_violation_model.dart';
import 'package:driving_test_prep/data/services/firebase/traffic_violation_api_service.dart';

class TrafficViolationRepository {
  final TrafficViolationsDao dao;
  final TrafficViolationApiService api;

  TrafficViolationRepository({
    required this.dao,
    required this.api,
  });

  factory TrafficViolationRepository.localFirst() {
    return TrafficViolationRepository(
      dao: TrafficViolationsDao(DBProvider().db),
      api: TrafficViolationApiService(),
    );
  }

  Future<bool> isSynced() async => (await dao.count()) > 0;

  Future<int> syncIfNeeded() async {
    if (await isSynced()) return await dao.count();
    return syncNow();
  }

  Future<int> syncNow() async {
    final violations = await api.fetchAll();
    await dao.replaceAll(violations);
    return violations.length;
  }

  Future<TrafficViolationSearchResult> search({
    required String keyword,
    String? vehicleType,
  }) async {
    await syncIfNeeded();

    final normalizedKeyword = _normalize(keyword);
    final normalizedVehicleType = _normalize(vehicleType);
    final allViolations = await dao.getAllActive();
    final filteredByVehicle = normalizedVehicleType.isEmpty
        ? allViolations
        : allViolations
            .where((violation) => violation.vehicleTypes
                .any((type) => _normalize(type) == normalizedVehicleType))
            .toList();

    if (normalizedKeyword.isEmpty) {
      return TrafficViolationSearchResult(
        message: 'Tìm kiếm lỗi vi phạm thành công.',
        total: filteredByVehicle.length,
        data: filteredByVehicle,
      );
    }

    final context = _SearchContext.create(filteredByVehicle, normalizedKeyword);
    final scored = filteredByVehicle
        .map((violation) => _ScoredViolation(
              violation,
              _score(violation, normalizedKeyword, context),
            ))
        .where((item) => item.score > 0)
        .toList()
      ..sort((a, b) {
        final scoreCompare = b.score.compareTo(a.score);
        if (scoreCompare != 0) return scoreCompare;
        return a.violation.fineMin.compareTo(b.violation.fineMin);
      });

    final data = scored.map((item) => item.violation).toList();
    return TrafficViolationSearchResult(
      message: 'Tìm kiếm lỗi vi phạm thành công.',
      total: data.length,
      data: data,
    );
  }

  Future<TrafficViolation?> getById(String id) async {
    await syncIfNeeded();
    return dao.getById(id);
  }

  static int _score(
    TrafficViolation violation,
    String normalizedKeyword,
    _SearchContext context,
  ) {
    var score = 0;
    final title = _normalize(violation.title);
    final searchText = _normalize(violation.searchText);
    final officialText = _officialText(violation);
    final aliases = violation.aliases.map(_normalize).toList();
    final keywords = violation.keywords.map(_normalize).toList();
    final behaviorText = _normalize([
      violation.title,
      ...violation.aliases,
      ...violation.keywords,
    ].join(' '));

    final intentRule = context.intentRule;
    final isIntentMatch = intentRule?.isMatch(title, officialText) == true;
    final exactAliasOrKeyword = aliases.any((item) => item.contains(normalizedKeyword)) ||
        keywords.any((item) => item.contains(normalizedKeyword));
    final isAccidentCrossReference =
        title.contains('gay tai nan') && exactAliasOrKeyword;
    final isLegalReferenceMatch = title.contains('gay tai nan') &&
        _isLegalReferenceMatch(violation, title, context.legalReferences);

    if (intentRule != null &&
        !isIntentMatch &&
        !isAccidentCrossReference &&
        !isLegalReferenceMatch) {
      return 0;
    }

    if (title.contains(normalizedKeyword)) score += 160;
    if (exactAliasOrKeyword) score += 140;
    if (aliases.any((item) =>
        item.contains(normalizedKeyword) || normalizedKeyword.contains(item))) {
      score += 90;
    }
    if (keywords.any((item) =>
        item.contains(normalizedKeyword) || normalizedKeyword.contains(item))) {
      score += 70;
    }
    if (searchText.contains(normalizedKeyword)) score += 35;
    if (intentRule != null) score += 120;
    if (isAccidentCrossReference) score += 95;
    if (isLegalReferenceMatch) score += 105;

    final tokens = context.keywordTokens;
    if (tokens.isNotEmpty && !isLegalReferenceMatch) {
      final titleMatchedTokens =
          tokens.where((token) => title.contains(token)).length;
      final matchedTokens = tokens
          .where((token) =>
              behaviorText.contains(token) || searchText.contains(token))
          .length;
      final requiredMatches = tokens.length <= 3
          ? tokens.length
          : math.max(3, (tokens.length * 0.75).ceil());

      if (!isIntentMatch && matchedTokens < requiredMatches) return 0;
      if (intentRule == null &&
          !title.contains(normalizedKeyword) &&
          titleMatchedTokens == 0) {
        return 0;
      }

      score += matchedTokens * 12;
      score += titleMatchedTokens * 16;
      if (matchedTokens == tokens.length) score += 20;
    }

    return score;
  }

  static bool _isDirectReferenceSource(
    TrafficViolation violation,
    String normalizedKeyword,
    _SearchIntentRule? intentRule,
  ) {
    final title = _normalize(violation.title);
    if (title.contains('gay tai nan')) return false;

    final aliases = violation.aliases.map(_normalize).toList();
    final keywords = violation.keywords.map(_normalize).toList();
    final exactAliasOrKeyword = aliases.any((item) => item.contains(normalizedKeyword)) ||
        keywords.any((item) => item.contains(normalizedKeyword));

    if (intentRule != null) {
      return intentRule.isMatch(title, _officialText(violation)) &&
          (title.contains(normalizedKeyword) || exactAliasOrKeyword);
    }

    final tokens = _keywordTokens(normalizedKeyword);
    if (tokens.isEmpty) return false;

    final behaviorText = _normalize([
      violation.title,
      ...violation.aliases,
      ...violation.keywords,
    ].join(' '));

    return title.contains(normalizedKeyword) ||
        exactAliasOrKeyword ||
        tokens.every(behaviorText.contains);
  }

  static bool _isLegalReferenceMatch(
    TrafficViolation violation,
    String normalizedTitle,
    List<_LegalReference> legalReferences,
  ) {
    if (legalReferences.isEmpty) return false;
    final article = _extractArticle(violation);
    return legalReferences.any((reference) =>
        article == reference.article &&
        normalizedTitle.contains('khoan ${reference.clause}') &&
        (reference.point.isEmpty ||
            normalizedTitle.contains('diem ${reference.point}')));
  }

  static _LegalReference? _extractLegalReference(TrafficViolation violation) {
    final legalBasis = _normalize(violation.penaltyLegalBasis);
    final match = RegExp(r'diem\s+([a-z])\s+khoan\s+(\d+)\s+dieu\s+(\d+)')
        .firstMatch(legalBasis);
    if (match == null) return null;
    return _LegalReference(
      int.tryParse(match.group(3) ?? '') ?? 0,
      int.tryParse(match.group(2) ?? '') ?? 0,
      match.group(1) ?? '',
    );
  }

  static int _extractArticle(TrafficViolation violation) {
    final legalBasis = _normalize(violation.penaltyLegalBasis);
    final legalMatch = RegExp(r'dieu\s+(\d+)').firstMatch(legalBasis);
    if (legalMatch != null) {
      return int.tryParse(legalMatch.group(1) ?? '') ?? 0;
    }
    final idMatch = RegExp(r'dieu(\d+)').firstMatch(violation.id);
    return int.tryParse(idMatch?.group(1) ?? '') ?? 0;
  }

  static _SearchIntentRule? _intentRule(
    String normalizedKeyword,
    List<String> keywordTokens,
  ) {
    return _intentRules.firstWhere(
      (rule) =>
          rule.queryPhrases.any(normalizedKeyword.contains) ||
          (rule.queryTokens.isNotEmpty &&
              rule.queryTokens.every(keywordTokens.contains)),
      orElse: () => _SearchIntentRule.empty,
    ).isEmpty
        ? null
        : _intentRules.firstWhere(
            (rule) =>
                rule.queryPhrases.any(normalizedKeyword.contains) ||
                (rule.queryTokens.isNotEmpty &&
                    rule.queryTokens.every(keywordTokens.contains)),
          );
  }

  static String _officialText(TrafficViolation violation) {
    return _normalize([
      violation.title,
      violation.subjectText,
      violation.penaltyText,
      violation.penaltyLegalBasis,
      violation.additionalPenaltyText,
      violation.additionalPenaltyLegalBasis,
    ].join(' '));
  }

  static List<String> _keywordTokens(String value) {
    return value
        .split(RegExp(r'\s+'))
        .where((token) => token.length >= 2 && !_stopWords.contains(token))
        .toSet()
        .toList();
  }

  static String _normalize(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    const source =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
    const target =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
    var text = value.trim().toLowerCase();
    for (var i = 0; i < source.length; i++) {
      text = text.replaceAll(source[i], target[i]);
    }
    return text;
  }

  static final List<_SearchIntentRule> _intentRules = [
    _SearchIntentRule(
      queryPhrases: ['vuot den do', 'chay den do', 'khong dung den do', 'den do'],
      queryTokens: ['den', 'do'],
      requiredTitlePhrases: ['den do'],
      requiredTitleAllPhrases: ['khong chap hanh', 'den tin hieu'],
      requiredTextPhrases: ['den do da bat sang'],
    ),
    _SearchIntentRule(
      queryPhrases: ['qua toc do', 'vuot toc do', 'toc do'],
      queryTokens: ['toc', 'do'],
      requiredTitlePhrases: ['chay qua toc do', 'qua toc do quy dinh', 'toc do toi da'],
      requiredTextPhrases: ['chay qua toc do', 'qua toc do quy dinh', 'toc do toi da', 'toc do toi thieu'],
    ),
    _SearchIntentRule(
      queryPhrases: ['nong do con', 'ruou bia', 'chat kich thich'],
      queryTokens: ['nong', 'con'],
      requiredTitlePhrases: ['nong do con', 'chat kich thich'],
      requiredTextPhrases: ['nong do con', 'trong mau hoac hoi tho', 'kiem tra ve nong do con', 'chat kich thich'],
    ),
    _SearchIntentRule(
      queryPhrases: ['mu bao hiem', 'khong doi mu', 'doi mu'],
      queryTokens: ['mu', 'bao', 'hiem'],
      requiredTitlePhrases: ['mu bao hiem'],
      requiredTextPhrases: ['mu bao hiem', 'doi mu'],
    ),
    _SearchIntentRule(
      queryPhrases: ['nguoc chieu', 'di nguoc chieu', 'chay nguoc chieu'],
      queryTokens: ['nguoc', 'chieu'],
      requiredTitlePhrases: ['di nguoc chieu cua duong mot chieu', 'di nguoc chieu tren duong', 'di nguoc chieu duong', 'di vao khu vuc cam'],
      requiredTextPhrases: ['di nguoc chieu', 'duong mot chieu', 'cam di nguoc chieu', 'di vao khu vuc cam'],
    ),
  ];

  static final Set<String> _stopWords = {
    'doi',
    'voi',
    'nguoi',
    'dieu',
    'khien',
    'phuong',
    'tien',
    'giao',
    'thong',
    'duong',
    'dong',
    'phat',
    'khoan',
    'diem',
  };
}

class _SearchContext {
  final List<String> keywordTokens;
  final _SearchIntentRule? intentRule;
  final List<_LegalReference> legalReferences;

  _SearchContext({
    required this.keywordTokens,
    required this.intentRule,
    required this.legalReferences,
  });

  factory _SearchContext.create(
    List<TrafficViolation> violations,
    String normalizedKeyword,
  ) {
    final tokens = TrafficViolationRepository._keywordTokens(normalizedKeyword);
    final rule = TrafficViolationRepository._intentRule(normalizedKeyword, tokens);
    final references = violations
        .where((violation) => TrafficViolationRepository._isDirectReferenceSource(
              violation,
              normalizedKeyword,
              rule,
            ))
        .map(TrafficViolationRepository._extractLegalReference)
        .whereType<_LegalReference>()
        .toSet()
        .toList();

    return _SearchContext(
      keywordTokens: tokens,
      intentRule: rule,
      legalReferences: references,
    );
  }
}

class _SearchIntentRule {
  final List<String> queryPhrases;
  final List<String> queryTokens;
  final List<String> requiredTitlePhrases;
  final List<String> requiredTitleAllPhrases;
  final List<String> requiredTextPhrases;

  static final empty = _SearchIntentRule();

  _SearchIntentRule({
    this.queryPhrases = const [],
    this.queryTokens = const [],
    this.requiredTitlePhrases = const [],
    this.requiredTitleAllPhrases = const [],
    this.requiredTextPhrases = const [],
  });

  bool get isEmpty =>
      queryPhrases.isEmpty &&
      queryTokens.isEmpty &&
      requiredTitlePhrases.isEmpty &&
      requiredTitleAllPhrases.isEmpty &&
      requiredTextPhrases.isEmpty;

  bool isMatch(String title, String officialText) {
    final hasAll = requiredTitleAllPhrases.isNotEmpty &&
        requiredTitleAllPhrases.every(title.contains);
    final hasAnyTitle = requiredTitlePhrases.any(title.contains);
    final hasAnyText = requiredTextPhrases.any(
      (phrase) => title.contains(phrase) || officialText.contains(phrase),
    );
    return hasAll || hasAnyTitle || hasAnyText;
  }
}

class _LegalReference {
  final int article;
  final int clause;
  final String point;

  _LegalReference(this.article, this.clause, this.point);

  @override
  bool operator ==(Object other) =>
      other is _LegalReference &&
      article == other.article &&
      clause == other.clause &&
      point == other.point;

  @override
  int get hashCode => Object.hash(article, clause, point);
}

class _ScoredViolation {
  final TrafficViolation violation;
  final int score;

  _ScoredViolation(this.violation, this.score);
}
