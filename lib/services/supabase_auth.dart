import 'package:showerthing/constants.dart';
import 'package:showerthing/objects/responses.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for authentication related Supabase stuff.
class SupaBaseAuthService {
  static final auth = supabase.auth;

  /// Send magic link to user.
  /// Returns a backendResponse.
  static Future<BackendResponse> signIn(String email) async {
    final response = await auth.signIn(email: email, options: AuthOptions(redirectTo: 'io.supabase.showerthing://login-callback/'));
    final error = response.error;
    return BackendResponse(isSuccessful: error == null, message: response.error?.message);
  }

  static Future<BackendResponse> signOut() async {
    final response = await auth.signOut();
    final error = response.error;
    return BackendResponse(isSuccessful: error == null, message: response.error?.message);
  }
}
