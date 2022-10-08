import 'package:Aquecius/constants.dart';
import 'package:Aquecius/models/profile.dart';
import 'package:Aquecius/models/session.dart';
import 'package:Aquecius/objects/responses.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/services/supabase_general.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// Inserts a session in the database.
  static Future<BackendResponse> insertSession(ShowerSession session) async {
    final response = await SupaBaseService.supabase.from('sessions').upsert(session.toJson()).execute();
    return BackendResponse(isSuccessful: response.error == null, data: response.data, message: response.error?.message);
  }

  /// Deletes all sessions the database.
  static Future<BackendResponse> deleteAllSessionsFromCurrentUser() async {
    final response = await SupaBaseService.supabase.from('sessions').delete().eq('user_id', SupaBaseAuthService.auth.currentUser!.id).execute();
    return BackendResponse(isSuccessful: response.error == null, data: response.data, message: response.error?.message);
  }
}
