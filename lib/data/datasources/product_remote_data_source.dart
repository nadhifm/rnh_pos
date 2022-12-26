import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rnh_pos/data/models/product_model.dart';
import 'package:path/path.dart';

import '../../commont/exception.dart';

abstract class ProductRemoteDataSource {
  Future<String> addProduct(ProductModel productModel);
  Future<String> addImageProduct(File imageFile);
  Future<String> updateProduct(ProductModel productModel);
  Future<String> deleteProduct(String id);
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  ProductRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<String> addProduct(ProductModel productModel) async {
    await firestore.collection("products")
        .add(productModel.toDocument())
        .catchError((error) => throw ServerException('Tambah Produk Gagal'));

    return "Tambah Produk Berhasil";
  }

  @override
  Future<String> deleteProduct(String id) async {
    await firestore.collection("products").doc(id)
        .delete()
        .catchError((error) => throw ServerException('Hapus Produk Gagal'));

    return "Hapus Produk Berhasil";
  }

  @override
  Future<String> updateProduct(ProductModel productModel) async {
    await firestore.collection("products").doc(productModel.id)
        .update(productModel.toDocument())
        .catchError((error) => throw ServerException('Update Produk Gagal'));

    return "Update Produk Berhasil";
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> products = [];
    await firestore.collection('products').get().then(
          (QuerySnapshot querySnapshot) {
        products =  querySnapshot.docs.map((doc) => ProductModel.fromSnapshot(doc.id, doc)).toList();
      },
      onError: (e) => throw ServerException(e.toString()),
    );

    return products;
  }

  @override
  Future<String> addImageProduct(File imageFile) async {
      String filename = basename(imageFile.path);
      final storageRef = storage.ref().child(filename);
      try {
        await storageRef.putFile(imageFile);
        return storageRef.getDownloadURL();
      } on FirebaseException catch (_) {
        throw ServerException('Tambah Produk Gagal');
      }
  }
}
