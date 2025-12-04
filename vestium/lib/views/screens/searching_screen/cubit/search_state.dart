import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final String query;
  final List<Map<String, dynamic>> allUsers;
  final List<Map<String, dynamic>> filteredUsers;
  final List<String> recentUsers;
  final String? errorMessage;

  const SearchState({
    this.isLoading = false,
    this.query = '',
    this.allUsers = const [],
    this.filteredUsers = const [],
    this.recentUsers = const [],
    this.errorMessage,
  });

  bool get isSearching => query.trim().isNotEmpty;

  SearchState copyWith({
    bool? isLoading,
    String? query,
    List<Map<String, dynamic>>? allUsers,
    List<Map<String, dynamic>>? filteredUsers,
    List<String>? recentUsers,
    String? errorMessage,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      query: query ?? this.query,
      allUsers: allUsers ?? this.allUsers,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      recentUsers: recentUsers ?? this.recentUsers,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, query, allUsers, filteredUsers, recentUsers, errorMessage];
}
