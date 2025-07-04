import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../data/models/book_model.dart';

class BookService {
  static final _collection = FirebaseFirestore.instance.collection('books');
  static final _storage = FirebaseStorage.instance;

  /// Uploads a PDF file to Firebase Storage and returns the download URL
  static Future<String> uploadPdf(File file) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('books/$fileName.pdf');

    final uploadTask = await ref.putFile(file);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Adds a book to Firestore
  static Future<void> addBook(BookModel book) async {
    await _collection.add(book.toMap());
  }

  /// Streams all books in real-time
  static Stream<List<BookModel>> getBooks() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return BookModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  /// Deletes a book by document ID
  static Future<void> deleteBook(String id) async {
    await _collection.doc(id).delete();
  }

  /// Updates a book document
  static Future<void> updateBook(String id, Map<String, dynamic> data) async {
    await _collection.doc(id).update(data);
  }
}
