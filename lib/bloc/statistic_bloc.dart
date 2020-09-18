import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanzi_learn_keep/model/character_statistic.dart';
import 'package:hanzi_learn_keep/repo/character_repository.dart';

class StatisticEvent {}

class InitEvent extends StatisticEvent {}

class StatisticState {}

class Loadingstate extends StatisticState {}

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc() : super(Loadingstate());

  @override
  Stream<StatisticState> mapEventToState(StatisticEvent event) async* {
    if (event is InitEvent) {
      await CharacterRepository().fetchData();
      yield StatisticState();
    }
    yield state;
  }
}
