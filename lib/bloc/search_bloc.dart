import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanzi_learn_keep/model/character_frame.dart';
import 'package:hanzi_learn_keep/model/character_statistic.dart';
import 'package:hanzi_learn_keep/repo/character_repository.dart';
import 'package:hanzi_learn_keep/service/database_service.dart';

class SearchEvent {}

class SearchInitEvent extends SearchEvent {}

class SearchStringEvent extends SearchEvent {
  final String text;

  SearchStringEvent({this.text});
}

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
    if (event is SearchInitEvent) {
      final resultList = List<CharacterListElement>();
      final data = await CharacterRepository().fetchData();
      for (CharacterFrame frame in data.values) {
        final statistic = await DatabaseService().frame(frame.frameNumber);
        resultList
            .add(CharacterListElement(frame: frame, statistic: statistic));
      }
      yield DataState(list: resultList);
    } else if (event is SearchStringEvent) {
      final searchString = event.text;
      print("event " + searchString);
      final searchStringList = searchString.split(" ");
      yield LoadingState();
      final resultList = List<CharacterListElement>();
      final data = await CharacterRepository().fetchData();
      for (CharacterFrame frame in data.values) {
        bool foundString = false;
        for (String searchString in searchStringList) {
          if (frame.characterTraditional.toLowerCase().contains(searchString) ||
              frame.keyWord.toLowerCase().contains(searchString) ||
              frame.frameNumber.contains(searchString)) {
            foundString = true;
          }
        }
        if (foundString) {
          final statistic = await DatabaseService().frame(frame.frameNumber);
          resultList
              .add(CharacterListElement(frame: frame, statistic: statistic));
        }
      }
      yield DataState(list: resultList);
    }
  }
}
