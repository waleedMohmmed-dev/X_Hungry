---
name: skill-generate-feature
description: Generate a complete Flutter feature with all 3 layers (Data, Domain, Presentation) following global rules.
---

# 🏗️ SKILL: Generate Flutter Feature

## Purpose
Generate a complete Flutter feature with all 3 layers (Data, Domain, Presentation) following global rules.

## Triggers
- "Generate a feature for..."
- "Create feature..."
- "Build feature structure..."
- "Generate [feature_name]..."

## When to Use
- Starting a new feature from scratch
- Need all 3 layers at once
- Domain entity has complex business logic
- Need proper repository pattern

## When NOT to Use
- Just modifying existing code
- Simple widgets/pages only
- Testing code
- Configuration files

## Process

### 1. Understand Requirements
Ask for:
- Feature name
- Main entity/model needed
- API endpoints (if any)
- Key business logic
- Any special dependencies

### 2. Generate Domain Layer
- Entity class (pure Dart, no Flutter)
- Repository abstract interface
- UseCase class(es)

### 3. Generate Data Layer
- Model class (extends entity)
- Remote DataSource interface + impl
- Repository implementation (implements domain interface)
- fromJson/toJson methods
- Exception handling

### 4. Generate Presentation Layer
- Event class(es)
- State class (immutable, Equatable, copyWith)
- BLoC implementation
- Page with _View pattern
- Shared widgets if needed

### 5. Setup Injection
- Register repository in injection.dart
- Register usecase in injection.dart
- Register bloc in injection.dart

## Output Checklist
- [ ] Uses barrel imports (core_imports.dart, packages_imports.dart)
- [ ] Domain layer has NO Flutter imports
- [ ] Data layer implements domain interface
- [ ] State is immutable + Equatable + copyWith
- [ ] BLoC uses Either<Failure, Success>
- [ ] Page uses BlocProvider + _View pattern
- [ ] Uses context.theme.colorScheme (no hard-coded colors)
- [ ] Uses responsive units (.w, .h, .sp, .r)
- [ ] Follows naming conventions (snake_case files, PascalCase classes)
- [ ] All strings use 'key'.tr() localization
- [ ] Error handling with Failure types
- [ ] BlocBuilder has buildWhen optimization
- [ ] BlocListener for navigation

## Template Structure
```
feature_name/
├── data/
│   ├── datasources/
│   │   └── feature_remote_data_source.dart
│   ├── models/
│   │   └── feature_model.dart
│   └── repositories/
│       └── feature_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart
│   ├── repositories/
│   │   └── feature_repository.dart
│   └── usecases/
│       └── get_feature_use_case.dart
└── presentation/
    ├── bloc/
    │   ├── feature_bloc.dart
    │   ├── feature_event.dart
    │   └── feature_state.dart
    ├── pages/
    │   └── feature_page.dart
    └── widgets/
        └── feature_widget.dart
```

## Key Patterns to Follow

### Domain UseCase
```dart
class GetFeatureUseCase implements UseCase<Feature, Params> {
  final FeatureRepository repository;
  GetFeatureUseCase(this.repository);

  @override
  Future<Either<Failure, Feature>> call(Params params) async {
    return repository.getFeature(params);
  }
}

class Params extends Equatable {
  final String id;
  const Params({required this.id});
  
  @override
  List<Object?> get props => [id];
}
```

### Data Repository
```dart
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource _remoteDataSource;
  
  FeatureRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Feature>> getFeature(String id) async {
    try {
      final model = await _remoteDataSource.getFeature(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (_) {
      return Left(NetworkFailure('No internet'));
    }
  }
}
```

### BLoC State
```dart
class FeatureState extends Equatable {
  final List<Feature> features;
  final bool isLoading;
  final String? errorMessage;

  const FeatureState({
    this.features = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FeatureState copyWith({
    List<Feature>? features,
    bool? isLoading,
    String? errorMessage,
  }) => FeatureState(
    features: features ?? this.features,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [features, isLoading, errorMessage];
}
```

### BLoC Event Handler
```dart
Future<void> _onFeatureFetched(
  FeatureFetched event,
  Emitter<FeatureState> emit,
) async {
  emit(state.copyWith(isLoading: true));
  
  final result = await _getFeatureUseCase(Params(id: event.id));
  
  result.fold(
    (failure) => emit(state.copyWith(
      isLoading: false,
      errorMessage: failure.message,
    )),
    (feature) => emit(state.copyWith(
      isLoading: false,
      features: [feature],
    )),
  );
}
```

### Page with _View Pattern
```dart
class FeaturePage extends StatelessWidget {
  const FeaturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FeatureBloc>()..add(FeatureFetched()),
      child: const _FeatureView(),
    );
  }
}

class _FeatureView extends StatelessWidget {
  const _FeatureView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('feature_title'.tr())),
      body: BlocBuilder<FeatureBloc, FeatureState>(
        buildWhen: (prev, curr) =>
          prev.isLoading != curr.isLoading ||
          prev.features != curr.features,
        builder: (context, state) {
          if (state.isLoading) return const AppLoading();
          if (state.errorMessage != null) {
            return AppError(message: state.errorMessage!);
          }
          return _buildContent(state);
        },
      ),
    );
  }

  Widget _buildContent(FeatureState state) {
    return ListView.builder(
      itemCount: state.features.length,
      itemBuilder: (_, index) => FeatureCard(
        feature: state.features[index],
      ),
    );
  }
}
```

## Important Notes
- ✅ ALWAYS use barrel imports
- ✅ Domain layer ONLY Pure Dart
- ✅ Never import presentation in data or domain
- ✅ Use Either<Failure, Success> pattern
- ✅ Make states immutable with copyWith
- ✅ Add to get_it injection after generation
- ✅ Update routing if adding new page
- ✅ Test each layer independently

