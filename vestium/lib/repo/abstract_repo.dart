// // Generic abstract repo to follow the same pattern
// abstract class AbstractRepo<T> {
//   Future<List<T>> getAll();
//   Future<bool> insertItem(T item);
//   Future<bool> updateItem(dynamic idOrKeys, T item);
//   Future<bool> deleteItem(dynamic idOrKeys);

//   // static instance pattern will be implemented in specific repos if needed
// }

// // ===========================================================

// lib/repo/abstract_repo.dart - UPDATED VERSION
// lib/repo/abstract_repo.dart - CORRECTED VERSION
abstract class AbstractRepo<T> {
  // Core CRUD methods
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<int> insert(T item);
  Future<bool> update(int id, T item);
  Future<bool> delete(int id);
  
  // Sync queue methods
  Future<void> queueCreateOperation(T item, int localId);
  Future<void> queueUpdateOperation(int id, T item);
  Future<void> queueDeleteOperation(int id);
  
  // Helper methods
  Map<String, dynamic> toMap(T item);
  T fromMap(Map<String, dynamic> map);
  String get tableName;
  String get primaryKey;
  
  // ID helpers
  bool isLocalId(int id);
  bool isServerId(int id);
}