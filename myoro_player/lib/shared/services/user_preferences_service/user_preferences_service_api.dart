import 'package:myoro_player/shared/database.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service.dart';

final class UserPreferencesServiceApi implements UserPreferencesService {
  final Database database;

  const UserPreferencesServiceApi(this.database);

  @override
  Future<UserPreferences> create({required Map<String, dynamic> data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<List<UserPreferences>> select({Map<String, dynamic>? conditions}) {
    // TODO: implement select
    throw UnimplementedError();
  }

  @override
  Future<UserPreferences> get({int? id}) async {
    return UserPreferences.fromJson(
      (await database.get(Database.userPreferencesTableName))!,
    );
  }

  @override
  Future<UserPreferences> update({int? id, Map<String, dynamic>? data}) async {
    final isDarkMode = (await get()).darkMode;
    await database.update(Database.userPreferencesTableName, data: {'dark_mode': isDarkMode ? 0 : 1});
    return await get();
  }

  @override
  Future<void> delete({required int id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}