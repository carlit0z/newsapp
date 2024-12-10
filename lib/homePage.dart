import 'package:flutter/material.dart';
import 'newsModel.dart';
import 'newsService.dart';
import 'searchPage.dart';
import 'detailNewsPage.dart';
import 'bookmarkPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All'; // Kategori yang dipilih (default: All)
  List<String> categories = ['All', 'Technology', 'Sports', 'Health', 'Science', 'Business']; // Daftar kategori
  late Future<List<NewsModel>> newsList;

  @override
  void initState() {
    super.initState();
    newsList = NewsService().fetchNews(category: selectedCategory); // Fetch berita sesuai kategori
  }

  // Method untuk memilih kategori
  void _selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      newsList = NewsService().fetchNews(category: selectedCategory); // Mengambil berita baru berdasarkan kategori
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F5F2), // Warna latar belakang aplikasi
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan tombol pencarian
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Newsyfy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Arahkan ke halaman pencarian berita
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  },
                ),
                IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookmarkPage(),
                ),
              );
            },
          ),
              ],
            ),
            SizedBox(height: 16),

            // Topik terpopuler (tags)
            Text('Topik Terpopuler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((tag) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        _selectCategory(tag); // Mengubah kategori yang dipilih
                      },
                      child: Chip(
                        label: Text(tag),
                        backgroundColor: selectedCategory == tag ? Color(0xFF8D8F7E) : Colors.grey, // Highlight kategori terpilih
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            // Daftar berita terkini
            Text('Berita Terkini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<NewsModel>>(
                future: newsList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No News Available'));
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
