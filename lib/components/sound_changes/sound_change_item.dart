class SoundChangeItem {
  final int id;
  final String initialSoundChange;
  String soundChange;
  final String from;
  final String to;
  final String left;
  final String right;

  SoundChangeItem({
    required this.id,
    required this.initialSoundChange,
    required this.soundChange,
    required this.from,
    required this.to,
    required this.left,
    required this.right,
  });
}
