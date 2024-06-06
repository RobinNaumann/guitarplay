import 'dart:math';

import 'package:elbe/bit/bit/bit.dart';
import 'package:elbe/elbe.dart';
import 'package:flutter_piano_audio_detection/flutter_piano_audio_detection.dart';
import 'package:guitarplay/model/tone.dart';
import 'package:guitarplay/service/s_permission.dart';

T maybeSInst<T>(T? i, String name) =>
    i ?? (throw BitError.serviceNotInitialized(name));

abstract class AudioToneService {
  static AudioToneService? _i;
  static void init(AudioToneService i) => _i = _i ?? i;
  static AudioToneService get i => maybeSInst(_i, "AudioToneService");

  MsgBit<List<Tone>> observe();
}

class AudioToneServiceImpl extends AudioToneService {
  final FlutterPianoAudioDetection _fpad = FlutterPianoAudioDetection();

  AudioToneServiceImpl() {
    _fpad.prepare();
  }

  @override
  observe() => Bit.stream(
        (update) async {
          await PermissionService.i.ensureMicrophonePermission();
          _fpad.start();
          return _fpad
              .startAudioRecognition()
              .map((event) => _mapTones(_fpad.getNotes(event)));
        },
        onDispose: () {
          _fpad.stop();
        },
      );

  List<Tone> _mapTones(List<String> tones) => tones
      .map((e) =>
          Tone(e.substring(0, e.length - 1), int.parse(e.characters.last)))
      .toList();
}

class AudioToneServiceMock extends AudioToneService {
  int _seed = 123456;

  @override
  observe() =>
      MsgBit.stream((update) => Stream.periodic(const Duration(seconds: 1))
          .map((event) => (List.of(const [
                Tone("C", 3),
                Tone("C", 4),
                Tone("D", 4),
                Tone("E", 4),
                Tone("F", 4),
                Tone("G", 4)
              ])
                    ..shuffle(Random(_seed++)))
                  .take(Random(_seed++).nextInt(5))
                  .toList()));
}
