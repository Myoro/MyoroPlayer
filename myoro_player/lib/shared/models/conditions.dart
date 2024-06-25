import 'package:equatable/equatable.dart';

final class Conditions extends Equatable {
  /// Attributes apart of the condition
  ///
  /// Examples:
  /// 'foo_one = ?', 'foo_one = ? AND foo_two = ?'
  final String where;

  /// Values of the attributes apart of the condition
  ///
  /// Examples:
  /// [5], ['Something', 'Something Else']
  final List<dynamic> whereArgs;

  const Conditions._({required this.where, required this.whereArgs});

  factory Conditions(Map<String, dynamic> json) {
    String where = '';
    final List<dynamic> whereArgs = [];

    final int numberOfKeys = json.keys.length;
    for (int i = 0; i < numberOfKeys; i++) {
      final String key = json.keys.elementAt(i);
      where += '$key = ?${i == numberOfKeys - 1 ? '' : ' AND '}';
      whereArgs.add(json[key]);
    }

    return Conditions._(where: where, whereArgs: whereArgs);
  }

  @override
  String toString() => 'Conditions(\n'
      '  where: $where,\n'
      '  whereArgs: $whereArgs,\n'
      ');';

  @override
  List<Object?> get props => [where, whereArgs];
}
