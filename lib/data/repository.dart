import 'api_call.dart';
import 'characters_model.dart';
import 'quote.dart';

class Repository {
  final APICall call;

  Repository(this.call);

  Future<List<CharactersModel>> getAllCharacters() async {
    final characters = await call.getData();
    return characters
        .map((character) => CharactersModel.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getQuote(String characterName) async {
    final quotes = await call.getQuote(characterName);
    return quotes.map((quote) => Quote.fromJson(quote)).toList();
  }
}
