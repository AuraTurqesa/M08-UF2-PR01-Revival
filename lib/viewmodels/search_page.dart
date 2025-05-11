import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String typeFilter = 'Tots';
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allItems = [
    {
      'title': 'Imagine',
      'artist': 'John Lennon',
      'year': 1980,
      'type': 'Cançons'
    },
    {
      'title': 'Bohemian Rhapsody',
      'artist': 'Queen',
      'year': 1975,
      'type': 'Cançons'
    },
    {
      'title': 'The Matrix',
      'director': 'Lana & Lilly Wachowski',
      'year': 1999,
      'type': 'Películes'
    },
    {
      'title': 'Inception',
      'director': 'Christopher Nolan',
      'year': 2010,
      'type': 'Películes'
    },
    {
      'title': 'Blinding Lights',
      'artist': 'The Weeknd',
      'year': 2019,
      'type': 'Cançons'
    },
    {
      'title': 'Interstellar',
      'director': 'Christopher Nolan',
      'year': 2014,
      'type': 'Películes'
    },
  ];
  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchesType = typeFilter == 'Tots' || item['type'] == typeFilter;
        final matchesSearch = query.isEmpty ||
            item['title'].toLowerCase().contains(query) ||
            (item['artist']?.toString().toLowerCase().contains(query) ??
                false) ||
            (item['director']?.toString().toLowerCase().contains(query) ??
                false);
        return matchesType && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['Tots', 'Cançons', 'Películes'].map((type) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: typeFilter == type,
                    onSelected: (_) {
                      setState(() {
                        typeFilter = type;
                        _performSearch();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(child: Text('No s\'han trobat resultats'))
                : ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return ListTile(
                        title: Text(item['title']),
                        subtitle: Text(
                          item['type'] == 'Cançons'
                              ? '${item['artist']} (${item['year']})'
                              : '${item['director']} (${item['year']})',
                        ),
                        trailing: Icon(
                          item['type'] == 'Cançons'
                              ? Icons.music_note
                              : Icons.movie,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
