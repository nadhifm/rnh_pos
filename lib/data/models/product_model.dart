import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rnh_pos/domain/entities/product.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String imageUrl;
  final int purchasePrice;
  final int sellingPrice;
  final int stock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.imageUrl,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
  });

  factory ProductModel.fromSnapshot(
      String id, DocumentSnapshot documentSnapshot) {
    return ProductModel(
      id: id,
      name: documentSnapshot.get('name'),
      categoryId: documentSnapshot.get('categoryId'),
      imageUrl: documentSnapshot.get('imageUrl'),
      purchasePrice: documentSnapshot.get('purchasePrice'),
      sellingPrice: documentSnapshot.get('sellingPrice'),
      stock: documentSnapshot.get('stock'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "categoryId": categoryId,
      "imageUrl": imageUrl,
      "purchasePrice": purchasePrice,
      "sellingPrice": sellingPrice,
      "stock": stock,
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      categoryId: categoryId,
      imageUrl: imageUrl,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      stock: stock,
    );
  }

  @override
  List<Object?> get props => [id];
}
