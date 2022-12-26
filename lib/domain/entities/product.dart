import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String imageUrl;
  final int purchasePrice;
  final int sellingPrice;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.imageUrl,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
  });

  @override
  List<Object?> get props => [id];
}
