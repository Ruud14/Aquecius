import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Selector extends StatefulWidget {
  final void Function(String) onChanged;
  final List<String> items;
  final String? initialItem;
  const Selector({
    super.key,
    required this.items,
    required this.onChanged,
    this.initialItem,
  });

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  // The currently selected item.
  late String active;

  @override
  void initState() {
    active = widget.initialItem ?? widget.items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(22)),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items
            .map(
              (e) => Expanded(
                child: GestureDetector(
                  onTap: () {
                    active = e;
                    widget.onChanged(e);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(22)),
                        color: active == e ? Theme.of(context).colorScheme.primary : Colors.transparent,
                      ),
                      child: Text(
                        e,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        softWrap: false,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
