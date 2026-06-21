import 'package:hungry_app/core/imports/core_imports.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final bool hasBorder;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 2,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(16),
      color: backgroundColor ?? cs.surfaceContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: hasBorder
                ? Border.all(
                    color: cs.outline.withValues(alpha: 0.3),
                    width: 1,
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
