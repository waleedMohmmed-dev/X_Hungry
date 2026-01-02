import 'package:flutter/material.dart';
import 'package:hungry_app/core/constans/app_colors.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key, required this.onChanged, required this.value});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0,
      max: 1,
      value: widget.value,
      onChanged: widget.onChanged,
      inactiveColor: Colors.grey.shade300,
      activeColor: AppColors.primaryColor,
    );
  }
}
