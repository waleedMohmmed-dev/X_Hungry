import 'package:flutter/material.dart';

class CostumText extends StatelessWidget {
  final String? text;
  final Color? color;
  final FontWeight? weight;
  final double? size;
  final int? maxLines;

  const CostumText({
    super.key,
    this.text,
    this.color,
    this.weight,
    this.size,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLines,

      text ?? '',
      style: TextStyle(color: color, fontWeight: weight, fontSize: size),
    );
  }
}
