import 'package:bloc/bloc.dart';
import '../../data/characters_model.dart';
import '../../data/quote.dart';
import '../../data/repository.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  CharactersCubit(this.repository) : super(CharactersInitial());

  final Repository repository;

  List<CharactersModel> characters = [];

  List<CharactersModel> getAllCharacters() {
    repository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters: characters));
      this.characters = characters;
    });
    return characters;
  }

  void getQuotes(String characterName) {
    repository.getQuote(characterName).then((quotes) {
      emit(QuotesLoaded(quotes: quotes));
    });
  }
}


//! with all do respect //Faction with all do respect sir
