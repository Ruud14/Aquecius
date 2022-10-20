import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePageCard extends StatefulWidget {
  final void Function()? onPressed;
  final String image;
  final String text;
  final String subscript;
  const HomePageCard({
    super.key,
    required this.image,
    required this.text,
    required this.subscript,
    this.onPressed,
  });

  @override
  State<HomePageCard> createState() => _HomePageCardState();
}

class _HomePageCardState extends State<HomePageCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.image,
                width: 73.w,
                height: 73.h,
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                widget.text,
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                widget.subscript,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomCard extends StatelessWidget {
  final String route;
  final String image;
  final dynamic args;
  const BottomCard({
    super.key,
    required this.image,
    required this.route,
    this.args,
  });

  @override
  Widget build(BuildContext context) {
    final active = ModalRoute.of(context)?.settings.name == route;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route, arguments: args);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          color: Theme.of(context).colorScheme.primary.withAlpha(active ? 255 : 120),
        ),
        height: 80.sp,
        width: 80.sp,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: 43.w,
                height: 43.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
