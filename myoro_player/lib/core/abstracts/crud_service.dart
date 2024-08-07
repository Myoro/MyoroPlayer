import 'package:myoro_player/core/models/conditions.dart';

abstract interface class CrudService<T> {
  Future<T?> create({required Map<String, dynamic> data});
  Future<List<T>> select({Conditions? conditions});
  Future<T?> get({Conditions? conditions});
  Future<T?> update({int? id, Map<String, dynamic>? data});
  Future<void> delete({required int id});
}
