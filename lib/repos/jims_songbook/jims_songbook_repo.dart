import 'package:elbe/elbe.dart';
import 'package:guitarplay/model/pro_song.dart';
import 'package:http/http.dart' as http;

part './jims_songbook_repo_entries.dart';

class _Entry {
  final String path;
  final String title;
  final bool warning;
  const _Entry({required this.path, required this.title, this.warning = false});
}

class SongEntry {
  final String id;
  final String name;
  const SongEntry(this.id, this.name);

  factory SongEntry.fromEntry(_Entry e) => SongEntry(e.path, e.title);
}

class JimsSongbookRepo {
  static const _baseUrl = "https://ozbcoz.com/Songs/";

  static List<SongEntry> listSongs([String search = ""]) => entries
      .where((e) => e.title.toLowerCase().contains(search.toLowerCase()))
      .map(SongEntry.fromEntry)
      .toList();

  static Future<ProSong> getSong(String id) =>
      http.get(Uri.parse("$_baseUrl$id")).then((v) => ProSong.parse(v.body),
          onError: (e) => log.e(JimsSongbookRepo, e));
}
