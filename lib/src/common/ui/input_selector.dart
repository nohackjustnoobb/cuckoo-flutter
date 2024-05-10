import 'package:cuckoo/src/common/extensions/extensions.dart';
import 'package:cuckoo/src/common/ui/ui.dart';
import 'package:flutter/material.dart';

class InputSelectorAccessory extends StatelessWidget {
  const InputSelectorAccessory(this.description,
      {super.key, this.icon, this.onPressed});

  /// Icon to the right of the description.
  final IconData? icon;

  /// Selector current description.
  final String description;

  /// Action after being pressed.
  final Function? onPressed;

  List<Widget> _rowChildren() {
    final children = <Widget>[];

    if (icon != null) {
      children
        ..add(Icon(
          icon,
          color: ColorPresets.primary,
          size: 16.0,
        ))
        ..add(const SizedBox(width: 4.0));
    }

    children.addAll([
      Padding(
        padding: const EdgeInsets.only(bottom: 0.5),
        child: Text(
          description,
          style: TextStylePresets.body(size: 12, weight: FontWeight.w500)
              .copyWith(color: ColorPresets.primary),
        ),
      ),
      const SizedBox(width: 2.0),
      const Icon(
        Icons.expand_more_rounded,
        color: ColorPresets.primary,
        size: 15.0,
      )
    ]);

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed == null ? null : onPressed!(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(11.0, 3.5, 8.0, 3.5),
        decoration: BoxDecoration(
          color: context.cuckooTheme.primaryBackground,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _rowChildren(),
        ),
      ),
    );
  }
}
