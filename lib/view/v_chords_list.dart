import 'package:elbe/elbe.dart';
import 'package:guitarplay/bit/b_chords.dart';

class ChordsListView extends StatelessWidget {
  const ChordsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Box.plain(
      clipBehavior: Clip.none,
      constraints: const RemConstraints(maxHeight: 3.5),
      child: ChordsBit.builder(
          onData: (bit, data) => ListView(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < data.chords.length; i++)
                  Card(
                      scheme: data.index == i
                          ? ColorSchemes.secondary
                          : ColorSchemes.primary,
                      constraints:
                          const RemConstraints(minWidth: 3.5, minHeight: 3.5),
                      onTap: () => bit.selectChord(i),
                      child: Center(child: Text(data.chords[i].name))),
              ].spaced(amount: 1))),
    );
  }
}
