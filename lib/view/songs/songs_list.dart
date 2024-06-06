import 'package:elbe/elbe.dart';
import 'package:guitarplay/repos/jims_songbook/jims_songbook_repo.dart';

import 'song_page.dart';

class SongsList extends StatefulWidget {
  const SongsList({super.key});

  @override
  State<SongsList> createState() => _SongsListState();
}

class _SongsListState extends State<SongsList> {
  final searchCtrl = TextEditingController();
  List<SongEntry> songs = JimsSongbookRepo.listSongs();

  _search(String s) => setState(() => songs = JimsSongbookRepo.listSongs(s));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      title: "Songs",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Box(
              padding: RemInsets(top: 1),
              border: Border.noneRect,
              child: Text(
                  "Songs taken from Jim's Songbook at ozbcoz.com\nDON'T USE THIS APP FOR COMMERCIAL PURPOSES!",
                  textAlign: TextAlign.center,
                  style: TypeStyles.bodyS)),
          Card(
            margin: const RemInsets.all(1),
            padding: const RemInsets.all(0.25),
            child: Row(
              children: [
                const Spaced.horizontal(0.75),
                Expanded(
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: _search,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.all(10), child: Icon(Icons.search))
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (_, i) => ListTile(
                      leading: const Icon(Icons.music),
                      title: Text(songs[i].name),
                      onTap: () => JimsSongbookRepo.getSong(songs[i].id).then(
                          (value) => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => SongPage(song: value))),
                          onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("could not load song"))))))),
        ],
      ),
    );
  }
}
