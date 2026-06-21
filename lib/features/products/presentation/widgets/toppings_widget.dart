import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';

class ToppingsWidget extends StatelessWidget {
  final VoidCallback? onAdd;
  final double width;
  final double height;
  final String image;
  final String text;
  final Color downColor;
  final Color addButtonColor;

  const ToppingsWidget({
    super.key,
    this.onAdd,
    this.width = 120,
    this.height = 160,
    required this.image,
    required this.text,
    required this.downColor,
    required this.addButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: _cardDecoration(),
      child: Column(children: [_buildImageSection(), _buildFooterSection()]),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8),
      ],
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Image.network(
              image,
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_not_supported,
                size: 48,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection() {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: downColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(children: [_buildProductName(), _buildAddButton()]),
    );
  }

  Widget _buildProductName() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: AppText(
          text: text,
          color: Colors.white,
          size: 13.sp,
          weight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Material(
        color: addButtonColor,
        borderRadius: BorderRadius.circular(210),
        child: InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 30.w,
            height: 30.h,
            alignment: Alignment.center,
            child: const Icon(Icons.add, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
