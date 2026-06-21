import 'package:hungry_app/core/imports/core_imports.dart';

class AppText extends StatelessWidget {
  final String? text;
  final Color? color;
  final FontWeight? weight;
  final double? size;
  final int? maxLines;
  final TextAlign? textAlign;

  const AppText({
    super.key,
    this.text,
    this.color,
    this.weight,
    this.size,
    this.maxLines,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      maxLines: maxLines,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontWeight: weight,
        fontSize: size,
      ),
    );
  }
}
