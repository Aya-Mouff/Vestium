import 'package:equatable/equatable.dart';

class FollowingState extends Equatable {
  final bool isLoading;
  final String searchQuery;
  final List<Map<String, dynamic>> allFollowing;
  final List<Map<String, dynamic>> filteredFollowing;
  final String? errorMessage;

  const FollowingState({
    this.isLoading = false,
    this.searchQuery = '',
    this.allFollowing = const [],
    this.filteredFollowing = const [],
    this.errorMessage,
  });

  FollowingState copyWith({
    bool? isLoading,
    String? searchQuery,
    List<Map<String, dynamic>>? allFollowing,
    List<Map<String, dynamic>>? filteredFollowing,
    String? errorMessage,
  }) {
    return FollowingState(
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      allFollowing: allFollowing ?? this.allFollowing,
      filteredFollowing: filteredFollowing ?? this.filteredFollowing,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, searchQuery, allFollowing, filteredFollowing, errorMessage];
}
