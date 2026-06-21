---
name: skill-generate-bloc
description: Generate a complete, production-ready BLoC with immutable State, Events, and proper event handlers.
---

# 📦 SKILL: Generate BLoC & State

## Purpose
Generate a complete, production-ready BLoC with immutable State, Events, and proper event handlers.

## Triggers
- "Generate bloc for..."
- "Create state management for..."
- "BLoC for..."
- "Generate [feature] bloc..."

## When to Use
- Adding state management to existing feature
- Creating new bloc for complex UI logic
- Need proper state handling with loading/error/success
- Multiple related events

## When NOT to Use
- Simple form with just one field
- Just need to rebuild on one value change (use BlocSelector instead)
- Cubit would be better (simple state, no events)

## Output Checklist
- [ ] State extends Equatable
- [ ] All state fields are final
- [ ] copyWith() implemented correctly
- [ ] props getter includes all fields
- [ ] Events are immutable
- [ ] BLoC registers all event handlers in constructor
- [ ] Uses Either<Failure, Success> for async operations
- [ ] Handles loading, success, and error states
- [ ] Uses barrel imports
- [ ] Follows naming convention

## State Template

```dart
import 'package:[PROJECT]/core/imports/core_imports.dart';
import 'package:[PROJECT]/core/imports/packages_imports.dart';

class FeatureState extends Equatable {
  final List<Item> items;
  final Item? selectedItem;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const FeatureState({
    this.items = const [],
    this.selectedItem,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  FeatureState copyWith({
    List<Item>? items,
    Item? selectedItem,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
  }) =>
      FeatureState(
        items: items ?? this.items,
        selectedItem: selectedItem ?? this.selectedItem,
        isLoading: isLoading ?? this.isLoading,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: errorMessage ?? this.errorMessage,
        successMessage: successMessage ?? this.successMessage,
      );

  @override
  List<Object?> get props => [
    items,
    selectedItem,
    isLoading,
    isSubmitting,
    errorMessage,
    successMessage,
  ];
}
```

## Event Template

```dart
abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
}

class FeatureInitialized extends FeatureEvent {
  const FeatureInitialized();

  @override
  List<Object?> get props => [];
}

class FeatureItemsFetched extends FeatureEvent {
  final String? filter;
  
  const FeatureItemsFetched({this.filter});

  @override
  List<Object?> get props => [filter];
}

class FeatureItemSelected extends FeatureEvent {
  final String itemId;
  
  const FeatureItemSelected(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class FeatureItemCreated extends FeatureEvent {
  final String name;
  final String description;
  
  const FeatureItemCreated({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}
```

## BLoC Template

```dart
import 'package:[PROJECT]/core/imports/core_imports.dart';
import 'package:[PROJECT]/core/imports/packages_imports.dart';
import 'package:[PROJECT]/core/injection/injection.dart';
import 'package:[PROJECT]/features/feature/domain/usecases/get_items_use_case.dart';
import 'package:[PROJECT]/features/feature/domain/usecases/create_item_use_case.dart';
import 'package:[PROJECT]/features/feature/presentation/bloc/feature_event.dart';
import 'package:[PROJECT]/features/feature/presentation/bloc/feature_state.dart';

class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final GetItemsUseCase _getItemsUseCase;
  final CreateItemUseCase _createItemUseCase;

  FeatureBloc({
    required GetItemsUseCase getItemsUseCase,
    required CreateItemUseCase createItemUseCase,
  })  : _getItemsUseCase = getItemsUseCase,
        _createItemUseCase = createItemUseCase,
        super(const FeatureState()) {
    // Register event handlers
    on<FeatureInitialized>(_onInitialized);
    on<FeatureItemsFetched>(_onItemsFetched);
    on<FeatureItemSelected>(_onItemSelected);
    on<FeatureItemCreated>(_onItemCreated);
  }

  // Handle initialization
  Future<void> _onInitialized(
    FeatureInitialized event,
    Emitter<FeatureState> emit,
  ) async {
    add(const FeatureItemsFetched());
  }

  // Fetch items
  Future<void> _onItemsFetched(
    FeatureItemsFetched event,
    Emitter<FeatureState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _getItemsUseCase(
      GetItemsParams(filter: event.filter),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (items) => emit(state.copyWith(
        isLoading: false,
        items: items,
        errorMessage: null,
      )),
    );
  }

  // Select item
  Future<void> _onItemSelected(
    FeatureItemSelected event,
    Emitter<FeatureState> emit,
  ) async {
    final selected = state.items.firstWhereOrNull(
      (item) => item.id == event.itemId,
    );

    emit(state.copyWith(selectedItem: selected));
  }

  // Create item
  Future<void> _onItemCreated(
    FeatureItemCreated event,
    Emitter<FeatureState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true));

    final result = await _createItemUseCase(
      CreateItemParams(
        name: event.name,
        description: event.description,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (newItem) => emit(state.copyWith(
        isSubmitting: false,
        items: [...state.items, newItem],
        successMessage: 'item_created'.tr(),
      )),
    );
  }
}
```

