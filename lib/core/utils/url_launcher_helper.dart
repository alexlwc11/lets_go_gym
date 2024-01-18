import 'package:url_launcher/url_launcher.dart' as url_launcher;

Future<void> launchUrl(String url) async {
  final uri = Uri.parse(url);
  final canLaunch = await url_launcher.canLaunchUrl(uri);
  if (canLaunch) {
    await url_launcher.launchUrl(uri,
        mode: url_launcher.LaunchMode.externalApplication);
  }
}
