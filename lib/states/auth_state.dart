import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/services/supabase_database.dart';
import 'package:flutter/material.dart';
import 'package:Aquecius/constants.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  void onAuthenticated(Session session) {
    if (mounted) {
      // Check if the user already has a profile. If not, require the user to make one.
      SupaBaseDatabaseService.getProfile(SupaBaseAuthService.uid!).then((value) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      });
    }
  }

  @override
  void onReceivedAuthDeeplink(Uri uri) {}

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}
