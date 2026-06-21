import 'package:hungry_app/core/imports/core_imports.dart';

class AppLoading extends StatelessWidget {
  final String? message;
  final Color? color;

  const AppLoading({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          CupertinoActivityIndicator(
            color: color ?? cs.primary,
          ),
          if (message != null)
            Text(
              message!,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
