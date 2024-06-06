import 'package:elbe/bit/bit/bit.dart';
import 'package:elbe/elbe.dart';
import 'package:flutter/material.dart' as m;
import 'package:guitarplay/bit/b_chords.dart';
import 'package:guitarplay/bit/b_song_play.dart';
import 'package:guitarplay/model/chord.dart';

import '../bit/b_tone.dart';
import '../model/bund.dart';

LayerColor _mapCorrect(ColorStyle s) => s.majorAlertSuccess;
LayerColor _mapForbidden(ColorStyle s) => s.majorAlertError;

enum StringHighlight {
  correct(_mapCorrect, 10),
  forbidden(_mapForbidden, 10);

  const StringHighlight(this.color, this.width);

  final LayerColor Function(ColorStyle s) color;
  final double width;
}

class ChordView extends StatelessWidget {
  final Chord chord;
  final bool testMode;
  final double scale;
  const ChordView(
      {super.key,
      required this.chord,
      this.testMode = false,
      this.scale = 1.1});

  Widget _xoRow() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        for (var c in chord.strings.elements)
          SizedBox(
            width: 20,
            child: c != null
                ? (c > 0
                    ? Container()
                    : m.Icon(m.Icons.circle_outlined, size: 15 * scale))
                : m.Icon(m.Icons.close, size: 20 * scale),
          ),
      ]);

  Widget _string(int i, double boxSize, int bridgeCount, double stringWidth,
          Color color, bool active) =>
      AnimatedContainer(
        margin: EdgeInsets.only(
            left: boxSize * i + (boxSize / 2) - (stringWidth / 2),
            right: (boxSize / 2) - (stringWidth / 2)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular((active || testMode) ? 10 : 0),
                bottom: const Radius.circular(10)),
            color: color),
        width: stringWidth,
        height: bridgeCount * boxSize + 7,
        duration: const Duration(milliseconds: 300),
      );

  Widget _finger(int string, int bridge, double boxSize, LayerColor color) =>
      AnimatedContainer(
          key: Key("S$string"),
          margin: EdgeInsets.only(
              top: boxSize * (bridge - 1), left: boxSize * string),
          width: boxSize,
          height: boxSize,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(boxSize)),
          duration: const Duration(milliseconds: 300),
          child: chord.fingering != null
              ? Center(
                  child: Text(chord.fingering!.get(string).toString(),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      color: color.front,
                      resolvedStyle: TypeStyle(
                          fontSize: 0.8 * scale, variant: TypeVariants.bold)))
              : null);

  @override
  Widget build(BuildContext context) {
    int bridgeCount = 5;
    double boxSize = 20 * scale;
    double lineWidth = 1.5 * scale;
    double stringWidth = 4 * scale;
    double width = boxSize * 5 + stringWidth;

    final colorTheme = ColorTheme.of(context);
    final scheme = colorTheme.activeScheme;
    final LayerColor color = LayerColor(
        back: scheme.front, front: scheme.back, border: Colors.transparent);

    return AudioToneBit.builder(onData: (audioBit, tones) {
      postFrame(() {
        if (chord.matches(tones.map((e) => e.name).toList())) {
          context.maybeBit<ChordsBit>()?.onCorrect(chord.name);
          context.maybeBit<SongPlayBit>()?.next(chord.name);
        }
      });

      Bund<StringHighlight?>? highlights = chord.tones.map((i, e) =>
          (tones.contains(e))
              ? (chord.strings.elements[i] == null
                  ? StringHighlight.forbidden
                  : StringHighlight.correct)
              : null);
      return Column(
        children: [
          Text(
            chord.name,
            textAlign: TextAlign.center,
            style: TypeStyles.h1,
            variant: TypeVariants.bold,
            resolvedStyle: TypeStyle(fontSize: 2.5 * scale),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 25 * scale,
            width: boxSize * 6,
            child: testMode ? Container() : _xoRow(),
          ),

          Container(
              color: testMode ? Colors.transparent : color,
              height: 15,
              width: width),
          Stack(
            clipBehavior: Clip.none,
            children: [
              // bridges
              if (!testMode)
                for (int i = 1; i <= bridgeCount; i++)
                  Container(
                      height: lineWidth,
                      width: boxSize * 5,
                      margin: EdgeInsets.only(
                          left: (boxSize / 2),
                          top: boxSize * i - (lineWidth / 2)),
                      child: Container(color: color)),

              // strings
              for (int i = 0; i < 6; i++)
                _string(
                    i,
                    boxSize,
                    bridgeCount,
                    highlights.get(i)?.width ?? stringWidth,
                    highlights.get(i)?.color.call(scheme) ??
                        (testMode ? color.inter(1) : color),
                    highlights.get(i)?.color != null),
              if (!testMode)
                for (var c in chord.strings.elements.asMap().entries)
                  if ((c.value ?? 0) > 0)
                    _finger(c.key, c.value!, boxSize,
                        highlights.get(c.key)?.color(scheme) ?? color)
            ],
          ),
          //Text.bodyS(tones.map((e) => e.name).join(", ")),
          //Text.bodyS(chord.tones.elements.map((e) => e.name).join(", "))
        ],
      );
    });
  }
}
