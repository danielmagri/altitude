import 'package:flutter/material.dart' show TextSpan;

class Book {
  const Book(this.title, this.subtitle, this.body);

  final String title;
  final String subtitle;
  final List<TextSpan> body;

}