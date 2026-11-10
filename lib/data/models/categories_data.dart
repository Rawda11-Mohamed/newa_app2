import '../../features/home/models/category_model.dart';

enum Category {
  general,
  business,
  sports,
  technology,
  health,
  science,
  entertainment,
}

List<String> images = [
  'assets/images/general (2).png',
  'assets/images/busniess.png',
  'assets/images/Lionel Messi - FootyRenders 1.png',
  'assets/images/health.png',
  'assets/images/kisspng-arduino-mega-2560-pinout-arduino-uno-printed-circu-5b2f997663b244.4381157415298461344084 1.png',
  'assets/images/PopcornTime Logo transparency 1.png',
  'assets/images/sience.png',
];

final List<CategoryModel> categories = [
  CategoryModel(image: images[0], category: Category.general, isEven: true),
  CategoryModel(image: images[1], category: Category.business, isEven: false),
  CategoryModel(image: images[2], category: Category.sports, isEven: true),
  CategoryModel(image: images[3], category: Category.health, isEven: false),
  CategoryModel(image: images[4], category: Category.technology, isEven: true),
  CategoryModel(
    image: images[5],
    category: Category.entertainment,
    isEven: false,
  ),
  CategoryModel(image: images[6], category: Category.science, isEven: true),
];
