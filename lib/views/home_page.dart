import 'package:flutter/material.dart';
import 'package:flutter_80s_app_clean/models/movie.dart';
import 'package:flutter_80s_app_clean/models/song.dart';
import 'search_page.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  final List<Song> _songs = [
    Song(
        title: 'Take on Me',
        artist: 'a-ha',
        year: 1985,
        youtubeUrl: 'https://www.youtube.com/watch?v=djV11Xbc914'),
    Song(
        title: 'Billie Jean',
        artist: 'Michael Jackson',
        year: 1982,
        youtubeUrl: 'https://www.youtube.com/watch?v=Zi_XLOBDo_Y'),
  ];

  final List<Movie> _movies = [
    Movie(
        title: 'Back to the Future',
        director: 'Robert Zemeckis',
        year: 1985,
        youtubeUrl: 'https://www.youtube.com/watch?v=qvsgGtivCgs'),
    Movie(
        title: 'The Breakfast Club',
        director: 'John Hughes',
        year: 1985,
        youtubeUrl: 'https://www.youtube.com/watch?v=BSXBvor47Zs'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No es pot obrir l\'enllaç: $url';
    }
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1000) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  Widget _buildGrid(List<Widget> items) {
    final crossAxisCount = _calculateCrossAxisCount(context);
    return GridView.count(
      crossAxisCount: crossAxisCount,
      childAspectRatio: 0.85,
      padding: const EdgeInsets.all(8),
      children: items,
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return InkWell(
      onTap: () => _launchURL(movie.youtubeUrl),
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.movie, size: 40),
              const SizedBox(height: 8),
              Text(movie.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${movie.director} • ${movie.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSongCard(Song song) {
    return InkWell(
      onTap: () => _launchURL(song.youtubeUrl),
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.music_note, size: 40),
              const SizedBox(height: 8),
              Text(song.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${song.artist} • ${song.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> movieCards = _movies.map(_buildMovieCard).toList();
    List<Widget> songCards = _songs.map(_buildSongCard).toList();

    List<Widget> tabs = [
      _buildGrid(movieCards),
      _buildGrid([...movieCards, ...songCards]),
      _buildGrid(songCards),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cançons i Pel·lícules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchPage(songs: _songs, movies: _movies),
                ),
              );
            },
          ),
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Pel·lícules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Cançons',
          ),
        ],
      ),
    );
  }
}
