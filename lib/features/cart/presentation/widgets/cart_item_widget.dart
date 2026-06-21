import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';

class CartItemWidget extends StatelessWidget {
  final bool isLoading;
  final String image, text, des;
  final Function()? onAdd;
  final Function()? onRemove;
  final Function()? onMinus;
  final int number;

  const CartItemWidget({
    super.key,
    required this.isLoading,
    required this.image,
    required this.text,
    this.onAdd,
    this.onRemove,
    this.onMinus,
    required this.number,
    required this.des,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(image, width: 85.w),
                  Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(des, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onAdd,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        child: const Icon(CupertinoIcons.add, color: Colors.white),
                      ),
                    ),
                    Gap(20),
                    Text(number.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Gap(20),
                    GestureDetector(
                      onTap: onMinus,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        child: const Icon(CupertinoIcons.minus, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Gap(15),
                isLoading
                    ? const CupertinoActivityIndicator(color: Colors.black)
                    : GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: const Text('Remove', style: TextStyle(color: Colors.white, fontSize: 14)),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
