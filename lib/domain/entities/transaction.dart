import 'package:equatable/equatable.dart';
import 'package:rnh_pos/domain/entities/cart.dart';

class Transaction extends Equatable {
  final String id;
  final DateTime date;
  final int totalPrice;
  final int pay;
  final int change;
  final List<Cart> carts;

  const Transaction({
    required this.id,
    required this.date,
    required this.totalPrice,
    required this.pay,
    required this.change,
    required this.carts,
  });

  @override
  List<Object?> get props => [id];
}
