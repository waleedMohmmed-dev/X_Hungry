import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/home/domain/entities/product_entity.dart';
import 'package:hungry_app/features/products/presentation/widgets/toppings_widget.dart';

class SelectableItemsList extends StatelessWidget {
  final List<ToppingEntity> items;
  final List<int> selectedIds;
  final Color addButtonColor;
  final void Function(int id) onToggle;

  const SelectableItemsList({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.addButtonColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final id = item.id;
          final isSelected = selectedIds.contains(id);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ToppingsWidget(
              downColor: isSelected
                  ? AppColors.primaryColor.withValues(alpha: 0.3)
                  : Colors.black,
              addButtonColor: addButtonColor,
              text: item.name,
              image: item.image,
              onAdd: () => onToggle(id),
            ),
          );
        }),
      ),
    );
  }
}
