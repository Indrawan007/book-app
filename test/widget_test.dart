// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:book_app/books.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<List<Books>> fetchBooks() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:3000/book'));

    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body);
      final List<Books> books = [];
      for (var jsonItem in jsonList['data']) {
        books.add(Books.fromJson(jsonItem));
      }
      for (var book in books) {
        print('Title: ${book.title}');
        print('Author: ${book.author}');
        print('-------------------------');
      }
      return books;
    } else {
      throw Exception('Failed to fetch books');
    }
  }
}
