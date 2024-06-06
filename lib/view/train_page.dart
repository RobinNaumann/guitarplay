import 'package:elbe/elbe.dart';
import 'package:guitarplay/bit/b_chords.dart';
import 'package:guitarplay/model/chord.dart';

import '../bit/b_tone.dart';
import 'chords_train_view.dart';

class TrainPage extends StatelessWidget {
  final List<Chord> chords;
  final bool testMode;
  const TrainPage({super.key, required this.chords, this.testMode = false});

  @override
  Widget build(BuildContext context) {
    return BitProvider(
      create: (c) => AudioToneBit(),
      child: BitProvider(
        create: (c) => ChordsBit(chords: chords, isTest: testMode),
        child: Scaffold(
          title: testMode ? "quiz" : "practice",
          child: Padded.all(child: const ChordsTrainView()),
        ),
      ),
    );
  }
}
