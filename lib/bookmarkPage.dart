import 'dart:convert'; // Untuk decode JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'newsModel.dart';
import 'detailNewsPage.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<NewsModel> bookmarkedNews = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarkedNews();
  }

  // Memuat berita yang dibookmark dari SharedPreferences
  _loadBookmarkedNews() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedNewsJson = prefs.getStringList('bookmarkedNews') ?? [];

    // Decode berita yang dibookmark
    setState(() {
      bookmarkedNews = bookmarkedNewsJson
          .map((newsJson) => NewsModel.fromJson(jsonDecode(newsJson))) // Decode JSON ke NewsModel
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Berita yang Dibookmark'),
        backgroundColor: Color(0xFF8D8F7E),
      ),
      body: bookmarkedNews.isEmpty
          ? Center(child: Text('Belum ada berita yang dibookmark.'))
          : ListView.builder(
              itemCount: bookmarkedNews.length,
              itemBuilder: (context, index) {
                final news = bookmarkedNews[index];
                return ListTile(
                  title: Text(news.title),
                  subtitle: Text(news.publishedAt),
                  leading: news.urlToImage.isNotEmpty
                      ? Image.network(news.urlToImage, fit: BoxFit.cover, width: 60, height: 60)
                      : null,
                  onTap: () {
                    // Navigasi ke DetailNewsPage saat berita diklik
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailNewsPage(news: news),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
