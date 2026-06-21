import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';

SnackBar appSnackBar(String errorMsg) {
  return SnackBar(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    margin: const EdgeInsets.only(bottom: 30, right: 20, left: 20),
    elevation: 10,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red.shade900,
    content: FittedBox(
      child: Row(
        children: [
          const Icon(CupertinoIcons.info, color: Colors.white),
          Gap(14),
          Text(
            errorMsg,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
