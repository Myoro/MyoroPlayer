import 'package:frontend/shared/database.dart';
import 'package:frontend/shared/models/conditions.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:frontend/shared/services/user_preferences_service/user_preferences_service.dart';

final class UserPreferencesServiceApi implements UserPreferencesService {
  final Database database;

  const UserPreferencesServiceApi(this.database);

  @override
  Future<UserPreferences> create({required Map<String, dynamic> data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<List<UserPreferences>> select({Conditions? conditions}) {
    // TODO: implement select
    throw UnimplementedError();
  }

  @override
  Future<UserPreferences> get({Conditions? conditions}) async {
    return UserPreferences.fromJson(
      (await database.get(Database.userPreferencesTableName))!,
    );
  }

  @override
  Future<UserPreferences> update({int? id, Map<String, dynamic>? data}) async {
    assert(data != null, '[UserPreferencesServiceApi.update]: [data] must be provided.');
    await database.update(Database.userPreferencesTableName, data: data!);
    return await get();
  }

  @override
  Future<void> delete({required int id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
