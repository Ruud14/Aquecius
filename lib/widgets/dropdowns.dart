import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatefulWidget {
  final void Function(String?)? onChanged;
  final List<DropdownMenuItem<String>>? items;
  final String value;
  const CustomDropdown({
    super.key,
    this.onChanged,
    required this.items,
    required this.value,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: DropdownButton<String>(
          isExpanded: true,
          items: widget.items,
          value: widget.value,
          onChanged: widget.onChanged,
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          dropdownColor: Theme.of(context).colorScheme.primary,
          underline: const SizedBox(),
          iconEnabledColor: Colors.white,
        ),
      ),
    );
  }
}
