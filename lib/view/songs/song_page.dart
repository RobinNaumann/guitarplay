import 'package:elbe/elbe.dart';
import 'package:guitarplay/bit/b_tone.dart';
import 'package:guitarplay/view/chords_train_view.dart';
import 'package:guitarplay/view/songs/v_song_controls.dart';

import '../../model/pro_song.dart';
import '../../bit/b_song_play.dart';
import 'lyrics_view.dart';
import 'song_chord_view.dart';

class SongPage extends StatelessWidget {
  final ProSong song;
  const SongPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 450;
    return BitProvider(
      create: (context) => AudioToneBit(),
      child: BitProvider(
        create: (_) => SongPlayBit(song: song),
        child: Scaffold(
          title: song.title ?? "Song",
          child: Padded.all(
            child: Flex(
              direction: wide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: LyricsView()),
                ChordsTrainView.limitedClip(
                    wide,
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(child: SongChordView()),
                            SongControlView()
                          ]),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
