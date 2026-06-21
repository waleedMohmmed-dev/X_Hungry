---
name: skill-generate-page
description: Generate a complete Flutter UI page with proper BLoC integration, responsive design, and error handling.
---

# 🎨 SKILL: Generate Flutter UI Page

## Purpose
Generate complete, production-ready Flutter page with proper BLoC integration, responsive design, and error handling.

## Triggers
- "Create page for..."
- "Generate UI for..."
- "Build page layout..."
- "Create screen for..."

## When to Use
- Designing a new full-screen page
- Complex page with multiple widgets
- Page needs BLoC state management
- Need proper responsive layout

## When NOT to Use
- Small reusable widgets (use "Generate Widget" instead)
- Just modifying existing page
- Simple stateless components

## Output Checklist
- [ ] Uses barrel imports (core_imports, packages_imports, injection)
- [ ] Page extends StatelessWidget
- [ ] Uses BlocProvider pattern with _View separation
- [ ] Uses context.theme.colorScheme (no hard-coded colors)
- [ ] Uses responsive sizing (.w, .h, .sp, .r)
- [ ] Uses 'key'.tr() for all strings
- [ ] BlocBuilder has buildWhen optimization
- [ ] BlocListener for navigation/snackbars
- [ ] Handles loading, error, and empty states
- [ ] Uses shared widgets from core (AppButton, AppTextField, etc.)
- [ ] Proper padding/spacing with design tokens
- [ ] AppBar with proper styling
- [ ] Safe area handling

## Page Template Structure

```dart
import 'package:[PROJECT]/core/imports/core_imports.dart';
import 'package:[PROJECT]/core/imports/packages_imports.dart';
import 'package:[PROJECT]/core/injection/injection.dart';
import 'package:[PROJECT]/features/feature/presentation/bloc/feature_bloc.dart';
import 'package:[PROJECT]/features/feature/presentation/bloc/feature_event.dart';
import 'package:[PROJECT]/features/feature/presentation/bloc/feature_state.dart';

// MAIN PAGE - Creates BLoC and wraps with _View
class FeaturePage extends StatelessWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FeatureBloc>()..add(const FeatureInitialized()),
      child: const _FeatureView(),
    );
  }
}

// VIEW - Contains actual UI logic
class _FeatureView extends StatefulWidget {
  const _FeatureView();

  @override
  State<_FeatureView> createState() => _FeatureViewState();
}

class _FeatureViewState extends State<_FeatureView> {
  // Local variables if needed
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'feature_title'.tr(),
          style: tt.headlineSmall?.copyWith(
            color: cs.onPrimary,
          ),
        ),
        backgroundColor: cs.primary,
        elevation: 0,
      ),
      body: BlocListener<FeatureBloc, FeatureState>(
        listenWhen: (prev, curr) =>
          prev.errorMessage != curr.errorMessage ||
          prev.successMessage != curr.successMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
          if (state.successMessage != null) {
            context.showSuccessSnackBar(state.successMessage!);
          }
        },
        child: BlocBuilder<FeatureBloc, FeatureState>(
          buildWhen: (prev, curr) =>
            prev.isLoading != curr.isLoading ||
            prev.items != curr.items,
          builder: (context, state) {
            if (state.isLoading) {
              return const AppLoading();
            }

            if (state.items.isEmpty) {
              return AppEmptyState(
                title: 'no_items'.tr(),
                subtitle: 'add_first_item'.tr(),
                icon: Icons.inbox,
              );
            }

            return _buildContent(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FeatureState state) {
    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildItemsList(context, state),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final tt = context.theme.textTheme;
    final cs = context.theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        Text(
          'welcome'.tr(),
          style: tt.headlineSmall?.copyWith(
            color: cs.onSurface,
          ),
        ),
        Text(
          'feature_description'.tr(),
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList(BuildContext context, FeatureState state) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.items.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = state.items[index];
        return _buildItemCard(context, item);
      },
    );
  }

  Widget _buildItemCard(BuildContext context, Item item) {
    final cs = context.theme.colorScheme;

    return AppCard(
      onTap: () {
        context.read<FeatureBloc>().add(
          FeatureItemSelected(item.id),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.w,
        children: [
          // Image
          AppImage(
            imageUrl: item.imageUrl,
            height: 80.h,
            width: 80.w,
            fit: BoxFit.cover,
          ),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  item.name,
                  style: context.theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.description,
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return BlocSelector<FeatureBloc, FeatureState, bool>(
      selector: (state) => state.isSubmitting,
      builder: (context, isSubmitting) {
        return SizedBox(
          width: double.infinity,
          child: AppButton(
            onPressed: () {
              context.read<FeatureBloc>().add(
                FeatureItemCreated(
                  name: 'New Item',
                  description: 'Add a description',
                ),
              );
            },
            isLoading: isSubmitting,
            label: 'create_item'.tr(),
            icon: Icons.add,
          ),
        );
      },
    );
  }
}
```

