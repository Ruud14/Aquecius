import 'package:Aquecius/constants.dart';
import 'package:Aquecius/objects/responses.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for authentication related Supabase stuff.
class SupaBaseAuthService {
  static final auth = supabase.auth;

  /// Signs the user in.
  static Future<BackendResponse> signIn(String email, String password) async {
    final response = await auth.signIn(email: email, password: password, options: AuthOptions(redirectTo: 'io.supabase.aquecius://login-callback/'));
    final error = response.error;
    return BackendResponse(isSuccessful: error == null, message: response.error?.message);
  }

  /// Signs the user up.
  static Future<BackendResponse> signUp(String email, String password) async {
    final response = await auth.signUp(email, password);
    final error = response.error;
    return BackendResponse(isSuccessful: error == null, message: response.error?.message);
  }

  /// Signs the user out.
  static Future<BackendResponse> signOut() async {
    final response = await auth.signOut();
    final error = response.error;
    return BackendResponse(isSuccessful: error == null, message: response.error?.message);
  }

  static String? get uid => auth.currentUser?.id;
}
