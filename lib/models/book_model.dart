import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_project/models/review_model.dart';

class Book {
  String id;
  final String title;
  final String author;
  final String genre;
  final String description;
  final String coverUrl;
  final double price;
  final bool isBestseller;
  final DateTime releaseDate;
  final String isbn;
  final double rating;
  final List<ReviewModel> reviews;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.description,
    required this.coverUrl,
    required this.price,
    required this.isBestseller,
    required this.releaseDate,
    required this.isbn,
    required this.rating,
    this.reviews = const [],
  });

  factory Book.fromJson(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      genre: data['genre'] ?? '',
      description: data['description'] ?? '',
      coverUrl: data['coverUrl'] ?? '',
      isbn: data['isbn'] ?? '',
      price: (data['price'] as num).toDouble(),
      rating: (data['rating'] as num).toDouble(),
      isBestseller: data['isBestseller'] ?? false,
      releaseDate: (data['releaseDate'] as Timestamp).toDate(),
      reviews: (data['reviews'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map((e) => ReviewModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'genre': genre,
      'description': description,
      'coverUrl': coverUrl,
      'price': price,
      'isBestseller': isBestseller,
      'releaseDate': Timestamp.fromDate(releaseDate),
      'isbn': isbn,
      'rating': rating,
      'reviews': reviews.map((r) => r.toMap()).toList(), // ✅ FIX
    };
  }
}
