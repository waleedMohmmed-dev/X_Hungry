import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/shared/costum_text.dart';

SnackBar customSnack(errorMsg) {
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
          CostumText(
            text: errorMsg,
            color: Colors.white,
            size: 10,
            weight: FontWeight.w600,
          ),
        ],
      ),
    ),
  );
}
