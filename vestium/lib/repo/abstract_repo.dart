// Generic abstract repo to follow the same pattern
abstract class AbstractRepo<T> {
  Future<List<T>> getAll();
  Future<bool> insertItem(T item);
  Future<bool> updateItem(dynamic idOrKeys, T item);
  Future<bool> deleteItem(dynamic idOrKeys);

  // static instance pattern will be implemented in specific repos if needed
}
