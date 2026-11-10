import '../../../data/models/categories_data.dart';

class CategoryModel {
  final String image;
  final Category category;
  final bool isEven;

  CategoryModel({
    required this.image,
    required this.category,
    required this.isEven,
  });
}
