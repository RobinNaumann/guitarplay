import 'package:elbe/elbe.dart';

import '../../bit/b_song_play.dart';

class SongControlView extends StatelessWidget {
  const SongControlView({super.key});

  @override
  Widget build(BuildContext context) {
    return SongPlayBit.builder(
        onData: (bit, d) => d.line == null
            ? Spaced.zero
            : Card(
                scheme:
                    d.autoPlay ? ColorSchemes.secondary : ColorSchemes.primary,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button.action(
                        onTap: () => bit.next(),
                        icon: Icons.skipForward,
                        label: "next"),
                    Button.action(
                        onTap: () => bit.togglePlay(!d.autoPlay),
                        icon: d.autoPlay ? Icons.pause : Icons.play,
                        label: d.autoPlay ? "pause" : "play"),
                  ],
                )));
  }
}
