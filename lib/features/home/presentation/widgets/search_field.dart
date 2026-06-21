import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/core/shared/widgets/app_text_field.dart';

class SearchField extends StatefulWidget {
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const SearchField({super.key, this.onChanged, this.controller});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(20.r),
      child: AppTextField(
        onChanged: widget.onChanged,
        controller: widget.controller,
        width: double.infinity,
        hintText: 'Search ',
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.primaryColor,
          size: 30.sp,
        ),
      ),
    );
  }
}
