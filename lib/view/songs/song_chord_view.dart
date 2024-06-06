import 'package:elbe/elbe.dart';
import 'package:guitarplay/model/pro_song.dart';

import '../../bit/b_song_play.dart';
import '../chord_view.dart';

class SongChordView extends StatelessWidget {
  const SongChordView({super.key});

  @override
  Widget build(BuildContext context) {
    return SongPlayBit.builder(
        onError: bitErrorView,
        onLoading: (_, __) =>
            const Center(child: CircularProgressIndicator.adaptive()),
        onData: (bit, d) {
          if (d.line == null) {
            return const SizedBox.shrink();
          }
          final item = d.song.lyrics[d.line!][d.part];
          return item is PlayedItem && item.chord != null
              ? Center(child: ChordView(chord: item.chord!))
              : const SizedBox.shrink();
        });
  }
}
