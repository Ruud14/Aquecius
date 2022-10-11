import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool isPassword;
  final String hintText;
  final TextAlign textAlign;
  const CustomTextField({
    super.key,
    this.controller,
    this.isPassword = false,
    this.hintText = "",
    this.textAlign = TextAlign.start,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  /// Whether the password is shown.
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 1.sp),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: TextFormField(
        obscureText: !showPassword && widget.isPassword,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        controller: widget.controller,
        textAlign: widget.textAlign,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
          suffixIconConstraints: const BoxConstraints(maxHeight: 20),
          suffixIcon: widget.isPassword
              ? InkWell(
                  child: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  onTap: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
