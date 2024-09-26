import 'package:language_parser_desktop/persistence/word_repository.dart';

class WordService {
  final WordRepository _wordRepository;

  WordService(this._wordRepository);

  Future<List<wrd>> getWords(int size, String string) async {
    return _wordRepository.getWords(size, string);
  }
}
