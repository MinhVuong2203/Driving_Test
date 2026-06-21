import 'package:driving_test_prep/data/models/simulation_situation_model.dart';
import 'package:driving_test_prep/data/services/firebase/simulation_situation_api_service.dart';

class SimulationSituationRepository {
  final SimulationSituationApiService api;

  SimulationSituationRepository({required this.api});

  factory SimulationSituationRepository.remote() {
    return SimulationSituationRepository(api: SimulationSituationApiService());
  }

  Future<List<SimulationSituation>> getAllActive() async {
    final situations = await api.fetchAll();
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
