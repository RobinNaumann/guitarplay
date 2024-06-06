import 'package:elbe/elbe.dart';
import 'package:elbe/util/m_data.dart';

class Settings extends DataModel {
  final bool darkMode;
  const Settings(this.darkMode);

  Settings copyWith({bool? darkMode}) => Settings(darkMode ?? this.darkMode);

  @override
  get map => {"darkMode": darkMode};
}

class SettingsBit extends MapMsgBitControl<Settings> {
  static const builder = MapMsgBitBuilder<Settings, SettingsBit>.make;

  SettingsBit()
      : super.worker((update) => const Settings(false),
            initial: const Settings(false));

  void setDarkMode(bool v) =>
      state.whenData((data) => emit(data.copyWith(darkMode: v)));
}
