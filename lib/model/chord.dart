import 'package:elbe/elbe.dart';

import 'bund.dart';
import 'tone.dart';

class Chord {
  static const List<Tone> guitarStrings = [
    Tone("E", 2),
    Tone("A", 2),
    Tone("D", 3),
    Tone("G", 3),
    Tone("B", 3),
    Tone("E", 4)
  ];

  final String tone;
  final bool major;
  final bool seven;

  final Bund<int?> strings;
  final Bund<int?>? fingering;
  const Chord(
      {required this.tone,
      this.major = true,
      this.seven = false,
      required this.strings,
      this.fingering});

  String get name => "$tone${major ? '' : 'm'}${seven ? '7' : ''}";
  String get tabString => strings.elements.join(" ").replaceAll("null", "x");

  Bund<Tone> get tones => Bund.fromList(strings.elements
      .mapIndexed((i, e) => guitarStrings[i].added(e ?? 0))
      .toList());

  List<String> get played => strings.elements
      .mapIndexed((i, e) => e != null ? guitarStrings[i].added(e).name : null)
      .whereNotNull()
      .toList();

  List<String> get forbidden => strings.elements
      .mapIndexed((i, e) => e != null ? null : guitarStrings[i].name)
      .whereNotNull()
      .toList();

  bool matches(List<String> tones) {
    for (var t in forbidden) {
      if (tones.contains(t)) return false;
    }
    for (var t in played) {
      if (!tones.contains(t)) return false;
    }
    return true;
  }

  static const Chord tuneChord =
      Chord(strings: Bund(0, 0, 0, 0, 0, 0), tone: "tune");

  static Chord unknown(String? name) => Chord(
      strings: const Bund(null, null, null, null, null, null), tone: "? $name");

  static List<Chord> chords = const [
    Chord(
      strings: Bund(null, 3, 2, 0, 1, 0),
      fingering: Bund(null, 3, 2, null, 1, null),
      tone: "C",
    ),
    Chord(
      fingering: Bund(null, 1, 3, 4, 2, 1),
      strings: Bund(null, 5, 5, 4, 3, 3),
      tone: "C",
      major: false,
    ),
    Chord(
      fingering: Bund(null, 1, 3, 1, 4, 1),
      strings: Bund(null, 3, 5, 3, 5, 3),
      tone: "C",
      seven: true,
    ),

    Chord(
      fingering: Bund(3, 2, null, null, null, 4),
      strings: Bund(3, 2, 0, 0, 0, 3),
      tone: "G",
    ),
    Chord(
      fingering: Bund(1, 3, 4, 1, 1, 1),
      strings: Bund(3, 5, 5, 3, 3, 3),
      tone: "G",
      major: false,
    ),
    Chord(
      fingering: Bund(3, 2, null, null, null, 1),
      strings: Bund(3, 2, 0, 0, 0, 1),
      tone: "G",
      seven: true,
    ),

    Chord(
      fingering: Bund(null, 2, 3, 1, null, null),
      strings: Bund(0, 2, 2, 1, 0, 0),
      tone: "E",
    ),
    Chord(
      fingering: Bund(null, 2, 3, null, null, null),
      strings: Bund(0, 2, 2, 0, 0, 0),
      tone: "E",
      major: false,
    ),
    Chord(
      fingering: Bund(null, 2, 3, 1, 4, null),
      strings: Bund(0, 2, 2, 1, 3, 0),
      tone: "E",
      seven: true,
    ),

    Chord(
      fingering: Bund(1, 3, 4, 2, 1, 1),
      strings: Bund(1, 3, 3, 2, 1, 1),
      tone: "F",
    ),
    Chord(
      fingering: Bund(1, 3, 4, 1, 1, 1),
      strings: Bund(1, 3, 3, 1, 1, 1),
      tone: "F",
      major: false,
    ),
    //Chord(strings: Bund(1, 3, 3, 2, 1, 1),tone: "F",seven: true),

    Chord(
      fingering: Bund(null, null, 1, 2, 3, null),
      strings: Bund(null, 0, 2, 2, 2, 0),
      tone: "A",
    ),
    Chord(
      fingering: Bund(null, null, 2, 3, 1, null),
      strings: Bund(null, 0, 2, 2, 1, 0),
      tone: "A",
      major: false,
    ),
    Chord(
      fingering: Bund(null, null, 1, 2, 3, 4),
      strings: Bund(null, 0, 2, 2, 2, 3),
      tone: "A",
      seven: true,
    ),

    Chord(
      fingering: Bund(null, null, null, 1, 3, 2),
      strings: Bund(null, null, 0, 2, 3, 2),
      tone: "D",
    ),
    Chord(
      fingering: Bund(null, null, null, 2, 4, 1),
      strings: Bund(null, null, 0, 2, 3, 1),
      tone: "D",
      major: false,
    ),
    Chord(
      fingering: Bund(null, null, null, 2, 1, 3),
      strings: Bund(null, null, 0, 2, 1, 2),
      tone: "D",
      seven: true,
    ),

    Chord(
      fingering: Bund(null, 1, 2, 3, 4, 1),
      strings: Bund(null, 2, 4, 4, 4, 2),
      tone: "B",
    ),
    Chord(
      fingering: Bund(null, 1, 3, 4, 2, 1),
      strings: Bund(null, 2, 4, 4, 3, 2),
      tone: "B",
      major: false,
    ),
    Chord(
      fingering: Bund(null, 2, 1, 3, null, 4),
      strings: Bund(null, 2, 1, 2, 0, 2),
      tone: "B",
      seven: true,
    ),
  ];
}
