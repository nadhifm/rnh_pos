import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;

  const CategoryModel({
    required this.name,
    required this.id,
  });

  factory CategoryModel.fromSnapshot(
    String id,
    DocumentSnapshot documentSnapshot,
  ) {
    return CategoryModel(
      id: id,
      name: documentSnapshot.get('name'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
    };
  }

  Category toEntity() {
    return Category(
      id: id,
      name: name,
    );
  }
  @override
  List<Object?> get props => [id];
}
