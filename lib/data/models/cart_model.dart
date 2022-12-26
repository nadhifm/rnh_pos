import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rnh_pos/domain/entities/cart.dart';
import 'package:rnh_pos/domain/entities/cart.dart';
import 'package:rnh_pos/domain/entities/cart.dart';
import 'package:rnh_pos/domain/entities/cart.dart';
import 'package:rnh_pos/domain/entities/product.dart';

class CartModel extends Equatable {
  final String id;
  final String name;
  final int price;
  final int quantity;

  const CartModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory CartModel.fromSnapshot(String id, DocumentSnapshot documentSnapshot) {
    return CartModel(
      id: id,
      name: documentSnapshot.get('name'),
      price: documentSnapshot.get('price'),
      quantity: documentSnapshot.get('quantity'),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "price": price,
      "quantity": quantity,
    };
  }

  Cart toEntity() {
    return Cart(
      id: id,
      name: name,
      imageUrl: "",
      price: price,
      stock: 0,
      quantity: quantity,
    );
  }

  @override
  List<Object?> get props => [id];
}
