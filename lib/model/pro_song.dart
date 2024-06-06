import 'package:collection/collection.dart';
import 'package:elbe/util/m_data.dart';

import 'chord.dart';

class LineItem extends DataModel {
  final String text;
  const LineItem(this.text);

  @override
  get map => {"text": text};
}

class CommentItem extends LineItem {
  const CommentItem(super.text);
}

class PlayedItem extends LineItem {
  final Chord? chord;
  const PlayedItem(super.text, this.chord);

  @override
  get map => {"text": text, "chord": chord};
}

class ProSong {
  final String? title;
  final String? artist;
  final String? key;
  final List<List<LineItem>> lyrics;

  const ProSong({this.title, this.artist, this.key, required this.lyrics});

  bool get hasLyrics => lyrics.isNotEmpty && lyrics.first.isNotEmpty;

  factory ProSong.parse(String chordPro) {
    final title =
        RegExp(r'(?<={t:|{title:).*(?=})').allMatches(chordPro).firstOrNull?[0];
    final artist =
        RegExp(r'(?<={artist:).*(?=})').allMatches(chordPro).firstOrNull?[0];

    final List<List<LineItem>> lyrics = [];

    //TODO: parse comments
    for (String l in chordPro.split("\n").where((e) => !e.startsWith("{"))) {
      List<LineItem> line = [];
      final ms = RegExp(r'(?:\[([^\]]*)\])?([^\[\n]*)').allMatches(l);
      for (final m in ms) {
        final c = m[1] == null
            ? null
            : Chord.chords.firstWhere((e) => e.name == m[1],
                orElse: () => Chord.unknown(m[1]));
        line.add(PlayedItem(m[2] ?? "", c));
        line.removeWhere(
            (e) => e.text.isEmpty && (e is PlayedItem && e.chord == null));
      }
      lyrics.add(line);
      lyrics.removeWhere(
          (e) => e.length == 1 && e.first.text.contains("youtube.com"));
    }
    return ProSong(title: title, artist: artist, lyrics: lyrics);
  }
}
