import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rnh_pos/commont/exception.dart';

import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<String> addCategory(CategoryModel categoryModel);
  Future<String> updateCategory(CategoryModel categoryModel);
  Future<String> deleteCategory(String id);
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSourceImpl(this.firestore);

  @override
  Future<String> addCategory(CategoryModel categoryModel) async {
    await firestore
        .collection("categories")
        .add(categoryModel.toDocument())
        .catchError((error) => throw ServerException('Tambah Kategori Gagal'));

    return "Tambah Kategori Berhasil";
  }

  @override
  Future<String> deleteCategory(String id) async {
    final productsRef = firestore.collection("products");
    final batch = firestore.batch();

    await productsRef.where("categoryId", isEqualTo: id).get().then(
      (QuerySnapshot querySnapshot) {
        for (var product in querySnapshot.docs) {
          batch.update(productsRef.doc(product.id), {"categoryId": ""});
        }
      },
      onError: (e) => throw ServerException('Hapus Kategori Gagal'),
    );

    batch.delete(firestore.collection("categories").doc(id));

    await batch
        .commit()
        .catchError((error) => throw ServerException('Hapus Kategori Gagal'));

    return "Hapus Kategori Berhasil";
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    List<CategoryModel> categories = [];
    await firestore
        .collection('categories')
        .where("name", isNotEqualTo: "Semua")
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        categories = querySnapshot.docs
            .map((doc) => CategoryModel.fromSnapshot(doc.id, doc))
            .toList();
      },
      onError: (e) => throw ServerException(e.toString()),
    );

    return categories;
  }

  @override
  Future<String> updateCategory(CategoryModel categoryModel) async {
    await firestore
        .collection("categories")
        .doc(categoryModel.id)
        .update(categoryModel.toDocument())
        .catchError((error) => throw ServerException('Update Kategori Gagal'));

    return "Update Kategori Berhasil";
  }
}
