import 'package:flutter/material.dart';
import 'package:book_app/controller.dart';
import 'package:book_app/books.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Controller();
  List<Books> books = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<Books> fetchedBooks = await controller.get();
      setState(() {
        books = fetchedBooks;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await controller.delete(id);
      print('Book deleted successfully');
      fetchData();
    } catch (error) {
      print('Error deleting book: $error');
    }
  }

  Future<void> navigateToAddDataPage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddDataPage(),
      ),
    ).then((value) {
      if (value != null && value is bool && value) {
        fetchData();
      }
    });
  }

  Future<void> navigateToEditDataPage(Books book) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDataPage(book: book),
      ),
    );
    if (result != null && result is bool && result) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Book App'),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            title: Text(book.title ?? 'Unknown'),
            subtitle: Text(book.author ?? 'Unknown'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    deleteBook(book.id?.oid ?? 'a');
                  },
                  icon: Icon(Icons.delete),
                ),
                IconButton(
                  onPressed: () {
                    navigateToEditDataPage(book);
                  },
                  icon: Icon(Icons.edit),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToAddDataPage();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddDataPage extends StatefulWidget {
  const AddDataPage({Key? key}) : super(key: key);

  @override
  _AddDataPageState createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final controller = Controller();

  Future<void> addBook() async {
    String title = _titleController.text;
    String author = _authorController.text;

    _titleController.clear();
    _authorController.clear();

    try {
      await controller.post(title, author);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );

      // Refresh data di halaman HomePage setelah berhasil menambahkan buku
      final homePageState = context.findAncestorStateOfType<_HomePageState>();
      if (homePageState != null) {
        homePageState.fetchData();
      }
    } catch (error) {
      print('Error adding book: $error');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                addBook();
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditDataPage extends StatefulWidget {
  final Books book;

  const EditDataPage({Key? key, required this.book}) : super(key: key);

  @override
  _EditDataPageState createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final controller = Controller();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.book.title ?? '';
    _authorController.text = widget.book.author ?? '';
  }

  Future<void> updateBook() async {
    String id = widget.book.id?.oid ?? '';
    String title = _titleController.text;
    String author = _authorController.text;

    try {
      await controller.put(id, title, author);
      Navigator.pop(context, true);
      final homePageState = context.findAncestorStateOfType<_HomePageState>();
      if (homePageState != null) {
        homePageState.fetchData();
      }
    } catch (error) {
      print('Error updating book: $error');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(
                labelText: 'Author',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                updateBook();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
