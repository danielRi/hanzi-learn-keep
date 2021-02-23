import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:hanzi_learn_keep/model/character_statistic.dart';
import 'package:hanzi_learn_keep/repo/character_repository.dart';
import 'package:hanzi_learn_keep/repo/statistic_repository.dart';

class StatisticEvent {}

class StatisticInitEvent extends StatisticEvent {}

class StatisticState {}

class Loadingstate extends StatisticState {}

class StatisticDataState extends StatisticState {
  final CharacterStatistic worstFrameStatistic;
  final CharacterFrame worstFrame;
  final int globalSuccessRate;
  final int framesStudied;

  StatisticDataState(
      {this.worstFrameStatistic,
      this.worstFrame,
      this.globalSuccessRate,
      this.framesStudied});

  bool get hasData {
    return worstFrame != null &&
        worstFrameStatistic != null &&
        globalSuccessRate != null &&
        framesStudied != null;
  }
}

class StatisticBloc extends Bloc<StatisticEvent, StatisticState> {
  StatisticBloc() : super(Loadingstate());

  @override
  Stream<StatisticState> mapEventToState(StatisticEvent event) async* {
    if (event is StatisticInitEvent) {
      await CharacterRepository().fetchData();
      await StatisticRepository().initDatabase();
      final worstFrameStatistic = await StatisticRepository().worstFrame();
      var worstFrame;
      if (worstFrameStatistic != null) {
        worstFrame =
            CharacterRepository().getFrame(worstFrameStatistic.frameNumber);
      }

      final framesStudied = await StatisticRepository().framesStudied();
      final globalSuccessRate = await StatisticRepository().globalSuccessRate();
      yield StatisticDataState(
        worstFrameStatistic: worstFrameStatistic,
        worstFrame: worstFrame,
        framesStudied: framesStudied,
        globalSuccessRate: globalSuccessRate,
      );
    }
    yield state;
  }
}
