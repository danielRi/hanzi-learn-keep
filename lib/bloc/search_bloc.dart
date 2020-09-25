import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:hanzi_learn_keep/model/character_statistic.dart';
import 'package:hanzi_learn_keep/repo/character_repository.dart';
import 'package:hanzi_learn_keep/service/database_service.dart';

class SearchEvent {}

class InitEvent extends SearchEvent {}

class SearchState {}

class LoadingState extends SearchState {}

class DataState extends SearchState {
  final List<CharacterListElement> list;

  DataState({this.list});
}

class CharacterListElement {
  final CharacterFrame frame;
  final CharacterStatistic statistic;

  CharacterListElement({this.frame, this.statistic});
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(LoadingState());

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    // TODO: implement mapEventToState
    if (event is InitEvent) {
      final resultList = List<CharacterListElement>();
      final data = await CharacterRepository().fetchData();
      for (CharacterFrame frame in data.values) {
        final statistic = await DatabaseService().frame(frame.frameNumber);
        resultList
            .add(CharacterListElement(frame: frame, statistic: statistic));
      }
      yield DataState(list: resultList);
    }
  }
}
