import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:book_app/books.dart';

final link = "http://127.0.0.1:3000/book";

class Controller {
  var api = http.Client();

  // GET
  Future<List<Books>> get() async {
    var url = Uri.parse(link);
    var response = await api.get(url);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var bookList = jsonData['data'] as List<dynamic>;
      var books = bookList.map((json) => Books.fromJson(json)).toList();
      return books;
    } else {
      // Tindakan yang ingin Anda lakukan saat response.statusCode bukan 200
      throw Exception('Failed to fetch data');
    }
  }

  Future<Books> post(String title, String author) async {
    var url = Uri.parse(link);
    var body = jsonEncode({"title": title, "author": author});
    var response = await api
        .post(url, body: body, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 201) {
      var jsonData = jsonDecode(response.body);
      var book = Books.fromJson(jsonData);
      return book;
    } else {
      throw Exception('Failed to add book');
    }
  }

  Future<Books> put(String id, String title, String author) async {
    var url = Uri.parse('$link/$id');
    var body = jsonEncode({"title": title, "author": author});
    var response = await api
        .put(url, body: body, headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var book = Books.fromJson(jsonData);
      return book;
    } else {
      throw Exception('Failed to update book');
    }
  }

  Future<void> delete(String id) async {
    var url = Uri.parse('$link/$id');
    var response = await api.delete(url);
    if (response.statusCode == 200) {
      print('Book deleted successfully');
    } else {
      throw Exception('Failed to delete book');
    }
  }
}
