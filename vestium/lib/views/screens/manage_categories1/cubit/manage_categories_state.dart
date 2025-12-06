import 'package:equatable/equatable.dart';

class Category {
  final String name;
  final int itemCount;

  const Category({
    required this.name,
    required this.itemCount,
  });
}

class ManageCategoriesState extends Equatable {
  final List<Category> categories;
  final String newCategoryName;

  const ManageCategoriesState({
    required this.categories,
    required this.newCategoryName,
  });

  factory ManageCategoriesState.initial() {
    return const ManageCategoriesState(
      categories: [
        Category(name: 'Bottoms', itemCount: 8),
        Category(name: 'Dresses', itemCount: 5),
        Category(name: 'Outerwear', itemCount: 6),
        Category(name: 'Shoes', itemCount: 10),
        Category(name: 'Accessories', itemCount: 15),
      ],
      newCategoryName: '',
    );
  }

  ManageCategoriesState copyWith({
    List<Category>? categories,
    String? newCategoryName,
  }) {
    return ManageCategoriesState(
      categories: categories ?? this.categories,
      newCategoryName: newCategoryName ?? this.newCategoryName,
    );
  }

  @override
  List<Object?> get props => [categories, newCategoryName];
}
