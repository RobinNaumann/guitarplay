import 'package:elbe/elbe.dart';
import 'package:guitarplay/bit/b_chords.dart';
import 'package:guitarplay/view/v_chords_list.dart';
import 'package:guitarplay/view/v_skip_btn.dart';

import 'chord_view.dart';

class ChordsTrainView extends StatelessWidget {
  const ChordsTrainView({super.key});

  static Widget limitedClip(bool wide, Widget child) => !wide
      ? child
      : ClipRRect(
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.hardEdge,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: child,
          ));

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 450;
    return ChordsBit.builder(
      onData: (chordsBit, state) => Flex(
        direction: wide ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: state.isFinished
                  ? Icon(Icons.checkCircle,
                      color: ColorTheme.of(context)
                          .activeScheme
                          .majorAlertSuccess
                          .back,
                      style: TypeStyles.h1)
                  : Flex(
                      direction: wide ? Axis.horizontal : Axis.vertical,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ChordView(
                            chord: state.chord!,
                            scale: wide ? 1.3 : 1.4,
                            testMode: (state.isTest && !state.showHint)),
                        const SizedBox(height: 50),
                        AnimatedOpacity(
                          opacity: state.isCorrect ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(MaterialIcons.check_circle,
                              color: Colors.teal, style: TypeStyles.h2),
                        ),
                      ].spaced(),
                    ),
            ),
          ),
          ChordsTrainView.limitedClip(
            wide,
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const ChordsListView(),
                Card(
                  scheme: ColorSchemes.secondary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /*TextButton.icon(
                      onPressed: running ? stop : start,
                      icon:
                          Icon(running ? Icons.mic_rounded : Icons.mic_off_rounded),
                      label: Text(running ? "running" : "stopped")),*/
                      Button.action(
                          onTap: chordsBit.next,
                          icon: Icons.skipForward,
                          label: "skip"),
                      GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (_) {
                                return Padded.all(
                                  child: Center(
                                    child: Card(
                                        child: Text(
                                            "play all strings (without placing fingers) twice to skip without touching the screen.")),
                                  ),
                                );
                              }),
                          child: const SkipBtnIndicator()),
                      if (state.isTest)
                        Button.action(
                            onTap: () => chordsBit.showHint(!state.showHint),
                            icon: MaterialIcons.question_mark_rounded,
                            label: state.showHint ? "hide" : "show"),
                    ],
                  ),
                ),
              ].spaced(),
            ),
          ),
        ].spaced(),
      ),
    );
  }
}
