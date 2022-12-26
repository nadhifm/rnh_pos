import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;

  const Category({
    required this.name,
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}
