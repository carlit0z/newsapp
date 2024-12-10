import 'dart:convert'; // Untuk encode/decode JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'newsModel.dart';

class DetailNewsPage extends StatefulWidget {
  final NewsModel news;

  DetailNewsPage({required this.news});

  @override
  _DetailNewsPageState createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  // Mengecek apakah berita ini sudah dibookmark sebelumnya
  _checkIfBookmarked() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedNews = prefs.getStringList('bookmarkedNews') ?? [];

    // Periksa apakah berita ini sudah ada dalam daftar bookmark
    setState(() {
      isBookmarked = bookmarkedNews.contains(widget.news.url); // Menyimpan URL sebagai indikator
    });
  }

  // Menambahkan atau menghapus berita dari daftar bookmark
  _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarkedNews = prefs.getStringList('bookmarkedNews') ?? [];

    String newsJson = jsonEncode({
      'title': widget.news.title,
      'description': widget.news.description,
      'urlToImage': widget.news.urlToImage,
      'publishedAt': widget.news.publishedAt,
      'url': widget.news.url,
    });

    if (isBookmarked) {
      bookmarkedNews.remove(newsJson); // Menghapus dari daftar bookmark
    } else {
      bookmarkedNews.add(newsJson); // Menambahkan ke daftar bookmark
    }

    await prefs.setStringList('bookmarkedNews', bookmarkedNews); // Menyimpan perubahan ke SharedPreferences

    setState(() {
      isBookmarked = !isBookmarked; // Perbarui status bookmark di UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Berita'),
        backgroundColor: Color(0xFF8D8F7E),
        actions: [
          // Menambahkan ikon bookmark di AppBar
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.white : Colors.grey, // Warna full putih saat dibookmark
            ),
            onPressed: _toggleBookmark, // Memanggil fungsi untuk menambah/menghapus bookmark
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan judul berita
              Text(
                widget.news.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),

              // Menampilkan tanggal terbit berita
              Text(
                'Published At: ${widget.news.publishedAt}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),

              // Menampilkan gambar berita jika ada
              widget.news.urlToImage.isNotEmpty
                  ? Image.network(widget.news.urlToImage)
                  : Container(),
              SizedBox(height: 16),

              // Menampilkan isi berita (content)
              Text(
                widget.news.description ?? 'No content available.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
