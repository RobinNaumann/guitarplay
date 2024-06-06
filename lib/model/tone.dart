class Tone {
  static const List<String> halftones = [
    "C",
    "C#",
    "D",
    "D#",
    "E",
    "F",
    "F#",
    "G",
    "G#",
    "A",
    "A#",
    "B"
  ];

  final int octave;
  final String id;
  const Tone(this.id, this.octave);

  String get name => "$id$octave";

  Tone added(int steps) {
    int index = halftones.indexOf(id);
    int added = index + steps;
    int newOct = octave + (added >= halftones.length ? 1 : 0);
    int newId = added % halftones.length;
    return Tone(halftones[newId], newOct);
  }

  @override
  String toString() => name;

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(Object other) => other.hashCode == hashCode;
}
