import 'package:flutter/material.dart';
import 'newsModel.dart';
import 'newsService.dart';
import 'detailNewsPage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  late Future<List<NewsModel>> searchResults;

  @override
  void initState() {
    super.initState();
    searchResults = Future.value([]); // Inisialisasi dengan list kosong
  }

  // Method untuk mencari berita berdasarkan query
  void _searchNews(String query) {
    if (query.isNotEmpty) {
      setState(() {
        searchResults = NewsService().searchNews(query: query); // Pencarian berdasarkan query
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pencarian Berita'),
        backgroundColor: Color(0xFF8D8F7E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Kolom pencarian
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Berita...',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchNews(_searchController.text); // Panggil fungsi pencarian
                  },
                ),
              ),
              onSubmitted: (query) {
                _searchNews(query); // Panggil fungsi pencarian ketika mengetik "enter"
              },
            ),
            SizedBox(height: 16),

            // Hasil pencarian
            Expanded(
              child: FutureBuilder<List<NewsModel>>(
                future: searchResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada berita yang ditemukan.'));
                  }

                  List<NewsModel> news = snapshot.data!;
                  return ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(news[index].title),
                        subtitle: Text(news[index].publishedAt),
                        leading: news[index].urlToImage.isNotEmpty
                            ? Image.network(news[index].urlToImage, fit: BoxFit.cover, width: 60, height: 60)
                            : null, // Menampilkan gambar jika ada
                        onTap: () {
                          // Arahkan ke halaman DetailNewsPage saat berita diklik
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailNewsPage(news: news[index]),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}