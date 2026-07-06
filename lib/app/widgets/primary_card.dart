import 'package:flutter/material.dart';

class PrimaryCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const PrimaryCard({Key? key, required this.child, this.padding = const EdgeInsets.all(16), this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Padding(
        padding: padding,
        child: child,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
    );

    if (onTap != null) {
      return InkWell(onTap: onTap, child: card);
    }

    return card;
  }
}
