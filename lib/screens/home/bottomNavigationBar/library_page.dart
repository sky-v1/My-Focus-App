import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.book), text: 'Books'),
            Tab(icon: Icon(Icons.music_note), text: 'Music'),
            Tab(icon: Icon(Icons.movie), text: 'Movies'),
            Tab(icon: Icon(Icons.article), text: 'Articles'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBooksTab(),
          _buildMusicTab(),
          _buildMoviesTab(),
          _buildArticlesTab(),
        ],
      ),
    );
  }

  Widget _buildBooksTab() {
    final List<Map<String, dynamic>> books = [
      {
        'title': 'The Great Gatsby',
        'author': 'F. Scott Fitzgerald',
        'coverUrl': 'https://example.com/great_gatsby.jpg',
        'rating': 4.5,
      },
      {
        'title': '1984',
        'author': 'George Orwell',
        'coverUrl': 'https://example.com/1984.jpg',
        'rating': 4.7,
      },
      {
        'title': 'To Kill a Mockingbird',
        'author': 'Harper Lee',
        'coverUrl': 'https://example.com/mockingbird.jpg',
        'rating': 4.8,
      },
      {
        'title': 'The Hobbit',
        'author': 'J.R.R. Tolkien',
        'coverUrl': 'https://example.com/hobbit.jpg',
        'rating': 4.6,
      },
      {
        'title': 'Pride and Prejudice',
        'author': 'Jane Austen',
        'coverUrl': 'https://example.com/pride.jpg',
        'rating': 4.4,
      },
    ];

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade200,
              child: const Icon(Icons.book),
            ),
            title: Text(book['title']),
            subtitle: Text(book['author']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text(book['rating'].toString()),
              ],
            ),
            onTap: () {
              // Navigate to book details
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected: ${book['title']}')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMusicTab() {
    final List<Map<String, dynamic>> songs = [
      {
        'title': 'Bohemian Rhapsody',
        'artist': 'Queen',
        'album': 'A Night at the Opera',
        'duration': '5:55',
      },
      {
        'title': 'Imagine',
        'artist': 'John Lennon',
        'album': 'Imagine',
        'duration': '3:03',
      },
      {
        'title': 'Like a Rolling Stone',
        'artist': 'Bob Dylan',
        'album': 'Highway 61 Revisited',
        'duration': '6:13',
      },
      {
        'title': 'Billie Jean',
        'artist': 'Michael Jackson',
        'album': 'Thriller',
        'duration': '4:54',
      },
      {
        'title': 'Smells Like Teen Spirit',
        'artist': 'Nirvana',
        'album': 'Nevermind',
        'duration': '5:01',
      },
    ];

    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade200,
              child: const Icon(Icons.music_note),
            ),
            title: Text(song['title']),
            subtitle: Text('${song['artist']} • ${song['album']}'),
            trailing: Text(song['duration']),
            onTap: () {
              // Play music logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Playing: ${song['title']}')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildMoviesTab() {
    final List<Map<String, dynamic>> movies = [
      {
        'title': 'The Shawshank Redemption',
        'director': 'Frank Darabont',
        'year': 1994,
        'genre': 'Drama',
      },
      {
        'title': 'The Godfather',
        'director': 'Francis Ford Coppola',
        'year': 1972,
        'genre': 'Crime, Drama',
      },
      {
        'title': 'The Dark Knight',
        'director': 'Christopher Nolan',
        'year': 2008,
        'genre': 'Action, Crime, Drama',
      },
      {
        'title': 'Pulp Fiction',
        'director': 'Quentin Tarantino',
        'year': 1994,
        'genre': 'Crime, Drama',
      },
      {
        'title': 'Forrest Gump',
        'director': 'Robert Zemeckis',
        'year': 1994,
        'genre': 'Drama, Romance',
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.indigo.shade200,
                child: Icon(Icons.movie, size: 48, color: Colors.indigo.shade800),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('Director: ${movie['director']}', 
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('${movie['year']} • ${movie['genre']}',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArticlesTab() {
    final List<Map<String, dynamic>> articles = [
      {
        'title': 'The Future of AI in Healthcare',
        'author': 'Dr. Sarah Johnson',
        'date': '2024-02-15',
        'readTime': '5 min',
      },
      {
        'title': 'Climate Change: What You Need to Know',
        'author': 'Prof. Michael Chen',
        'date': '2024-02-10',
        'readTime': '8 min',
      },
      {
        'title': 'The Rise of Remote Work',
        'author': 'Emma Williams',
        'date': '2024-02-05',
        'readTime': '4 min',
      },
      {
        'title': 'Understanding Blockchain Technology',
        'author': 'James Peterson',
        'date': '2024-01-28',
        'readTime': '7 min',
      },
      {
        'title': 'Mindfulness Practices for Better Mental Health',
        'author': 'Dr. Lisa Thompson',
        'date': '2024-01-20',
        'readTime': '6 min',
      },
    ];

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      article['author'],
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      article['date'],
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(article['readTime']),
                      backgroundColor: Colors.orange.shade100,
                      labelStyle: TextStyle(color: Colors.orange.shade800),
                    ),
                    TextButton(
                      onPressed: () {
                        // Read article logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Reading: ${article['title']}')),
                        );
                      },
                      child: const Text('Read'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}