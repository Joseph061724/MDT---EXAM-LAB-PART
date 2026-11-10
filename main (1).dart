import 'dart:io';

/// Represents an individual book record in the library.
class Book {
  String id;
  String title;
  String author;
  bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.isAvailable = true,
  });

  @override
  String toString() {
    String status = isAvailable ? 'Available' : 'Checked Out';
    return 'ID: $id | Title: "$title" by $author | Status: $status';
  }
}

/// Manages library records and inventory business logic using Maps and Lists.
class LibraryManager {
  // Map for fast O(1) lookups by Book ID
  final Map<String, Book> _booksMap = {};
  
  // List for maintaining insertion order and displaying sequential records
  final List<Book> _booksList = [];

  void addBook(Book book) {
    _booksMap[book.id] = book;
    _booksList.add(book);
  }

  bool bookExists(String id) {
    return _booksMap.containsKey(id);
  }

  Book? getBook(String id) {
    return _booksMap[id];
  }

  List<Book> getAllBooks() {
    return _booksList;
  }

  void displayBooks() {
    if (_booksList.isEmpty) {
      print('\nNo books currently in the library inventory.');
      return;
    }
    print('\n--- LIBRARY INVENTORY ---');
    for (var book in _booksList) {
      print(book);
    }
    print('-------------------------');
  }

  bool checkoutBook(String id) {
    var book = _booksMap[id];
    if (book != null && book.isAvailable) {
      book.isAvailable = false;
      return true;
    }
    return false;
  }

  bool returnBook(String id) {
    var book = _booksMap[id];
    if (book != null && !book.isAvailable) {
      book.isAvailable = true;
      return true;
    }
    return false;
  }
}

void main() {
  final LibraryManager manager = LibraryManager();

  // Preload initial records
  manager.addBook(Book(id: 'B001', title: 'The Dart Programming Language', author: 'Gilad Bracha'));
  manager.addBook(Book(id: 'B002', title: 'Clean Code', author: 'Robert C. Martin'));
  manager.addBook(Book(id: 'B003', title: 'Design Patterns', author: 'Erich Gamma'));

  bool running = true;

  print('=== Library Management Console Application ===');

  while (running) {
    print('\nChoose an option:');
    print('1. View All Books');
    print('2. Add a New Book');
    print('3. Checkout a Book');
    print('4. Return a Book');
    print('5. Exit');
    stdout.write('Enter your choice (1-5): ');

    String? input = stdin.readLineSync();
    if (input == null) continue;

    int? choice = int.tryParse(input.trim());

    if (choice == null || choice < 1 || choice > 5) {
      print('Invalid choice! Please enter a number between 1 and 5.');
      continue;
    }

    switch (choice) {
      case 1:
        manager.displayBooks();
        break;

      case 2:
        stdout.write('Enter Book ID (e.g., B004): ');
        String? id = stdin.readLineSync()?.trim();
        if (id == null || id.isEmpty) {
          print('Error: Book ID cannot be empty.');
          break;
        }
        if (manager.bookExists(id)) {
          print('Error: A book with ID "$id" already exists.');
          break;
        }

        stdout.write('Enter Book Title: ');
        String? title = stdin.readLineSync()?.trim();
        if (title == null || title.isEmpty) {
          print('Error: Book Title cannot be empty.');
          break;
        }

        stdout.write('Enter Author Name: ');
        String? author = stdin.readLineSync()?.trim();
        if (author == null || author.isEmpty) {
          print('Error: Author Name cannot be empty.');
          break;
        }

        manager.addBook(Book(id: id, title: title, author: author));
        print('Success: Book "$title" added successfully!');
        break;

      case 3:
        stdout.write('Enter Book ID to checkout: ');
        String? checkoutId = stdin.readLineSync()?.trim();
        if (checkoutId == null || checkoutId.isEmpty) {
          print('Error: Book ID cannot be empty.');
          break;
        }

        var book = manager.getBook(checkoutId);
        if (book == null) {
          print('Error: Book with ID "$checkoutId" not found.');
        } else if (!book.isAvailable) {
          print('Error: Book is already checked out.');
        } else {
          manager.checkoutBook(checkoutId);
          print('Success: You have successfully checked out "${book.title}".');
        }
        break;

      case 4:
        stdout.write('Enter Book ID to return: ');
        String? returnId = stdin.readLineSync()?.trim();
        if (returnId == null || returnId.isEmpty) {
          print('Error: Book ID cannot be empty.');
          break;
        }

        var book = manager.getBook(returnId);
        if (book == null) {
          print('rror: Book with ID "$returnId" not found.');
        } else if (book.isAvailable) {
          print('rror: Book is already available in the library.');
        } else {
          manager.returnBook(returnId);
          print('Success: You have successfully returned "${book.title}".');
        }
        break;

      case 5:
        print('Exiting application. Goodbye!');
        running = false;
        break;
    }
  }
}
