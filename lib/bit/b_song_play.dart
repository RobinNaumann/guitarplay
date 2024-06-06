import 'dart:async';

import 'package:elbe/elbe.dart';
import 'package:guitarplay/model/pro_song.dart';

class SongPlayData {
  final ProSong song;
  final bool autoPlay;
  // if null -> song is finished
  final int? line;
  final int part;
  const SongPlayData(this.song, this.line, this.part, this.autoPlay);

  SongPlayData finished() => SongPlayData(song, null, 0, false);
}

class SongPlayBit extends MapMsgBitControl<SongPlayData> {
  static const builder = MapMsgBitBuilder<SongPlayData, SongPlayBit>.make;

  final ProSong song;
  Timer? _autoPlayTimer;

  SongPlayBit({required this.song})
      : super(MsgBit((_) async =>
            SongPlayData(song, song.hasLyrics ? 0 : null, 0, false)));

  void _emitPlaying(int line, int part, bool autoplay) async {
    LineItem item = song.lyrics[line][part];
    emit(SongPlayData(song, line, part, autoplay));
    if (item is PlayedItem && item.chord != null) return;
    _setAutoTimer();
  }

  void _setAutoTimer() =>
      _autoPlayTimer = Timer(const Duration(seconds: 4), () => next());

  void togglePlay(bool play) => state.whenData((data) {
        if (data.line == null) return;
        if (!play) _autoPlayTimer?.cancel();
        if (play) _setAutoTimer();
        emit(SongPlayData(data.song, data.line, data.part, play));
      });

  void next([String? chord]) {
    _autoPlayTimer?.cancel();
    state.whenData((data) {
      final l = data.line ?? 0;
      final p = data.part;
      final item = song.lyrics[l][p];
      if (chord != null && (item is PlayedItem && item.chord?.name != chord)) {
        return;
      }
      (song.lyrics[l].length > (p + 1))
          ? _emitPlaying(l, p + 1, data.autoPlay)
          : ((song.lyrics.length > (l + 1) && song.lyrics[l + 1].isNotEmpty)
              ? _emitPlaying(l + 1, 0, data.autoPlay)
              : emit(data.finished()));
    });
  }
}
