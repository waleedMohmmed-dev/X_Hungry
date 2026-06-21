# FLUTTER GLOBAL RULES (Windsurf)

**ALWAYS start with imports:**
import 'package:[PROJECT]/core/imports/core_imports.dart';
import 'package:[PROJECT]/core/imports/packages_imports.dart';
import 'package:[PROJECT]/core/injection/injection.dart';

---

## 🌐 COMMUNICATION RULE

- 👤 User always writes in English
- 🤖 Agent ALWAYS replies in Arabic (Egyptian dialect)
- ❌ Never reply in English unless explicitly requested
- ❌ Never change the dialect

---

## 🏗️ ARCHITECTURE (3-Layer Strict)

Presentation → Domain (interfaces only)
Domain → Core ONLY
Data → Domain, Core
❌ Presentation → Data (FORBIDDEN)
❌ Domain → Flutter/packages

---

## 🎨 UI RULES

### Theme & Colors
final cs = context.theme.colorScheme;
final tt = context.theme.textTheme;
color: cs.primary  // Never hard-coded colors

### Responsive Sizing
100.w  // Width %
20.h   // Height %
14.sp  // Font size
12.r   // Border radius

### Navigation
context.go(AppRoutes.home)
context.push(AppRoutes.profile)
context.pop()

### Overlays
context.showSnackBar('msg')
context.showErrorSnackBar('msg')
context.showAppDialog(builder: ...)
context.showAppBottomSheet(builder: ...)

---

## 📦 BLoC STATE MANAGEMENT

- Immutable (final)
- Extends Equatable
- Has copyWith()
- Has status field

BlocBuilder:
BlocBuilder<AuthBloc, AuthState>(
  buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
  builder: (context, state) => ...,
)

BlocListener:
BlocListener<AuthBloc, AuthState>(
  listenWhen: (prev, curr) => curr.user != null,
  listener: (context, state) => context.go(AppRoutes.home),
  child: child,
)

BlocSelector:
BlocSelector<AuthBloc, AuthState, bool>(
  selector: (state) => state.isLoading,
  builder: (context, isLoading) => ...,
)

---

## 🔧 DEPENDENCY INJECTION

sl.registerLazySingleton<Repo>(...);
sl.registerFactory<Bloc>(...);

BlocProvider(
  create: (_) => sl<LoginBloc>(),
  child: ...,
)

---

## ⚠️ ERROR HANDLING (Either)

result.fold(
  (failure) => emit(state.copyWith(
    errorMessage: failure.message,
    isLoading: false,
  )),
  (data) => emit(state.copyWith(
    data: data,
    isLoading: false,
  )),
);

---

## 🎯 SHARED WIDGETS

AppTextField()
AppButton()
AppLoading()
AppError(message: '...')
AppEmptyState()
AppCard()
AppImage()
AppSvg()

---

## 🚫 DON'Ts

❌ API in UI → use Repository
❌ setState → use BLoC
❌ hard-coded colors → context.theme
❌ Dio in UI → DataSource
❌ data in presentation
❌ magic numbers
❌ raw strings → 'key'.tr()

---

## 📝 FILE HEADER (EVERY FILE)

import 'package:[PROJECT]/core/imports/core_imports.dart';
import 'package:[PROJECT]/core/imports/packages_imports.dart';
import 'package:[PROJECT]/core/injection/injection.dart';

---

## 📁 PROJECT STRUCTURE

core/
├── imports
├── extensions
├── injection
├── services
├── theme
├── routing
└── shared/widgets

features/
├── data
├── domain
└── presentation

---

## ✨ NAMING

file: snake_case
class: PascalCase
func: camelCase
private: _prefix
route: camelCase

---

## 🔄 DATA FLOW

UI → Event → Bloc → UseCase → Repo → DataSource → State → UI

---

## 🌐 COMMUNICATION RULE (IMPORTANT)

👤 User writes ONLY English  
🤖 Agent ALWAYS replies in English