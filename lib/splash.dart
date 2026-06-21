import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/root.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 200),
      () => setState(() => _opacity = 1.0),
    );
    Future.delayed(const Duration(seconds: 1), _checkLogin);
  }

  Future<void> _checkLogin() async {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Root()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withValues(alpha: 0.9),
            AppColors.primaryColor.withValues(alpha: 0.8),
            AppColors.primaryColor.withValues(alpha: 0.7),
            AppColors.primaryColor.withValues(alpha: 0.6),
            AppColors.primaryColor.withValues(alpha: 0.5),
            AppColors.primaryColor.withValues(alpha: 0.4),
            AppColors.primaryColor.withValues(alpha: 0.3),
            AppColors.primaryColor.withValues(alpha: 0.2),
            AppColors.primaryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        body: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _opacity,
            curve: Curves.easeInOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Gap(280),
                const Spacer(),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 40, end: 0),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) => Transform.translate(
                    offset: Offset(0, value),
                    child: child,
                  ),
                  child: Image.asset(
                    'assets/splach/splsh.png',
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// welltetx
///wellltext@gmail.com
///22222222



/// register done 
/// login done
/// profile done
/// cart done 
/// checkout done
/// 

