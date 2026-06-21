---
name: skill-code-review
description: Review and refactor Flutter code to follow global architecture rules and best practices
---

# 🔍 SKILL: Code Review & Refactor

## Purpose
Review, analyze, and refactor Flutter code to follow global architecture rules and best practices.

## Triggers
- "Review this code..."
- "Check if this follows rules..."
- "Refactor this..."
- "Is this code correct..."
- "Fix this code to follow rules..."

## When to Use
- Reviewing existing code against rules
- Fixing architecture violations
- Improving code quality
- Finding performance issues
- Ensuring consistency

## When NOT to Use
- Writing new code (use specific generation skills)
- Simple documentation
- Non-code questions

## Review Checklist (Critical)

### Imports
- [ ] Uses barrel imports (core_imports.dart, packages_imports.dart)
- [ ] No direct package imports (e.g., import 'package:flutter/material.dart')
- [ ] Proper import order (core, then features, then relative)
- [ ] No circular imports
- [ ] All needed imports are present

### Architecture Layers
- [ ] Presentation layer doesn't import from data layer
- [ ] Domain layer doesn't import Flutter packages
- [ ] Domain layer doesn't import data layer implementations
- [ ] Each layer has single responsibility
- [ ] Interfaces in domain, implementations in data

### State Management (BLoC)
- [ ] State is immutable (all fields are final)
- [ ] State extends Equatable
- [ ] State has copyWith() method
- [ ] copyWith() creates new instance correctly
- [ ] props getter includes all fields
- [ ] Events are immutable
- [ ] BLoC registers all event handlers
- [ ] Event handlers use Either<Failure, T>
- [ ] Loading/error/success states handled

### UI/Widgets
- [ ] Uses context.theme.colorScheme (no hard-coded colors)
- [ ] Uses context.theme.textTheme (no hard-coded fonts)
- [ ] Uses responsive sizing (.w, .h, .sp, .r)
- [ ] Uses shared widgets from core (not raw Flutter)
- [ ] BlocBuilder has buildWhen optimization
- [ ] BlocListener for navigation/dialogs
- [ ] Handles loading state
- [ ] Handles error state
- [ ] Handles empty state
- [ ] Uses 'key'.tr() for all strings

### Dependency Injection
- [ ] Repositories registered as lazySingleton
- [ ] UseCases registered as lazySingleton
- [ ] BLoCs registered as factory
- [ ] Dependencies properly injected
- [ ] No hard-coded instantiation of services

### Error Handling
- [ ] Uses Either<Failure, T> pattern
- [ ] All exceptions caught and converted to Failures
- [ ] Failure types are semantic (ServerFailure, NetworkFailure, etc.)
- [ ] Error messages are user-friendly
- [ ] Error states displayed in UI

### Naming Conventions
- [ ] Files: snake_case.dart
- [ ] Classes: PascalCase
- [ ] Methods/Variables: camelCase
- [ ] Constants: camelCase (not CONSTANT_CASE)
- [ ] Private members: _leadingUnderscore
- [ ] Routes: camelCase

### Performance
- [ ] No unnecessary rebuilds (buildWhen used)
- [ ] No creating objects in build()
- [ ] No heavy operations in build()
- [ ] Lists use ListView.builder
- [ ] Images properly cached
- [ ] No memory leaks (dispose called properly)

## Refactoring Patterns

### Pattern 1: Fix Architecture Violation

**BEFORE (Wrong):**
```dart
// In presentation/page.dart
import 'package:project/features/auth/data/models/user_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Dio().post('/login'),  // API call in UI!
      builder: (context, snapshot) => ...,
    );
  }
}
```

**AFTER (Correct):**
```dart
// Use domain entities only
import 'package:project/features/auth/domain/entities/user.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) => c.user != null,
      listener: (context, state) => context.go(AppRoutes.home),
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (p, c) =>
          p.isLoading != c.isLoading ||
          p.errorMessage != c.errorMessage,
        builder: (context, state) {
          // Proper UI with error handling
          return ...,
        },
      ),
    );
  }
}
```

### Pattern 2: Fix State Management

**BEFORE (Wrong):**
```dart
class LoginState {
  String email;              // Mutable!
  String password;           // Mutable!
  bool isLoading = false;
  String? error;
  
  // No copyWith!
  // Not extending Equatable!
}
```

**AFTER (Correct):**
```dart
class LoginState extends Equatable {
  final String email;                    // Immutable
  final String password;                 // Immutable
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
    this.user,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? errorMessage,
    User? user,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        user: user ?? this.user,
      );

  @override
  List<Object?> get props =>
      [email, password, isLoading, errorMessage, user];
}
```

### Pattern 3: Fix Hard-Coded Colors

**BEFORE (Wrong):**
```dart
Container(
  color: Color(0xFF6750A4),              // Hard-coded!
  child: Text(
    'Hello',
    style: TextStyle(
      color: Color(0xFFFFFFFF),          // Hard-coded!
      fontSize: 18,                       // Not responsive!
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

**AFTER (Correct):**
```dart
final cs = context.theme.colorScheme;
final tt = context.theme.textTheme;

