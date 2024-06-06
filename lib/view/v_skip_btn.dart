import 'package:elbe/bit/bit/bit.dart';
import 'package:elbe/elbe.dart';
import 'package:guitarplay/bit/b_chords.dart';
import 'package:guitarplay/bit/b_tone.dart';
import 'package:guitarplay/model/tone.dart';

class SkipBtnIndicator extends StatefulWidget {
  static const notes = ["E", "A", "D", "G", "B", "E"];
  const SkipBtnIndicator({super.key});

  @override
  State<SkipBtnIndicator> createState() => _SkipBtnIndicatorState();
}

class _SkipBtnIndicatorState extends State<SkipBtnIndicator> {
  int pressed = 0;
  DateTime lastPressed = DateTime.now();

  void onTones(List<Tone> tones, ChordsBit bit) async {
    final ids = tones.map((e) => e.id).toList();
    for (String n in SkipBtnIndicator.notes) {
      if (!ids.contains(n)) return;
    }

    // debounce
    if (DateTime.now().difference(lastPressed).inMilliseconds < 1500) return;

    if (pressed == 1) {
      setState(() {
        pressed = 2;
        lastPressed = DateTime.now();
      });
      await Future.delayed(const Duration(milliseconds: 500));
      bit.next();
      setState(() {
        pressed = 0;
      });
      return;
    }

    setState(() {
      pressed++;
      lastPressed = DateTime.now();
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        pressed = 0;
      });
    });
  }

  @override
  Widget build(context) {
    final cT = ThemeData.fromContext(context).color.activeScheme;
    return ChordsBit.builder(
      onData: (cBit, cData) => AudioToneBit.builder(
        onError: bitEmpty,
        onLoading: bitEmpty,
        onData: (bit, data) {
          postFrame(() => onTones(data, cBit));
          return Column(
            children: [
              Row(
                children: [
                  for (String n in SkipBtnIndicator.notes)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: pressed < 2
                              ? (data.indexWhere((e) => e.id == n) > 0
                                      ? cT.minorAccent
                                      : cT.plain)
                                  .front
                                  .withOpacity(0.3)
                              : cT.minorAccent.front),
                      width: 2,
                      height: 16,
                    ),
                ].spaced(amount: 0.2),
              ),
              Row(
                children: [
                  for (int i = 0; i < 2; i++)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: i < pressed
                              ? cT.minorAccent.front
                              : cT.plain.front.withOpacity(0.3)),
                      width: 6,
                      height: 6,
                    ),
                ].spaced(amount: 0.2),
              ),
            ].spaced(amount: 0.4),
          );
        },
      ),
    );
  }
}
