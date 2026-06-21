---
name: skill-generate-widget
description: Generate reusable, production-ready widgets for core/shared/widgets/ directory following design system standards
---

# 🧩 SKILL: Generate Shared Widget

## Purpose
Generate reusable, production-ready widgets for core/shared/widgets/ directory following design system standards.

## Triggers
- "Create widget for..."
- "Generate reusable widget..."
- "Build shared component..."
- "Create [name] widget..."

## When to Use
- Creating reusable components (buttons, cards, inputs)
- Widget will be used in multiple places
- Need consistent styling across app
- Widget needs customization via parameters
- Building design system components

## When NOT to Use
- One-off widgets for specific feature
- Simple widgets with single use
- Page-level widgets (use "Generate Page" instead)
- Internal feature widgets

## Output Checklist
- [ ] Extends StatelessWidget or StatefulWidget appropriately
- [ ] Uses barrel imports
- [ ] All parameters are well-named and documented
- [ ] Uses const constructor
- [ ] Uses context.theme.colorScheme for colors
- [ ] Uses responsive sizing (.w, .h, .sp, .r)
- [ ] Supports customization via parameters
- [ ] Documentation comments (@param, @return)
- [ ] Follows naming convention (AppWidgetName)
- [ ] Can be used with minimal parameters
- [ ] Handles edge cases (empty strings, null values)
- [ ] Proper default values

## Widget Template

```dart
import 'package:[PROJECT]/core/imports/core_imports.dart';
import 'package:[PROJECT]/core/imports/packages_imports.dart';

/// [AppCustomWidget] - Brief description of widget
/// 
/// A reusable widget that [does something specific].
/// 
/// Parameters:
/// - [title] - Main text displayed in the widget
/// - [subtitle] - Optional secondary text
/// - [onTap] - Callback when widget is tapped
/// - [icon] - Optional leading icon
/// - [variant] - Style variant (primary, secondary, etc.)
/// 
/// Example:
/// ```dart
/// AppCustomWidget(
///   title: 'Hello',
///   subtitle: 'World',
///   onTap: () => print('Tapped'),
/// )
/// ```
class AppCustomWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final IconData? icon;
  final WidgetVariant variant;
  final EdgeInsets padding;

  const AppCustomWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.icon,
    this.variant = WidgetVariant.primary,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final backgroundColor = _getBackgroundColor(cs);
    final textColor = _getTextColor(cs);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _getBorderColor(cs),
            width: 1,
          ),
        ),
        child: Row(
          spacing: 12.w,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: textColor,
                size: 24.r,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.h,
                children: [
                  Text(
                    title,
                    style: tt.titleMedium?.copyWith(color: textColor),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: tt.bodySmall?.copyWith(
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(ColorScheme cs) {
    return switch (variant) {
      WidgetVariant.primary => cs.primaryContainer,
      WidgetVariant.secondary => cs.secondaryContainer,
      WidgetVariant.error => cs.errorContainer,
    };
  }

  Color _getTextColor(ColorScheme cs) {
    return switch (variant) {
      WidgetVariant.primary => cs.onPrimaryContainer,
      WidgetVariant.secondary => cs.onSecondaryContainer,
      WidgetVariant.error => cs.onErrorContainer,
    };
  }

  Color _getBorderColor(ColorScheme cs) {
    return switch (variant) {
      WidgetVariant.primary => cs.primary.withOpacity(0.3),
      WidgetVariant.secondary => cs.secondary.withOpacity(0.3),
      WidgetVariant.error => cs.error.withOpacity(0.3),
    };
  }
}

enum WidgetVariant { primary, secondary, error }
```

## Common Shared Widgets

### Pattern 1: Custom Button

```dart
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final double? width;

  const AppButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    
    return SizedBox(
      width: width ?? double.infinity,
      height: _getHeight(),
      child: Material(
        color: _getBackgroundColor(cs),
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: isDisabled || isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: isLoading
              ? SizedBox(
                  height: _getIconSize(),
                  width: _getIconSize(),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      _getTextColor(cs),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    if (icon != null)
                      Icon(
                        icon,
                        color: _getTextColor(cs),
                        size: _getIconSize(),
                      ),
                    Text(
                      label,
                      style: _getTextStyle(context),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  double _getHeight() => switch (size) {
    ButtonSize.small => 36.h,
    ButtonSize.medium => 48.h,
    ButtonSize.large => 56.h,
  };

  double _getIconSize() => switch (size) {
    ButtonSize.small => 16.r,
    ButtonSize.medium => 20.r,
    ButtonSize.large => 24.r,
  };

  Color _getBackgroundColor(ColorScheme cs) {
    if (isDisabled) return cs.surfaceContainerHighest;
    return switch (variant) {
      ButtonVariant.primary => cs.primary,
      ButtonVariant.secondary => cs.secondary,
      ButtonVariant.outline => Colors.transparent,
    };
  }

  Color _getTextColor(ColorScheme cs) {
    if (isDisabled) return cs.onSurfaceVariant;
    return switch (variant) {
      ButtonVariant.primary => cs.onPrimary,
      ButtonVariant.secondary => cs.onSecondary,
      ButtonVariant.outline => cs.primary,
    };
  }

  TextStyle? _getTextStyle(BuildContext context) {
    final tt = context.theme.textTheme;
    final cs = context.theme.colorScheme;
    return tt.labelLarge?.copyWith(
      color: _getTextColor(cs),
    );
  }
}

enum ButtonVariant { primary, secondary, outline }
enum ButtonSize { small, medium, large }
```

### Pattern 2: Custom TextField

```dart
class AppTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool readOnly;
  final int? maxLength;
  final int maxLines;
  final int minLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const AppTextField({
    Key? key,
    this.hintText,
    this.labelText,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.readOnly = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          maxLength: widget.maxLength,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: cs.outline)
              : null,
            suffixIcon: widget.isPassword
              ? GestureDetector(
                  onTap: () => setState(() => _obscureText = !_obscureText),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: cs.outline,
                  ),
                )
              : widget.suffixIcon != null
                ? GestureDetector(
                    onTap: widget.onSuffixTap,
                    child: Icon(widget.suffixIcon, color: cs.outline),
                  )
              : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: cs.error),
            ),
          ),
        ),
      ],
    );
  }
}
```

### Pattern 3: Custom Card

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double elevation;
  final bool hasBorder;

  const AppCard({
    Key? key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 2,
    this.hasBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(16.r),
      color: backgroundColor ?? cs.surfaceContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: hasBorder
              ? Border.all(
                  color: cs.outline.withOpacity(0.3),
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
```

