import 'package:language_parser_desktop/persistence/entities/word_entity.dart';
import 'package:language_parser_desktop/persistence/entities/word_list.dart';
import 'package:language_parser_desktop/persistence/repositories/word_repository.dart';

class WordService {
  final WordRepository _wordRepository;

  WordService(this._wordRepository);

  Set<int> getAllPosIDsByLang(int langId) {
    return _wordRepository.getAllPosIDsByLang(langId);
  }

  Word saveWord(WordCreatingModel model) {
    return _wordRepository.save(model);
  }

  List<WordList> getWords(int size, String string) {
    return _wordRepository.getWords(size, string);
  }
}
