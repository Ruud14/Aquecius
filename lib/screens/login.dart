import 'package:flutter/material.dart';
import 'package:Aquecius/constants.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/states/auth_state.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';

/// Screen for authentication with magic link.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends AuthState<LoginScreen> {
  bool _isLoading = false;
  late final TextEditingController _emailController = TextEditingController();

  /// Sign the user in to supaBase.
  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    final response = await SupaBaseAuthService.signIn(_emailController.text);
    if (!response.isSuccessful && mounted) {
      context.showErrorSnackBar(message: response.message ?? "Authentication failed");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePage(
      child: Column(
        children: [
          const Text('Sign in via the magic link with your email below'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: Text(_isLoading ? 'Loading' : 'Send Magic Link'),
          ),
        ],
      ),
    );
  }
}
