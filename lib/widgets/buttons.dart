import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FourDotsButton extends StatelessWidget {
  final void Function()? onPressed;
  const FourDotsButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final dot = CircleAvatar(
      radius: 5.sp,
      backgroundColor: Colors.black,
    );

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Row(
            children: [
              dot,
              SizedBox(
                width: 10.sp,
              ),
              dot,
            ],
          ),
          SizedBox(
            height: 10.sp,
          ),
          Row(
            children: [
              dot,
              SizedBox(
                width: 10.sp,
              ),
              dot,
            ],
          ),
        ],
      ),
    );
  }
}

class PurpleButton extends StatelessWidget {
  final void Function()? onPressed;
  final int extraHorizontalPadding;
  final String text;
  const PurpleButton({
    super.key,
    this.onPressed,
    required this.text,
    this.extraHorizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: (15 + extraHorizontalPadding).toDouble(), vertical: 10),
          child: Text(text, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
