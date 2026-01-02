import 'package:flutter/material.dart';
import 'package:hungry_app/shared/costum_categories.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  List categorey = ['All', 'Combo', 'Sliders', 'Classic'];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categorey.length, (index) {
          return CostumCategories(
            catogeryName: categorey[index],

            isSelected: selectedIndex == index,
            onPress: () {
              setState(() {
                selectedIndex = index;
              });
            },
          );
        }),
      ),
    );
  }
}
