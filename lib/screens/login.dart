import 'package:Aquecius/objects/responses.dart';
import 'package:Aquecius/widgets/buttons.dart';
import 'package:Aquecius/widgets/textfields.dart';
import 'package:flutter/material.dart';
import 'package:Aquecius/constants.dart';
import 'package:Aquecius/services/supabase_auth.dart';
import 'package:Aquecius/states/auth_state.dart';
import 'package:Aquecius/wrappers/scrollable_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen for authentication with magic link.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends AuthState<LoginScreen> {
  /// Whether we're loading.
  bool isLoading = false;

  /// Whether we're registering.
  bool isRegistering = false;

  /// TextEditing controllers.
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _confirmationPasswordController = TextEditingController();

  /// Check whether the input is valid.
  String? isValidInput() {
    if (_emailController.text.isEmpty) {
      return "Please enter an email address.";
    }
    if (_emailController.text.isEmpty) {
      return "Please enter a password";
    }
    if (isRegistering) {
      if (_passwordController.text != _confirmationPasswordController.text) {
        return "Passwords don't match.";
      }
    }
    return null;
  }

  /// Sign the user in/up.
  Future<void> authenticate() async {
    final problemWithInput = isValidInput();
    if (problemWithInput != null) {
      context.showErrorSnackBar(message: problemWithInput);
      return;
    }
    setState(() {
      isLoading = true;
    });
    BackendResponse response;
    if (isRegistering) {
      response = await SupaBaseAuthService.signUp(_emailController.text, _passwordController.text);
      if (response.isSuccessful) {
        context.showSnackBar(message: "Please check your email for confirmation");
        isRegistering = false;
      }
    } else {
      response = await SupaBaseAuthService.signIn(_emailController.text, _passwordController.text);
      if (response.isSuccessful) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
    if (!response.isSuccessful && mounted) {
      context.showErrorSnackBar(message: response.message ?? "Authentication failed");
    }
    setState(() {
      isLoading = false;
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Aquecius",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w300),
            ),
          ),
          const Center(
            child: Text(
              "A cooling shower for a warming globe",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
          ),
          SizedBox(
            height: 80.h,
          ),
          const Text(
            "Email",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10.h,
          ),
          // Email textfield
          CustomTextField(
            controller: _emailController,
          ),
          SizedBox(
            height: 20.h,
          ),
          const Text(
            "Password",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 10.h,
          ),
          // Password textfield
          CustomTextField(
            controller: _passwordController,
            isPassword: true,
          ),
          SizedBox(
            height: 20.h,
          ),
          isRegistering
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Confirm password",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Confirmation password textfield
                    CustomTextField(
                      controller: _confirmationPasswordController,
                      isPassword: true,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                )
              : const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PurpleButton(
                extraHorizontalPadding: 20,
                onPressed: isLoading
                    ? null
                    : () {
                        if (!isRegistering) {
                          authenticate();
                        } else {
                          setState(() {
                            isRegistering = false;
                          });
                        }
                      },
                text: isLoading ? 'Loading' : 'Login',
              ),
              PurpleButton(
                extraHorizontalPadding: 20,
                onPressed: isLoading
                    ? null
                    : () {
                        if (isRegistering) {
                          authenticate();
                        } else {
                          setState(() {
                            isRegistering = true;
                          });
                        }
                      },
                text: isLoading ? 'Loading' : 'Register',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
