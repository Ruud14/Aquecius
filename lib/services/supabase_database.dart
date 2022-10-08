import 'dart:math';

import 'package:Aquecius/constants.dart';
import 'package:Aquecius/models/profile.dart';
import 'package:Aquecius/models/session.dart';
import 'package:Aquecius/objects/responses.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/services/supabase_general.dart';

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

  /// Gets the most recent session from the current user.
  static Future<BackendResponse> getLastSession() async {
    final response = await SupaBaseService.supabase
        .from('sessions')
        .select()
        .eq('user_id', SupaBaseAuthService.uid)
        .order('started_at')
        .limit(1)
        .single()
        .execute();
    ShowerSession? session;
    dynamic error = response.error;
    if (error == null) {
      try {
        session = ShowerSession.fromJson(response.data);
      } on TypeError catch (e) {
        error = "Session corrupted. $e";
      }
    }
    return BackendResponse(isSuccessful: error == null, data: session, message: response.error?.message);
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

  /// Creates a random session and inserts it into the database.
  static Future<BackendResponse> insertRandomSession() async {
    // Random number generator.
    Random _rnd = Random();

    DateTime startTime = DateTime.now();
    DateTime endTime = startTime.add(Duration(minutes: 3 + _rnd.nextInt(30)));

    List<double> temperatures = [];
    for (int i = 0; i < endTime.difference(startTime).inMinutes.abs(); i++) {
      temperatures.add(32 + _rnd.nextDouble() * 10);
    }

    final session = ShowerSession(
        id: null,
        startedAt: startTime,
        endedAt: endTime,
        consumption: _rnd.nextInt(120).toDouble(),
        temperatures: temperatures,
        userId: SupaBaseAuthService.uid!);

    return await insertSession(session);
  }

  /// Deletes all sessions the database.
  static Future<BackendResponse> deleteAllSessionsFromCurrentUser() async {
    final response = await SupaBaseService.supabase.from('sessions').delete().eq('user_id', SupaBaseAuthService.auth.currentUser!.id).execute();
    return BackendResponse(isSuccessful: response.error == null, data: response.data, message: response.error?.message);
  }
}
