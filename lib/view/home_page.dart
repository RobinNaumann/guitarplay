import 'package:elbe/elbe.dart';
import 'package:guitarplay/bit/b_settings.dart';
import 'package:guitarplay/model/chord.dart';
import 'package:guitarplay/view/latest_version_view.dart';

import 'train_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _btn(BuildContext context,
          {required String label, Widget Function(BuildContext)? builder}) =>
      Card(
          state: builder != null ? ColorStates.neutral : ColorStates.disabled,
          onTap: builder != null
              ? () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: builder))
              : null,
          child: Row(
              children: [
            Expanded(child: Text(label)),
            const Icon(Icons.chevronRight)
          ].spaced()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      leadingIcon: const LeadingIcon.none(),
      title: "GuitarPlay",
      actions: [
        SettingsBit.builder(
            onData: (b, settings) => IconButton.integrated(
                  icon: settings.darkMode ? Icons.sun : Icons.moon,
                  onTap: () => b.setDarkMode(!settings.darkMode),
                ))
      ],
      children: [
        const LatestAppVersionView(),
        _btn(context,
            label: "tune",
            builder: (_) => const TrainPage(chords: [Chord.tuneChord])),
        const Title.h4("train"),
        _btn(context,
            label: "Major Chords",
            builder: (_) => TrainPage(
                chords:
                    Chord.chords.where((e) => e.major && !e.seven).toList())),
        _btn(context,
            label: "Minor Chords",
            builder: (_) => TrainPage(
                chords:
                    Chord.chords.where((e) => !e.major && !e.seven).toList())),
        _btn(context,
            label: "All Chords",
            builder: (_) => TrainPage(chords: Chord.chords)),
        const Title.h4("quiz"),
        _btn(context,
            label: "Major Chords",
            builder: (_) => TrainPage(
                chords: Chord.chords.where((e) => e.major && !e.seven).toList(),
                testMode: true)),
        _btn(context,
            label: "Minor Chords",
            builder: (_) => TrainPage(
                chords:
                    Chord.chords.where((e) => !e.major && !e.seven).toList(),
                testMode: true)),
        _btn(context,
            label: "All Chords",
            builder: (_) => TrainPage(chords: Chord.chords, testMode: true)),
        _btn(
          context, label: "Songs", //builder: (_) => const SongsList()
        ),
        const Padded(
            padding: RemInsets(top: 1),
            child: Text.bodyS(
              "App by Robin & Nadine",
              textAlign: TextAlign.center,
            ))
      ].spaced(),
    );
  }
}
