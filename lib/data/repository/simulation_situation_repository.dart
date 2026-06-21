import 'dart:math';

import 'package:driving_test_prep/data/models/simulation_situation_model.dart';
import 'package:driving_test_prep/data/services/firebase/simulation_situation_api_service.dart';
import 'package:driving_test_prep/data/services/sqlite/simulation_situation_local_service.dart';
import 'package:driving_test_prep/core/database/DBProvider.dart';

class SimulationSituationRepository {
  static const simulationPassingScore = 35;
  static const simulationMaxScore = 50;
  static const _examChapterCounts = {
    1: 2,
    2: 1,
    3: 2,
    4: 1,
    5: 2,
    6: 2,
  };

  final SimulationSituationApiService api;
  final SimulationSituationLocalService local;

  SimulationSituationRepository({
    required this.api,
    required this.local,
  });

  factory SimulationSituationRepository.remote() {
    return SimulationSituationRepository(
      api: SimulationSituationApiService(),
      local: SimulationSituationLocalService(DBProvider().db),
    );
  }

  Future<List<SimulationSituation>> getAllActive() async {
    final cachedSituations = await local.fetchAll();
    if (cachedSituations.isNotEmpty) {
      return _activeSorted(cachedSituations);
    }

    final situations = await api.fetchAll();
    await local.replaceAll(situations);
    return _activeSorted(situations);
  }

  Future<List<SimulationSituation>> refreshFromRemote() async {
    final situations = await api.fetchAll();
    await local.replaceAll(situations);
    return _activeSorted(situations);
  }

  Future<void> recordPracticeAttempt({
    required SimulationSituation situation,
    required int score,
    required double flagSecond,
  }) {
    return local.recordAttempt(
      situationId: situation.id,
      score: score,
      flagSecond: flagSecond,
      duration: situation.duration,
    );
  }

  Future<SimulationProgressSummary?> getProgress(int situationId) {
    return local.getProgress(situationId);
  }

  Future<Map<int, SimulationProgressSummary>> getProgressBySituationIds(
    List<int> situationIds,
  ) {
    return local.getProgressBySituationIds(situationIds);
  }

  Future<List<SimulationAttemptHistory>> getAttemptHistory(
    int situationId, {
    int limit = 20,
  }) {
    return local.fetchAttempts(situationId, limit: limit);
  }

  Future<List<SimulationAttemptHistory>> getRecentAttemptHistory({
    int limit = 100,
  }) {
    return local.fetchRecentAttempts(limit: limit);
  }

  Future<void> deleteAttempt(int attemptId) {
    return local.deleteAttempt(attemptId);
  }

  Future<void> clearAttemptHistory({int? situationId}) {
    return local.clearAttempts(situationId: situationId);
  }

  List<SimulationSituation> generateExamSituations(
    List<SimulationSituation> situations, {
    Random? random,
  }) {
    final generator = random ?? Random();
    final selected = <SimulationSituation>[];

    for (final entry in _examChapterCounts.entries) {
      final chapterSituations = filterByChapter(situations, entry.key);
      chapterSituations.shuffle(generator);
      selected.addAll(chapterSituations.take(entry.value));
    }

    if (selected.length < 10) {
      final selectedIds = selected.map((item) => item.id).toSet();
      final remaining = situations
          .where((item) => item.isActive && !selectedIds.contains(item.id))
          .toList()
        ..shuffle(generator);
      selected.addAll(remaining.take(10 - selected.length));
    }

    return selected.take(10).toList();
  }

  Future<int> saveExamResult({
    required int totalScore,
    required DateTime startedAt,
    required DateTime submittedAt,
    required List<SimulationExamAnswerInput> answers,
  }) {
    return local.saveExamResult(
      totalScore: totalScore,
      isPassed: totalScore >= simulationPassingScore,
      startedAt: startedAt,
      submittedAt: submittedAt,
      answers: answers,
    );
  }

  Future<List<SimulationExamSessionHistory>> getExamHistory({
    int limit = 50,
  }) {
    return local.fetchExamSessions(limit: limit);
  }

  Future<List<SimulationExamAnswerHistory>> getExamAnswerHistory(
    int sessionId,
  ) {
    return local.fetchExamAnswers(sessionId);
  }

  Future<void> deleteExamHistorySession(int sessionId) {
    return local.deleteExamSession(sessionId);
  }

  Future<void> clearExamHistory() {
    return local.clearExamHistory();
  }

  List<SimulationSituation> _activeSorted(List<SimulationSituation> situations) {
    return situations.where((item) => item.isActive).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }

  List<SimulationSituation> filterByChapter(
    List<SimulationSituation> situations,
    int chapter,
  ) {
    return situations.where((item) => item.chapter == chapter).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }
}
