import 'package:flutter/material.dart';
import 'package:flutter_80s_app_clean/models/song.dart';
import 'package:flutter_80s_app_clean/models/movie.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  final List<Song> songs;
  final List<Movie> movies;

  const SearchPage({
    Key? key,
    required this.songs,
    required this.movies,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Song> _filteredSongs;
  late List<Movie> _filteredMovies;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _alphabet =
      List.generate(26, (i) => String.fromCharCode(i + 65));
  String? _selectedLetter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _filteredSongs = widget.songs;
    _filteredMovies = widget.movies;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSongs = widget.songs.where((song) {
        final matchText = song.title.toLowerCase().contains(query) ||
            song.artist.toLowerCase().contains(query) ||
            song.year.toString().contains(query);

        final matchLetter = _selectedLetter == null ||
            song.title.toLowerCase().contains(_selectedLetter!.toLowerCase()) ||
            song.artist.toLowerCase().contains(_selectedLetter!.toLowerCase());

        return matchText && matchLetter;
      }).toList();

      _filteredMovies = widget.movies.where((movie) {
        final matchText = movie.title.toLowerCase().contains(query) ||
            movie.director.toLowerCase().contains(query) ||
            movie.year.toString().contains(query);

        final matchLetter = _selectedLetter == null ||
            movie.title
                .toLowerCase()
                .contains(_selectedLetter!.toLowerCase()) ||
            movie.director
                .toLowerCase()
                .contains(_selectedLetter!.toLowerCase());

        return matchText && matchLetter;
      }).toList();
    });
  }

  Future<void> _launchYoutubeUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No es pot obrir el link de YouTube')),
        );
      }
    }
  }

  Widget _buildLetterGrid() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _alphabet.length,
        itemBuilder: (context, index) {
          final letter = _alphabet[index];
          final isSelected = _selectedLetter == letter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedLetter = letter;
                _performSearch();
              });
            },
            child: Container(
              width: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                letter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildClearLetterButton() {
    if (_selectedLetter == null) return const SizedBox.shrink();
    return TextButton.icon(
      onPressed: () {
        setState(() {
          _selectedLetter = null;
          _performSearch();
        });
      },
      icon: const Icon(Icons.clear),
      label: const Text('Esborrar lletra'),
    );
  }

  Widget _buildSongList(List<Song> songs) {
    if (songs.isEmpty) {
      return const Center(child: Text('No s\'han trobat cançons'));
    }
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          leading: IconButton(
            icon: const Icon(Icons.play_circle_fill),
            onPressed: () => _launchYoutubeUrl(song.youtubeUrl),
          ),
          title: Text(song.title),
          subtitle: Text('${song.artist} • ${song.year}'),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildMovieList(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Center(child: Text('No s\'han trobat pel·lícules'));
    }
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ListTile(
          leading: IconButton(
            icon: const Icon(Icons.play_circle_fill),
            onPressed: () => _launchYoutubeUrl(movie.youtubeUrl),
          ),
          title: Text(movie.title),
          subtitle: Text('${movie.director} • ${movie.year}'),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildCombinedList() {
    final hasSongs = _filteredSongs.isNotEmpty;
    final hasMovies = _filteredMovies.isNotEmpty;

    if (!hasSongs && !hasMovies) {
      return const Center(child: Text('No s\'han trobat resultats'));
    }

    return ListView(
      children: [
        if (hasSongs)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Cançons (${_filteredSongs.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ..._filteredSongs.map((song) => ListTile(
              leading: IconButton(
                icon: const Icon(Icons.play_circle_fill),
                onPressed: () => _launchYoutubeUrl(song.youtubeUrl),
              ),
              title: Text(song.title),
              subtitle: Text('${song.artist} • ${song.year}'),
              onTap: () {},
            )),
        if (hasMovies)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Pel·lícules (${_filteredMovies.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ..._filteredMovies.map((movie) => ListTile(
              leading: IconButton(
                icon: const Icon(Icons.play_circle_fill),
                onPressed: () => _launchYoutubeUrl(movie.youtubeUrl),
              ),
              title: Text(movie.title),
              subtitle: Text('${movie.director} • ${movie.year}'),
              onTap: () {},
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cercador'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Tot'),
            Tab(icon: Icon(Icons.movie), text: 'Pel·lícules'),
            Tab(icon: Icon(Icons.music_note), text: 'Cançons'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildLetterGrid(),
          _buildClearLetterButton(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca cançons o pel·lícules...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCombinedList(),
                _buildMovieList(_filteredMovies),
                _buildSongList(_filteredSongs),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
