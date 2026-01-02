import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/shared/costum_text.dart';

class OrderDetailWidget extends StatelessWidget {
  const OrderDetailWidget({
    super.key,
    required this.order,
    required this.taxes,
    required this.fees,
    required this.total,
  });

  final String order, taxes, fees, total;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //
        checkoutWidget('Order', order, false, false),
        Gap(10),

        checkoutWidget('Taxes', taxes, false, false),
        Gap(10),
        checkoutWidget('Delivery fees', fees, false, false),
        Gap(10),
        Divider(),
        Gap(20),
        checkoutWidget('Total : ', total, true, false),
        Gap(10),
        checkoutWidget('Estimated delivery time:', '15 - 30 mins', true, true),
      ],
    );
  }
}

Widget checkoutWidget(title, price, isBoold, isSmall) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CostumText(
        text: title,
        color: isBoold ? Colors.black : Colors.grey.shade500,
        size: isSmall ? 13 : 15,
        weight: isBoold ? FontWeight.bold : FontWeight.w500,
      ),
      CostumText(
        text: '$price \$',
        color: isBoold ? Colors.black : Colors.grey.shade500,
        size: isSmall ? 13 : 15,
        weight: isBoold ? FontWeight.bold : FontWeight.w500,
      ),
    ],
  );
}