## Usage in UI (Do's)

### ✅ Optimized BlocBuilder
```dart
BlocBuilder<FeatureBloc, FeatureState>(
  buildWhen: (prev, curr) =>
    prev.items != curr.items ||
    prev.isLoading != curr.isLoading,
  builder: (context, state) {
    if (state.isLoading) return const AppLoading();
    return ItemsList(items: state.items);
  },
)
```

### ✅ BlocListener for Side Effects
```dart
BlocListener<FeatureBloc, FeatureState>(
  listenWhen: (prev, curr) =>
    prev.successMessage != curr.successMessage,
  listener: (context, state) {
    if (state.successMessage != null) {
      context.showSuccessSnackBar(state.successMessage!);
    }
  },
  child: child,
)
```

### ✅ BlocSelector for Single Value
```dart
BlocSelector<FeatureBloc, FeatureState, bool>(
  selector: (state) => state.isSubmitting,
  builder: (context, isSubmitting) {
    return AppButton(
      isLoading: isSubmitting,
      onPressed: () {
        context.read<FeatureBloc>().add(
          FeatureItemCreated(name: 'New', description: 'Item'),
        );
      },
    );
  },
)
```

## Important Patterns

### Pattern 1: Async Operation with Loading
```dart
emit(state.copyWith(isLoading: true));

final result = await useCase(params);

result.fold(
  (failure) => emit(state.copyWith(
    isLoading: false,
    errorMessage: failure.message,
  )),
  (data) => emit(state.copyWith(
    isLoading: false,
    data: data,
  )),
);
```

### Pattern 2: Form Submission with Validation
```dart
Future<void> _onFormSubmitted(
  FormSubmitted event,
  Emitter<FeatureState> emit,
) async {
  // Validate before submitting
  if (event.email.isEmpty) {
    emit(state.copyWith(
      errorMessage: 'Email cannot be empty',
    ));
    return;
  }

  emit(state.copyWith(isSubmitting: true));

  final result = await _submitFormUseCase(
    FormParams(email: event.email),
  );

  result.fold(
    (failure) => emit(state.copyWith(
      isSubmitting: false,
      errorMessage: failure.message,
    )),
    (_) => emit(state.copyWith(
      isSubmitting: false,
      successMessage: 'form_submitted_successfully'.tr(),
    )),
  );
}
```

### Pattern 3: Handling Multiple Operations
```dart
Future<void> _onUserUpdated(
  UserUpdated event,
  Emitter<FeatureState> emit,
) async {
  emit(state.copyWith(isUpdating: true));

  // First operation
  final profileResult = await _updateProfileUseCase(params);

  profileResult.fold(
    (failure) {
      emit(state.copyWith(
        isUpdating: false,
        errorMessage: failure.message,
      ));
    },
    (_) async {
      // Second operation
      final settingsResult = await _updateSettingsUseCase(params);

      settingsResult.fold(
        (failure) => emit(state.copyWith(
          isUpdating: false,
          errorMessage: failure.message,
        )),
        (_) => emit(state.copyWith(
          isUpdating: false,
          successMessage: 'updated_successfully'.tr(),
        )),
      );
    },
  );
}
```

## Register in get_it

```dart
// In lib/core/injection/injection.dart
sl.registerFactory<FeatureBloc>(
  () => FeatureBloc(
    getItemsUseCase: sl<GetItemsUseCase>(),
    createItemUseCase: sl<CreateItemUseCase>(),
  ),
);
```

## Key Points
- ✅ Always use Either<Failure, T> from usecases
- ✅ State must be immutable
- ✅ copyWith() must handle all fields
- ✅ Use buildWhen to prevent unnecessary rebuilds
- ✅ Use listenWhen for one-time events (success/error)
- ✅ Register bloc as factory (new per screen)
- ✅ Follow naming: event = action, state = result

