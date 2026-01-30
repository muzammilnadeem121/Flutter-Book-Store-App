// import 'dart:convert';

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_project/models/book_model.dart';
// import 'package:http/http.dart' as http;

class BooksService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Book>> fetchBooks() async {
    try {
      final snapshot = await _firestore.collection("books").get();

      return snapshot.docs.map((doc) {
        return Book.fromJson(doc);
      }).toList();
    } catch (e) {
      throw "Failed to fetch books: $e";
    }
  }

  // Get single book by ID
  Future<Book> getBookById(String bookId) async {
    try {
      final doc = await _firestore.collection('books').doc(bookId).get();
      if (doc.exists) {
        return Book.fromJson(doc);
      }
      throw Exception('Book not found');
    } catch (e) {
      print('Error getting book: $e');
      throw Exception('Failed to load book');
    }
  }

  // Add new book
  Future<String> addBook(Book book, {File? imageFile}) async {
    try {
      // Upload image if provided
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadBookImage(imageFile, book.id);
      }

      // Prepare book data
      final bookData = book.toMap();
      if (imageUrl != null) {
        bookData['coverUrl'] = imageUrl;
      }

      // Add to Firestore
      final docRef = await _firestore.collection('books').add(bookData);
      return docRef.id;
    } catch (e) {
      print('Error adding book: $e');
      throw Exception('Failed to add book');
    }
  }

  // Update existing book
  Future<void> updateBook(String bookId, Book book, {File? imageFile}) async {
    try {
      // Upload new image if provided
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadBookImage(imageFile, bookId);
      }

      // Prepare update data
      final updateData = book.toMap();
      if (imageUrl != null) {
        updateData['coverUrl'] = imageUrl;
      }

      // Update in Firestore
      await _firestore.collection('books').doc(bookId).update(updateData);
    } catch (e) {
      print('Error updating book: $e');
      throw Exception('Failed to update book');
    }
  }

  // Delete book
  Future<void> deleteBook(String bookId) async {
    try {
      // Delete book from Firestore
      await _firestore.collection('books').doc(bookId).delete();

      // Delete image from Storage if exists

      await _deleteBookImage(bookId);
    } catch (e) {
      print('Error deleting book: $e');
      throw Exception('Failed to delete book');
    }
  }

  // Search books
  Future<List<Book>> searchBooks(String query) async {
    try {
      final titleQuery = await _firestore
          .collection('books')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: '${query}z')
          .get();

      final authorQuery = await _firestore
          .collection('books')
          .where('author', isGreaterThanOrEqualTo: query)
          .where('author', isLessThan: '${query}z')
          .get();

      final allBooks = [
        ...titleQuery.docs.map((doc) => Book.fromJson(doc)),
        ...authorQuery.docs.map((doc) => Book.fromJson(doc)),
      ];

      // Remove duplicates
      final uniqueBooks = <String, Book>{};
      for (var book in allBooks) {
        uniqueBooks[book.id] = book;
      }

      return uniqueBooks.values.toList();
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  // Get books by genre
  Future<List<Book>> getBooksByGenre(String genre) async {
    try {
      final querySnapshot = await _firestore
          .collection('books')
          .where('genre', isEqualTo: genre)
          .get();

      return querySnapshot.docs.map((doc) => Book.fromJson(doc)).toList();
    } catch (e) {
      print('Error getting books by genre: $e');
      return [];
    }
  }

  // Get bestsellers
  Future<List<Book>> getBestsellers() async {
    try {
      final querySnapshot = await _firestore
          .collection('books')
          .where('isBestseller', isEqualTo: true)
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) => Book.fromJson(doc)).toList();
    } catch (e) {
      print('Error getting bestsellers: $e');
      return [];
    }
  }

  // Upload book image to Firebase Storage
  Future<String> _uploadBookImage(File imageFile, String bookId) async {
    try {
      final ref = _firestore.collection("books").doc(bookId);
      await ref.set({'coverUrl': base64Encode(imageFile.readAsBytesSync())});
      return ref.get().then((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['coverUrl'] as String;
      });
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  // Delete book image from Firebase Storage
  Future<void> _deleteBookImage(String bookId) async {
    try {
      final ref = _firestore.collection("books").doc(bookId);
      await ref.set({'coverUrl': null});
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}
