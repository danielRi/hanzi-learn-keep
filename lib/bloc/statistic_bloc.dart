import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanzi_learn_keep/model/character_statistic.dart';

enum StatisticEvent { correct }

class StatisticBloc
    extends Bloc<StatisticEvent, Map<String, CharacterStatistic>> {
  StatisticBloc() : super(Map());

  @override
  Stream<Map<String, CharacterStatistic>> mapEventToState(
      StatisticEvent event) {
    throw UnimplementedError();
  }
}