## Common Page Patterns

### Pattern 1: Simple List Page

```dart
class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ListBloc>()..add(const ListFetched()),
      child: const _ListView(),
    );
  }
}

class _ListView extends StatelessWidget {
  const _ListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Items')),
      body: BlocBuilder<ListBloc, ListState>(
        buildWhen: (p, c) => p.items != c.items || p.isLoading != c.isLoading,
        builder: (context, state) {
          if (state.isLoading) return const AppLoading();
          if (state.items.isEmpty) return const AppEmptyState();
          
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(state.items[i].name),
            ),
          );
        },
      ),
    );
  }
}
```

### Pattern 2: Form Page

```dart
class FormPage extends StatelessWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FormBloc>(),
      child: const _FormView(),
    );
  }
}

class _FormView extends StatefulWidget {
  const _FormView();

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocListener<FormBloc, FormState>(
        listenWhen: (p, c) => c.user != null,
        listener: (context, state) {
          context.showSuccessSnackBar('Login successful');
          context.go(AppRoutes.home);
        },
        child: BlocBuilder<FormBloc, FormState>(
          buildWhen: (p, c) =>
            p.isLoading != c.isLoading ||
            p.errorMessage != c.errorMessage,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                spacing: 16.h,
                children: [
                  AppTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    onChanged: (value) => context.read<FormBloc>().add(
                      EmailChanged(value),
                    ),
                  ),
                  AppTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    isPassword: true,
                    onChanged: (value) => context.read<FormBloc>().add(
                      PasswordChanged(value),
                    ),
                  ),
                  if (state.errorMessage != null)
                    AppError(message: state.errorMessage!),
                  AppButton(
                    onPressed: () => context.read<FormBloc>().add(
                      FormSubmitted(),
                    ),
                    isLoading: state.isLoading,
                    label: 'Login',
                  ),
                ],
              );
            );
          },
        ),
      ),
    );
  }
}
```

### Pattern 3: Tabbed Page

```dart
class TabbedPage extends StatelessWidget {
  const TabbedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TabBloc>(),
      child: const _TabbedView(),
    );
  }
}

class _TabbedView extends StatefulWidget {
  const _TabbedView();

  @override
  State<_TabbedView> createState() => _TabbedViewState();
}

class _TabbedViewState extends State<_TabbedView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTab1(context),
          _buildTab2(context),
        ],
      ),
    );
  }

  Widget _buildTab1(BuildContext context) {
    return Center(child: Text('Tab 1 Content'));
  }

  Widget _buildTab2(BuildContext context) {
    return Center(child: Text('Tab 2 Content'));
  }
}
```

## Key Styling Rules

### Colors
```dart
final cs = context.theme.colorScheme;
color: cs.primary        // Main brand color
color: cs.surface        // Background
color: cs.error          // Error states
color: cs.onSurface      // Text on surface
color: cs.outline        // Borders
```

### Typography
```dart
final tt = context.theme.textTheme;
style: tt.displayLarge   // Hero text (57sp)
style: tt.headlineLarge  // Page title (32sp)
style: tt.titleLarge     // Card title (22sp)
style: tt.bodyLarge      // Primary text (16sp)
style: tt.bodySmall      // Caption (12sp)
```

### Spacing
```dart
EdgeInsets.all(16.w)                      // Standard padding
EdgeInsets.symmetric(horizontal: 24.w)    // Horizontal padding
SizedBox(height: 16.h)                     // Vertical spacing
SizedBox(height: 8.h)                      // Small gap
SizedBox(height: 32.h)                     // Large gap
```

### Border Radius
```dart
BorderRadius.circular(12.r)  // Input fields
BorderRadius.circular(16.r)  // Cards
BorderRadius.circular(24.r)  // Modals/Sheets
```

## Important Notes
- ✅ Always use const where possible
- ✅ Separate page creation (BlocProvider) from view (_View)
- ✅ Use SafeArea for proper padding on notched devices
- ✅ Build widgets in separate methods (_buildHeader, _buildContent, etc.)
- ✅ Use BlocSelector for single values (prevents unnecessary rebuilds)
- ✅ Use BlocListener for one-time effects (success, errors, navigation)
- ✅ Handle all states: loading, success, error, empty
- ✅ Use design tokens from context.designTokens
- ✅ Never hard-code colors, use theme
- ✅ Test responsiveness on different screen sizes