Container(
  color: cs.primary,
  child: Text(
    'Hello',
    style: tt.headlineMedium?.copyWith(
      color: cs.onPrimary,
    ),
  ),
)
```

### Pattern 4: Fix BLoC Event Handling

**BEFORE (Wrong):**
```dart
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmitted) {
      try {
        final user = await _loginUseCase(...);
        yield state.copyWith(user: user);
      } catch (e) {
        yield state.copyWith(error: e.toString());
      }
    }
  }
}
```

**AFTER (Correct):**
```dart
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _loginUseCase(LoginParams(...));

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
      )),
    );
  }
}
```

### Pattern 5: Fix BLoC Usage in UI

**BEFORE (Wrong):**
```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    // Always rebuilds, even if not needed!
    return Column(
      children: [
        Text(state.email),              // Doesn't depend on email
        LoadingSpinner(state.isLoading), // Only this needs rebuild
        ErrorMessage(state.error),
      ],
    );
  },
)
```

**AFTER (Correct):**
```dart
Column(
  children: [
    Text('some_static_text'.tr()),
    
    // Only rebuild when isLoading changes
    BlocSelector<AuthBloc, AuthState, bool>(
      selector: (state) => state.isLoading,
      builder: (context, isLoading) =>
        LoadingSpinner(isLoading: isLoading),
    ),
    
    // Separate listener for one-time errors
    BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) => p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          context.showErrorSnackBar(state.errorMessage!);
        }
      },
      child: const SizedBox(),
    ),
  ],
)
```

### Pattern 6: Fix String Localization

**BEFORE (Wrong):**
```dart
Text('Hello World'),                    // Hard-coded!
context.showSnackBar('Login successful'),
AppButton(label: 'Click me'),
```

**AFTER (Correct):**
```dart
Text('hello_world'.tr()),               // Localized!
context.showSnackBar('login_successful'.tr()),
AppButton(label: 'click_me'.tr()),
```

### Pattern 7: Fix Responsive Design

**BEFORE (Wrong):**
```dart
Container(
  width: 100,                           // Fixed!
  height: 50,                           // Fixed!
  padding: EdgeInsets.all(15),          // Fixed!
  child: Text(
    'Title',
    style: TextStyle(fontSize: 18),     // Fixed!
  ),
)
```

**AFTER (Correct):**
```dart
Container(
  width: 100.w,                         // Responsive %
  height: 50.h,                         // Responsive %
  padding: EdgeInsets.all(16.w),        // Responsive
  child: Text(
    'title'.tr(),                       // Localized
    style: TextStyle(fontSize: 18.sp),  // Responsive font
  ),
)
```

## Common Issues & Solutions

| Issue | Cause | Fix |
|-------|-------|-----|
| "State not immutable" | Fields not final | Make all fields final |
| "Rebuilds too often" | No buildWhen | Add buildWhen optimization |
| "Colors not consistent" | Hard-coded colors | Use context.theme.colorScheme |
| "Imports not working" | Direct imports | Use barrel imports |
| "Cross-layer imports" | Presentation imports data | Only import domain layer |
| "No error handling" | No Either pattern | Use Either<Failure, T> |
| "Widgets not reusable" | Feature-specific widgets | Move to core/shared |
| "Localization missing" | Hard-coded strings | Use 'key'.tr() |

## Review Output

When reviewing code, provide:

1. **Summary**: Overview of issues found
2. **Critical Issues**: Must fix before merge
   - Architecture violations
   - Hard-coded values
   - Memory leaks
   
3. **Important Issues**: Should fix
   - Performance concerns
   - Inconsistent naming
   - Missing error handling
   
4. **Nice-to-Haves**: Can improve
   - Code clarity
   - Documentation
   - Test coverage

5. **Refactored Code**: Fixed version if complex

## Example Review Output

```
## Code Review Summary

✅ Good Points:
- Proper 3-layer architecture
- Good error handling with Either

⚠️ Critical Issues (Must Fix):
1. Line 45: Hard-coded color (0xFF6750A4) - use cs.primary
2. Line 12: Mutable state fields - make final
3. Line 80: Presentation imports data layer - import domain only

🔧 Important Issues (Should Fix):
1. Line 120: BlocBuilder rebuilds unnecessarily - add buildWhen
2. Missing error state handling in UI
3. Strings not localized - use 'key'.tr()

💡 Nice-to-Haves:
1. Extract _buildContent to separate method
2. Add documentation comments to public methods

## Refactored Code:
[Here provide the corrected version]
```

## Checklist Before Approval
- [ ] No architecture violations
- [ ] Proper error handling
- [ ] Strings localized
- [ ] Colors from theme
- [ ] State immutable
- [ ] Responsive sizing
- [ ] No hard-coded values
- [ ] Proper naming
- [ ] Tests included
- [ ] Documentation complete

