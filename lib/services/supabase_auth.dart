import 'package:Aquecius/constants.dart';
import 'package:Aquecius/objects/responses.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for authentication related Supabase stuff.
class SupaBaseAuthService {
  static final auth = supabase.auth;

  /// Send magic link to user.
  /// Returns a backendResponse.
  static Future<BackendResponse> signIn(String email) async {
    final response = await auth.signIn(email: email, options: AuthOptions(redirectTo: 'io.supabase.aquecius://login-callback/'));
    final error = response.error;
    return BackendResponse(isSuccessful: error == null, message: response.error?.message);
  }

  static Future<BackendResponse> signOut() async {
    final response = await auth.signOut();
    final error = response.error;
    return BackendResponse(isSuccessful: error == null, message: response.error?.message);
  }

  static String? get uid => auth.currentUser?.id;
}
