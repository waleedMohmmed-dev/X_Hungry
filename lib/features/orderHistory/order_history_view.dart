import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/shared/costum_button.dart';
import 'package:hungry_app/shared/costum_text.dart';

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        scrolledUnderElevation: 0,
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 30, bottom: 120),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/test/test.png', width: 110),
                        //
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            CostumText(
                              text: 'Humburger',
                              weight: FontWeight.bold,
                              size: 16,
                            ),
                            CostumText(
                              text: 'Qiy : X3',
                              weight: FontWeight.bold,
                              size: 16,
                            ),
                            CostumText(
                              text: 'Price : 20\$ ',
                              weight: FontWeight.bold,
                              size: 16,
                            ),
                          ],
                        ),

                        //
                      ],
                    ),
                    //
                    Gap(15),
                    CostumButton(
                      buttonText: 'Order Again',
                      onTap: () {},
                      bordersRadius: 20,
                      buttonColor: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
