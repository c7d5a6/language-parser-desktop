import 'dart:developer';

abstract class Invalidator {
  void invalidate();
}

mixin RepositoryCache {
  List<Invalidator> _invalidators = [];

  void addInvalidator(Invalidator invalidator) {
    _invalidators.add(invalidator);
  }

  void removeInvalidator(Invalidator invalidator) {
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