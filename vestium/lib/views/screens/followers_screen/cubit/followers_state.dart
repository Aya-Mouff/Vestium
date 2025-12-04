import 'package:equatable/equatable.dart';

class FollowersState extends Equatable {
  final bool isLoading;
  final String searchQuery;
  final List<Map<String, dynamic>> allFollowers;
  final List<Map<String, dynamic>> filteredFollowers;
  final String? errorMessage;

  const FollowersState({
    this.isLoading = false,
    this.searchQuery = '',
    this.allFollowers = const [],
    this.filteredFollowers = const [],
    this.errorMessage,
  });

  FollowersState copyWith({
    bool? isLoading,
    String? searchQuery,
    List<Map<String, dynamic>>? allFollowers,
    List<Map<String, dynamic>>? filteredFollowers,
    String? errorMessage,
  }) {
    return FollowersState(
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      allFollowers: allFollowers ?? this.allFollowers,
      filteredFollowers: filteredFollowers ?? this.filteredFollowers,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, searchQuery, allFollowers, filteredFollowers, errorMessage];
}
