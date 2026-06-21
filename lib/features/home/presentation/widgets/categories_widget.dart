import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/features/home/presentation/widgets/category_chip.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  final List<String> categories = ['All', 'Combo', 'Sliders', 'Classic'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          return CategoryChip(
            categoryName: categories[index],
            isSelected: selectedIndex == index,
            onTap: () {
              setState(() => selectedIndex = index);
            },
          );
        }),
      ),
    );
  }
}
