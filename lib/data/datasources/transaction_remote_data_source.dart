import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rnh_pos/data/models/cart_model.dart';
import 'package:rnh_pos/data/models/transaction_model.dart';

import '../../commont/exception.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionModel> addTransaction(TransactionModel transactionModel);
  Future<List<TransactionModel>> getTransactions(DateTime startAt, DateTime endAt);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;

  TransactionRemoteDataSourceImpl(this.firestore);

  @override
  Future<TransactionModel> addTransaction(
    TransactionModel transactionModel,
  ) async {
    final batch = firestore.batch();
    final transactionRef = firestore.collection("transactions").doc();
    String transactionId = transactionRef.id;
    batch.set(transactionRef, transactionModel.toDocument());
    for (var cart in transactionModel.carts) {
      batch.set(
        transactionRef.collection("carts").doc(cart.id),
        cart.toDocument(),
      );
      batch.update(firestore.collection("products").doc(cart.id),
          {"stock": FieldValue.increment(-cart.quantity)});
    }

    await batch
        .commit()
        .catchError((error) => throw ServerException('Transaksi Gagal'));

    return TransactionModel(
      id: transactionId,
      date: transactionModel.date,
      totalPrice: transactionModel.totalPrice,
      pay: transactionModel.pay,
      change: transactionModel.change,
      carts: transactionModel.carts,
    );
  }

  @override
  Future<List<TransactionModel>> getTransactions(DateTime startAt, DateTime endAt) async {
    final transactionRef = firestore.collection("transactions");
    List<TransactionModel> transactions = [];

    print("Data $startAt");
    print("Data $endAt");
    await transactionRef
        .orderBy("date", descending: true)
        .startAt([endAt])
        .endAt([startAt])
        .get()
        .then(
      (QuerySnapshot querySnapshot) async {
        for (var transaction in querySnapshot.docs) {
          final timestamp = transaction.get("date") as Timestamp;
          await transactionRef
              .doc(transaction.id)
              .collection("carts")
              .get()
              .then(
            (QuerySnapshot querySnapshot) {
              transactions.add(
                TransactionModel.fromSnapshot(
                  transaction.id,
                  transaction,
                  timestamp.toDate(),
                  querySnapshot.docs
                      .map((doc) => CartModel.fromSnapshot(doc.id, doc))
                      .toList(),
                ),
              );
            },
            onError: (e) => throw ServerException(e.toString()),
          );
        }
      },
      onError: (e) => throw ServerException(e.toString()),
    );

    print("Data $transactions");
    return transactions;
  }
}
