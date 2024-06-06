import 'package:elbe/elbe.dart';
import 'package:elbe/util/m_data.dart';
import 'package:guitarplay/model/chord.dart';

class ChordsState extends DataModel {
  final bool isTest;
  final List<Chord> chords;
  final int? index;
  final bool isCorrect;
  final bool showHint;

  ChordsState({
    required this.isTest,
    required this.chords,
    required this.index,
    required this.isCorrect,
    required this.showHint,
  });

  Chord? get chord => index != null ? chords[index!] : null;
  bool get isFinished => index == null;

  ChordsState copyWith({
    bool? isTest,
    List<Chord>? chords,
    int? index,
    bool? isCorrect,
    bool? showHint,
  }) =>
      ChordsState(
        isTest: isTest ?? this.isTest,
        chords: chords ?? this.chords,
        index: (index ?? 0) > (this.chords.length - 1)
            ? null
            : (index ?? this.index),
        isCorrect: isCorrect ?? this.isCorrect,
        showHint: showHint ?? this.showHint,
      );

  @override
  get map => {
        "isTest": isTest,
        "chords": chords,
        "index": index,
        "isCorrect": isCorrect,
        "showHint": showHint,
      };
}

class ChordsBit extends MapMsgBitControl<ChordsState> {
  static const builder = MapMsgBitBuilder<ChordsState, ChordsBit>.make;
  final bool isTest;
  final List<Chord> chords;

  ChordsBit({required this.chords, this.isTest = false})
      : super.worker((update) => ChordsState(
            isTest: isTest,
            chords: chords,
            index: 0,
            isCorrect: false,
            showHint: false));

  void onCorrect(String name) => state.whenData((d) async {
        if (name != d.chord?.name || d.isCorrect) return;
        emit(d.copyWith(isCorrect: true));
        await Future.delayed(const Duration(milliseconds: 500));
        state.whenData((nd) => nd.chord?.name == d.chord!.name ? next() : null);
      });

  void next() => state.whenData((d) => d.isFinished
      ? null
      : emit(
          d.copyWith(index: d.index! + 1, isCorrect: false, showHint: false)));

  void selectChord(int chordIndex) => state.whenData((d) => chordIndex
              .isNegative ||
          chordIndex >= d.chords.length
      ? null
      : emit(d.copyWith(index: chordIndex, isCorrect: false, showHint: false)));

  void showHint(bool show) =>
      state.whenData((d) => emit(d.copyWith(showHint: show)));
}
