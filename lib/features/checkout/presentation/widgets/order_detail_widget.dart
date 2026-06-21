import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';

class OrderDetailWidget extends StatelessWidget {
  final String order, taxes, fees, total;

  const OrderDetailWidget({
    super.key,
    required this.order,
    required this.taxes,
    required this.fees,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _checkoutWidget('Order', order, false, false),
        Gap(10),
        _checkoutWidget('Taxes', taxes, false, false),
        Gap(10),
        _checkoutWidget('Delivery fees', fees, false, false),
        Gap(10),
        const Divider(),
        Gap(20),
        _checkoutWidget('Total : ', total, true, false),
        Gap(10),
        _checkoutWidget('Estimated delivery time:', '15 - 30 mins', true, true),
      ],
    );
  }
}

Widget _checkoutWidget(String title, String price, bool isBold, bool isSmall) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      AppText(
        text: title,
        color: isBold ? Colors.black : Colors.grey.shade500,
        size: isSmall ? 13 : 15,
        weight: isBold ? FontWeight.bold : FontWeight.w500,
      ),
      AppText(
        text: '$price \$',
        color: isBold ? Colors.black : Colors.grey.shade500,
        size: isSmall ? 13 : 15,
        weight: isBold ? FontWeight.bold : FontWeight.w500,
      ),
    ],
  );
}
