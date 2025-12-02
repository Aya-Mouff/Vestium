import 'package:equatable/equatable.dart';


abstract class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List<Object?> get props => [];
}

class MyProfileInitial extends MyProfileState {}

class MyProfileLoading extends MyProfileState {}

class MyProfileLoaded extends MyProfileState {
  final Map<String, dynamic> currentUser;
  final List<dynamic> outfits;
  final List<dynamic> filteredOutfits;
  final List<dynamic> posts;
  final List<String> userOutfitCategories;
  final String selectedCategory;
  final bool showOutfits;

  const MyProfileLoaded({
    required this.currentUser,
    required this.outfits,
    required this.filteredOutfits,
    required this.posts,
    required this.userOutfitCategories,
    required this.selectedCategory,
    required this.showOutfits,
  });

  MyProfileLoaded copyWith({
    Map<String, dynamic>? currentUser,
    List<dynamic>? outfits,
    List<dynamic>? filteredOutfits,
    List<dynamic>? posts,
    List<String>? userOutfitCategories,
    String? selectedCategory,
    bool? showOutfits,
  }) {
    return MyProfileLoaded(
      currentUser: currentUser ?? this.currentUser,
      outfits: outfits ?? this.outfits,
      filteredOutfits: filteredOutfits ?? this.filteredOutfits,
      posts: posts ?? this.posts,
      userOutfitCategories: userOutfitCategories ?? this.userOutfitCategories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      showOutfits: showOutfits ?? this.showOutfits,
    );
  }

  @override
  List<Object?> get props => [
        currentUser,
        outfits,
        filteredOutfits,
        posts,
        userOutfitCategories,
        selectedCategory,
        showOutfits,
      ];
}

class MyProfileError extends MyProfileState {
  final String message;
  const MyProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MyProfileAccessDenied extends MyProfileState {}
