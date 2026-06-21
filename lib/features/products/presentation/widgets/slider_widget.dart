import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';

class SliderWidget extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const SliderWidget({super.key, required this.onChanged, required this.value});

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
