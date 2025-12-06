import 'package:equatable/equatable.dart';

class Category {
  final String name;
  final int itemCount;

  const Category({
    required this.name,
    required this.itemCount,
  });
}

class ManageCategories2State extends Equatable {
  final List<Category> categories;
  final String newCategoryName;

  const ManageCategories2State({
    required this.categories,
    required this.newCategoryName,
  });

  factory ManageCategories2State.initial() {
    return const ManageCategories2State(
      categories: [
        Category(name: 'Casual', itemCount: 8),
        Category(name: 'Classic', itemCount: 5),
        Category(name: 'Formal', itemCount: 11),
        Category(name: 'Streetwear', itemCount: 3),
        Category(name: 'Work', itemCount: 2),
        Category(name: 'Vacation', itemCount: 9),
        Category(name: 'Evening', itemCount: 7),
      ],
      newCategoryName: '',
    );
  }

  ManageCategories2State copyWith({
    List<Category>? categories,
    String? newCategoryName,
  }) {
    return ManageCategories2State(
      categories: categories ?? this.categories,
      newCategoryName: newCategoryName ?? this.newCategoryName,
    );
  }

  @override
  List<Object?> get props => [categories, newCategoryName];
}
