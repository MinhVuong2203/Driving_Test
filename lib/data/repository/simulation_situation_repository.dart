import 'package:driving_test_prep/data/models/simulation_situation_model.dart';
import 'package:driving_test_prep/data/services/firebase/simulation_situation_api_service.dart';
import 'package:driving_test_prep/data/services/sqlite/simulation_situation_local_service.dart';
import 'package:driving_test_prep/core/database/DBProvider.dart';

class SimulationSituationRepository {
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
