import 'dart:developer';

abstract class Invalidator {
  Future<void> invalidate();
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
    final st = DateTime.now().millisecondsSinceEpoch;
    for (final invalidator in _invalidators) {
      Future.microtask(() async {
        try {
          await invalidator.invalidate();
          print(
              'Repository cache ${invalidator.runtimeType} ${this.runtimeType} invalidates for: ${DateTime.now().millisecondsSinceEpoch - st}ms');
        } catch (e, stack) {
          print('Error during invalidation: $e\n$stack');
        }
      });
    }
  }
}
