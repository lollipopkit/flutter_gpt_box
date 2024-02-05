import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/data/res/ui.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String? text;
  final Color? color;
  final double? size;
  final double? padding;
  final double? fontSize;
  final FontWeight? fontWeight;

  const Badge({
    super.key,
    required this.child,
    this.text,
    this.color,
    this.size,
    this.padding,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (text != null)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: EdgeInsets.all(padding ?? 4),
              decoration: BoxDecoration(
                color: color ?? UIs.primaryColor,
                shape: BoxShape.circle,
              ),
              constraints: BoxConstraints(
                maxHeight: size ?? 20,
              ),
              child: Center(
                child: Text(
                  text!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize ?? 12,
                    fontWeight: fontWeight ?? FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}