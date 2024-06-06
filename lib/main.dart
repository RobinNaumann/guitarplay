import 'package:elbe/elbe.dart';
import 'package:guitarplay/bit/b_settings.dart';
import 'package:guitarplay/service/s_audio_tone.dart';
import 'package:moewe/moewe.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'view/home_page.dart';

void main() async {
  await Moewe(
    host: "moewe.robbb.in",
    project: "d66337418f6a11ee",
    app: "8858ff6ff6728d73",
  ).init();

  moewe.events.appOpen();
  moewe.crashLogged(() async {
    WidgetsFlutterBinding.ensureInitialized();
    WakelockPlus.enable();

    // enable services
    AppInfoService.init(await BasicAppInfoService.make());
    LoggerService.init(ConsoleLoggerService());
    AudioToneService.init(await AppInfoService.i.deviceIsPhysical
        ? AudioToneServiceImpl()
        : AudioToneServiceMock());

    // set app meta info
    moewe.setAppVersion(AppInfoService.i.version, AppInfoService.i.buildNr);

    runApp(const MyApp());
  });
}

final router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomePage())
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BitBuildProvider(
      create: (_) => SettingsBit(),
      onData: (bit, Settings settings) => ElbeApp(
          theme: ThemeData.preset(),
          mode: settings.darkMode ? ColorModes.dark : ColorModes.light,
          router: router),
    );
  }
}
