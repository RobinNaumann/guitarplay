import 'package:elbe/elbe.dart';
import 'package:guitarplay/model/tone.dart';
import 'package:guitarplay/service/s_audio_tone.dart';

class AudioToneBit extends MapMsgBitControl<List<Tone>> {
  static const builder = MapMsgBitBuilder<List<Tone>, AudioToneBit>.make;

  AudioToneBit() : super(AudioToneService.i.observe());
}
