abstract interface class CrudService<T> {
  Future<T> create({required Map<String, dynamic> data});
  Future<List<T>> select({Map<String, dynamic>? conditions});
  Future<T> get({int? id});
  Future<T> update({int? id, Map<String, dynamic>? data});
  Future<void> delete({required int id});
}
