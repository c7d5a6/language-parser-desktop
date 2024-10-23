import 'dart:developer';

abstract class Invalidator {
  void invalidate();
}

abstract interface class LanguageRepositoryInvalidator extends Invalidator {
  @override
  void invalidate() {
    invalidateLanguages();
  }

  void invalidateLanguages();
}

mixin RepositoryCache<T extends Invalidator> {
  List<T> _invalidators = [];

  void addInvalidator(T invalidator) {
    _invalidators.add(invalidator);
  }

  void removeInvalidator(T invalidator) {
    log('Remove invalidator $invalidator');
    final removed = _invalidators.remove(invalidator);
    log('Removed: $removed');
  }

  void invalidate() {
    _invalidators.forEach((invalidator) {
      invalidator.invalidate();
    });
  }
}
