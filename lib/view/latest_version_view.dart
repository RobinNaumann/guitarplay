import 'package:elbe/elbe.dart';
import 'package:moewe/moewe.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LatestAppVersionView extends StatelessWidget {
  const LatestAppVersionView({super.key});

  @override
  Widget build(BuildContext context) {
    return moewe.config.isLatestVersion() ?? true
        ? Spaced.zero
        : Card(
            onTap: () => launchUrlString("https://apps.robbb.in",
                mode: LaunchMode.externalApplication),
            scheme: ColorSchemes.secondary,
            child: Row(
              children: [
                const Icon(Icons.loader),
                const Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("new version available", variant: TypeVariants.bold),
                    Text("a new version of the app is available")
                  ],
                )),
              ].spaced(),
            ),
          );
  }
}
