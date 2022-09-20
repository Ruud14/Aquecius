import 'package:showerthing/models/profile.dart';
import 'package:showerthing/objects/responses.dart';
import 'package:showerthing/services/supabase_general.dart';

/// Service for database related Supabase stuff.
class SupaBaseDatabaseService {
  /// Gets a profile based on the user id.
  /// Returns a backendResponse.
  /// if backendResponse.isSuccessful, backendResponse.data will be a Profile.
  /// else it will be null, and message will be set to the error message.
  static Future<BackendResponse> getProfile(String id) async {
    final response = await SupaBaseService.supabase.from('profiles').select().eq('id', id).single().execute();
    return BackendResponse(isSuccessful: response.error == null, data: response.data, message: response.error?.message);
  }

  /// Updates a profile with id in the database.
  static Future<BackendResponse> updateProfile(Profile profile) async {
    final response = await SupaBaseService.supabase.from('profiles').upsert(profile.toJson()).execute();
    return BackendResponse(isSuccessful: response.error == null, data: response.data, message: response.error?.message);
  }
}
