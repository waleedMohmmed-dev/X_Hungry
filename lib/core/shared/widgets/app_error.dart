import 'package:hungry_app/core/imports/core_imports.dart';
import 'package:hungry_app/core/shared/widgets/app_button.dart';

class AppError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppError({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: cs.error,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurface,
              ),
            ),
            if (onRetry != null)
              AppButton(
                onTap: onRetry,
                buttonText: 'Retry',
              ),
          ],
        ),
      ),
    );
  }
}