### Pattern 4: Loading Indicator

```dart
class AppLoading extends StatelessWidget {
  final String? message;
  final Color? color;

  const AppLoading({
    Key? key,
    this.message,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16.h,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(
              color ?? cs.primary,
            ),
            strokeWidth: 3,
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
```

### Pattern 5: Error Display

```dart
class AppError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppError({
    Key? key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16.h,
          children: [
            Icon(
              icon,
              size: 64.r,
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
                onPressed: onRetry!,
                label: 'retry'.tr(),
                variant: ButtonVariant.primary,
              ),
          ],
        ),
      ),
    );
  }
}
```

## Export Widget in Barrel Import

```dart
// lib/core/shared/widgets/widgets.dart
export 'app_button.dart';
export 'app_text_field.dart';
export 'app_card.dart';
export 'app_loading.dart';
export 'app_error.dart';
export 'app_empty_state.dart';
export 'app_custom_widget.dart';

// Then in core_imports.dart, add:
export 'package:[PROJECT]/core/shared/widgets/widgets.dart';
```

## Key Points
- ✅ Always use const constructor
- ✅ Extract colors/typography from context.theme
- ✅ Use responsive sizing for all dimensions
- ✅ Provide sensible defaults
- ✅ Support customization via parameters
- ✅ Use documentation comments
- ✅ Test with different screen sizes
- ✅ Reuse other shared widgets when possible
- ✅ Keep widgets focused on one responsibility
- ✅ Export from barrel imports

