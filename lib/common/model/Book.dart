import 'package:flutter/material.dart' show Widget;

class Book {
  const Book(this.title, this.keyword, this.mainImage, this.readTime, this.body, this.bookImage, this.link);

  final String title;
  final String keyword;
  final String mainImage;
  final int readTime;
  final List<Widget> body;
  final String bookImage;
  final String link;
}