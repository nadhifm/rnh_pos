import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rnh_pos/data/models/cart_model.dart';
import 'package:rnh_pos/domain/entities/transaction.dart' as entities;

class TransactionModel extends Equatable {
  final String id;
  final DateTime date;
  final int totalPrice;
  final int pay;
  final int change;
  final List<CartModel> carts;

  const TransactionModel({
    required this.id,
    required this.date,
    required this.totalPrice,
    required this.pay,
    required this.change,
    required this.carts,
  });

  factory TransactionModel.fromSnapshot(
    String id,
    DocumentSnapshot documentSnapshot,
    DateTime date,
    List<CartModel> carts,
  ) {
    return TransactionModel(
      id: id,
      date: date,
      totalPrice: documentSnapshot.get('totalPrice'),
      pay: documentSnapshot.get('pay'),
      change: documentSnapshot.get('change'),
      carts: carts,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "date": date,
      "totalPrice": totalPrice,
      "pay": pay,
      "change": change,
    };
  }

 entities.Transaction toEntity() {
    return entities.Transaction(
      id: id,
      date: date,
      totalPrice: totalPrice,
      pay: pay,
      change: change,
      carts: carts.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [id];
}
