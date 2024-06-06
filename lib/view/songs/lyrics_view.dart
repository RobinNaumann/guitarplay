import 'package:elbe/elbe.dart';
import 'package:guitarplay/bit/b_song_play.dart';
import 'package:guitarplay/model/pro_song.dart';

class LyricsView extends StatelessWidget {
  const LyricsView({super.key});

  Widget _drawRow(List<LineItem> line, int? current) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < line.length; i++)
          Flexible(
            fit: FlexFit.loose,
            flex: line[i].text.length ~/ 2 + 1,
            child: line[i] is PlayedItem
                ? _ChordItemView(
                    item: line[i] as PlayedItem,
                    preview: current == null,
                    selected: i == current)
                : const Text("line is comment"),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SongPlayBit.builder(
        onLoading: (_, __) =>
            const Center(child: CircularProgressIndicator.adaptive()),
        onData: (cubit, d) => d.line == null
            ? const Center(child: Icon(Icons.check))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (d.line! > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: _drawRow(d.song.lyrics[d.line! - 1], null),
                    ),
                  _drawRow(d.song.lyrics[d.line!], d.part),
                  if (d.song.lyrics.length > (d.line! + 1))
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: _drawRow(d.song.lyrics[d.line! + 1], null),
                    )
                ],
              ));
  }
}

class _ChordItemView extends StatelessWidget {
  final PlayedItem item;
  final bool preview;
  final bool selected;

  const _ChordItemView(
      {required this.item, this.preview = false, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      scheme: selected ? ColorSchemes.secondary : ColorSchemes.primary,
      border: selected ? null : Border.none,
      padding: const RemInsets.all(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.chord?.name ?? "",
            variant: TypeVariants.bold,
            style: TypeStyles.bodyL,
            colorStyle: selected ? ColorStyles.minorAccent : null,
          ),
          Text(
            item.text.trim(),
            colorStyle: selected ? ColorStyles.minorAccent : null,
          )
        ],
      ),
    );
  }
}
