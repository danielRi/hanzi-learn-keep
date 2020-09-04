import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hanzi_learn_keep/model/character_frame.dart';

class CharacterFrameCubit extends Cubit<List<CharacterFrame>> {
  CharacterFrameCubit(List<CharacterFrame> initialState) : super(initialState);
}
