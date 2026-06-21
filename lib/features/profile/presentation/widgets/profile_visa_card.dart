import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/imports/packages_imports.dart';
import 'package:hungry_app/core/shared/widgets/app_text.dart';

class ProfileVisaCard extends StatelessWidget {
  final String? visa;

  const ProfileVisaCard({super.key, this.visa});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade900,
            Colors.blue.shade500,
            Colors.blue.shade900,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/visa_card.png',
            width: 50.w,
            color: Colors.white,
          ),
          Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(text: 'Debit Card', color: Colors.white, size: 14),
              AppText(
                text: visa ?? '**** **** **** 9857',
                color: Colors.white,
                size: 12,
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: AppText(
              text: 'Default',
              color: Colors.grey.shade800,
              size: 12,
              weight: FontWeight.w500,
            ),
          ),
          Gap(8),
          const Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.white),
        ],
      ),
    );
  }
}
