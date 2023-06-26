import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState(); // ye wali line
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _searchHistory = [];
  List<dynamic> _trendingMovies = [];
  List<dynamic> _searchResults = [];
  final List<dynamic> _recentlyViewedMovies = [];

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchTrendingMovies() async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/trending/movie/day?api_key=50629cc17faaf6b732d9f32b9297eadd'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _trendingMovies = json.decode(response.body)['results'];
      });
    }
  }

  void searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=50629cc17faaf6b732d9f32b9297eadd&query=$query'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body)['results'];
      });
    }
  }

  void clearSearchResults() {
    setState(() {
      _searchResults.clear();
    });
  }

  void _searchMovie(String query) {
    setState(() {
      if (_searchHistory.contains(query)) {
        _searchHistory.remove(query);
      }
      _searchHistory.insert(0, query);
    });

    if (query.isEmpty) {
      clearSearchResults();
    } else {
      searchMovies(query);
    }

    _searchController.clear();
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  void _openMovieDetails(dynamic movie) {
    setState(() {
      if (_recentlyViewedMovies.contains(movie)) {
        _recentlyViewedMovies.remove(movie);
      }
      _recentlyViewedMovies.add(movie);
    });

    Navigator.pushNamed(
      context,
      '/movie_details',
      arguments: movie,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchMovie(_searchController.text);
                  },
                ),
              ),
              onSubmitted: _searchMovie,
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _searchHistory.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Chip(
                    label: Text(_searchHistory[index]),
                    onDeleted: () {
                      setState(() {
                        _searchHistory.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _openMovieDetails(_searchResults[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w200${_searchResults[index]['poster_path']}',
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          _searchResults[index]['title'],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : Column(
              children: [
                const SizedBox(height: 5.0),
                const Text(
                  '💥 T r e n d i n g   M o v i e s 💥',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(

                  child: PageView.builder(
                    itemCount: _trendingMovies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _openMovieDetails(_trendingMovies[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/w200${_trendingMovies[index]['poster_path']}',
                                width: 250,
                                height: 270,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                _trendingMovies[index]['title'],
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'R e c e n t l y   V i e w e d',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recentlyViewedMovies.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            _openMovieDetails(_recentlyViewedMovies[index]);
                          },
                          child: Column(
                            children: [
                              Image.network(
                                'https://image.tmdb.org/t/p/w200${_recentlyViewedMovies[index]['poster_path']}',
                                width: 75,
                                height: 120,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                _recentlyViewedMovies[index]['title'],
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
