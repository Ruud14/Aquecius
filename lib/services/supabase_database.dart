import 'dart:ffi';
import 'dart:math';
import 'package:Aquecius/models/family.dart';
import 'package:Aquecius/models/profile.dart';
import 'package:Aquecius/models/session.dart';
import 'package:Aquecius/objects/datestat.dart';
import 'package:Aquecius/objects/responses.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/services/supabase_general.dart';

/// Service for database related Supabase stuff.
class SupaBaseDatabaseService {
  /// Gets a profile based on the user id.
  /// Returns a backendResponse.
  /// if backendResponse.isSuccessful, backendResponse.data will be a Profile.
  /// else it will be null, and message will be set to the error message.
  static Future<BackendResponse<Profile>> getProfile(String id) async {
    final response = await SupaBaseService.supabase.from('profiles').select().eq('id', id).single().execute();
    Profile? profile;
    dynamic error = response.error;
    if (error == null) {
      try {
        profile = Profile.fromJson(id, response.data);
      } on TypeError catch (e) {
        error = "Profile corrupted. $e";
      }
    }
    return BackendResponse(isSuccessful: response.error == null, data: profile, message: response.error?.message);
  }

  /// Gets the most recent session from the current user.
  static Future<BackendResponse<ShowerSession>> getLastSession() async {
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

  /// Gets the consumption average of the current user of the 2 weeks prior the session.startedAt
  static Future<BackendResponse> getPastConsumptionAverage(ShowerSession session) async {
    final response = await SupaBaseService.supabase.rpc("get_average_consumption_of_time_prior_to", params: {
      "user_id": SupaBaseAuthService.uid,
      "start_time": session.startedAt.toIso8601String(),
      "end_time": session.startedAt.subtract(const Duration(days: 14)).toIso8601String()
    }).execute();

    dynamic error = response.error;
    final data = response.data;
    return BackendResponse(isSuccessful: error == null && data != null, data: data, message: response.error?.message);
  }

  /// Gets the duration average of the current user of the 2 weeks prior the session.startedAt
  static Future<BackendResponse> getPastDurationAverage(ShowerSession session) async {
    final response = await SupaBaseService.supabase.rpc("get_average_duration_of_time_prior_to", params: {
      "user_id": SupaBaseAuthService.uid,
      "start_time": session.startedAt.toIso8601String(),
      "end_time": session.startedAt.subtract(const Duration(days: 14)).toIso8601String()
    }).execute();

    dynamic error = response.error;
    final data = response.data;
    return BackendResponse(isSuccessful: error == null && data != null, data: data, message: response.error?.message);
  }

  /// Gets the temperature average of the current user of the 2 weeks prior the session.startedAt
  static Future<BackendResponse> getPastTemperatureAverage(ShowerSession session) async {
    final response = await SupaBaseService.supabase.rpc("get_average_temperature_of_time_prior_to", params: {
      "user_id": SupaBaseAuthService.uid,
      "start_time": session.startedAt.toIso8601String(),
      "end_time": session.startedAt.subtract(const Duration(days: 14)).toIso8601String()
    }).execute();

    dynamic error = response.error;
    final data = response.data;
    return BackendResponse(isSuccessful: error == null && data != null, data: data, message: response.error?.message);
  }

  /// Get the data for the statistics graph.
  static Future<BackendResponse> getGraphData({required String kind, required String period}) async {
    // Create period of the query.
    final now = DateTime.now();
    final after = (period == "Week"
            ? now.subtract(const Duration(days: 7))
            : period == "Month"
                ? DateTime(now.year, now.month - 1, now.day)
                : DateTime(now.year - 1, now.month, now.day))
        .toIso8601String();

    final List<DateStat> data = [];
    String? error;

    // Create kind of the query.
    if (kind == "Consumption") {
      final response = await SupaBaseService.supabase
          .from('sessions')
          .select('''started_at, consumption''')
          .eq('user_id', SupaBaseAuthService.uid!)
          .gt('started_at', after)
          .execute();
      if (response.error == null) {
        for (final x in response.data) {
          data.add(DateStat(dateTime: DateTime.parse(x['started_at']), stat: x['consumption'].toDouble()));
        }
      } else {
        error = response.error!.message;
      }
    } else if (kind == "Temperature") {
      final response = await SupaBaseService.supabase
          .from('sessions')
          .select('''started_at, temperatures''')
          .eq('user_id', SupaBaseAuthService.uid!)
          .gt('started_at', after)
          .execute();

      if (response.error == null) {
        for (final x in response.data) {
          data.add(DateStat(dateTime: DateTime.parse(x['started_at']), stat: x['temperatures'].reduce((a, b) => a + b) / x['temperatures'].length));
        }
      } else {
        error = response.error!.message;
      }
    } else if (kind == "Time") {
      final response = await SupaBaseService.supabase
          .from('sessions')
          .select('''started_at, ended_at''')
          .eq('user_id', SupaBaseAuthService.uid!)
          .gt('started_at', after)
          .execute();
      if (response.error == null) {
        for (final x in response.data) {
          data.add(DateStat(
              dateTime: DateTime.parse(x['started_at']),
              stat: DateTime.parse(x['ended_at']).difference(DateTime.parse(x['started_at'])).inSeconds / 60));
        }
      } else {
        error = response.error!.message;
      }
    }

    return BackendResponse(isSuccessful: error == null, data: data, message: error);
  }

  /// Returns a family based on its invite code.
  static Future<BackendResponse<Family>> getFamilyByCode(String code) async {
    final response = await SupaBaseService.supabase.from('families').select().eq('invite_code', code).limit(1).single().execute();
    Family? family;
    dynamic error = response.error;
    if (error == null) {
      try {
        family = Family.fromJson(response.data);
      } on TypeError catch (e) {
        error = "Family corrupted. $e";
      }
    }
    return BackendResponse(isSuccessful: response.error == null, data: family, message: response.error?.message);
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
  static Future<BackendResponse> insertFamily(Family family) async {
    final response = await SupaBaseService.supabase.from('families').upsert(family.toJson()).execute();
    return BackendResponse(isSuccessful: response.error == null, data: response.data, message: response.error?.message);
  }

  /// Creates a random session and inserts it into the database.
  static Future<BackendResponse> insertRandomSession() async {
    // Random number generator.
    Random _rnd = Random();

    //DateTime startTime = DateTime.now().subtract(Duration(days: _rnd.nextInt(350)));
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
        points: _rnd.nextInt(200),
        userId: SupaBaseAuthService.uid!);

    return await insertSession(session);
  }

  /// Deletes all sessions the database.
  static Future<BackendResponse> deleteAllSessionsFromCurrentUser() async {
    final response = await SupaBaseService.supabase.from('sessions').delete().eq('user_id', SupaBaseAuthService.auth.currentUser!.id).execute();
    return BackendResponse(isSuccessful: response.error == null, data: response.data, message: response.error?.message);
  }
}
