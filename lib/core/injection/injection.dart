import 'package:get_it/get_it.dart';
import 'package:hungry_app/core/network/api_service.dart';
import 'package:hungry_app/core/network/dio_client.dart';
import 'package:hungry_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hungry_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hungry_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:hungry_app/features/auth/domain/usecases/auto_login_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/continue_as_guest_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/get_profile_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/signup_use_case.dart';
import 'package:hungry_app/features/auth/domain/usecases/update_profile_use_case.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hungry_app/features/home/data/datasources/product_remote_data_source.dart';
import 'package:hungry_app/features/home/data/repositories/product_repository_impl.dart';
import 'package:hungry_app/features/home/domain/repositories/product_repository.dart';
import 'package:hungry_app/features/home/domain/usecases/get_options_use_case.dart';
import 'package:hungry_app/features/home/domain/usecases/get_products_use_case.dart';
import 'package:hungry_app/features/home/domain/usecases/get_toppings_use_case.dart';
import 'package:hungry_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:hungry_app/features/products/presentation/bloc/product_details_bloc.dart';
import 'package:hungry_app/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:hungry_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:hungry_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:hungry_app/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:hungry_app/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:hungry_app/features/cart/domain/usecases/remove_cart_item_use_case.dart';
import 'package:hungry_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:hungry_app/features/favorites/data/datasources/favorite_remote_data_source.dart';
import 'package:hungry_app/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:hungry_app/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:hungry_app/features/favorites/domain/usecases/get_favorites_use_case.dart';
import 'package:hungry_app/features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  _initCore();
  _initAuth();
  _initHome();
  _initCart();
  _initProducts();
  _initProfile();
  _initFavorites();
}

void _initCore() {
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<ApiService>(() => ApiService());
}

void _initAuth() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<ApiService>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<AutoLoginUseCase>(
    () => AutoLoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ContinueAsGuestUseCase>(
    () => ContinueAsGuestUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      signupUseCase: sl<SignupUseCase>(),
      getProfileUseCase: sl<GetProfileUseCase>(),
      updateProfileUseCase: sl<UpdateProfileUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      autoLoginUseCase: sl<AutoLoginUseCase>(),
      continueAsGuestUseCase: sl<ContinueAsGuestUseCase>(),
    ),
  );
}

void _initHome() {
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(sl<ApiService>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetToppingsUseCase>(
    () => GetToppingsUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetOptionsUseCase>(
    () => GetOptionsUseCase(sl<ProductRepository>()),
  );
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(
      getProductsUseCase: sl<GetProductsUseCase>(),
    ),
  );
}

void _initProducts() {
  sl.registerFactory<ProductDetailsBloc>(
    () => ProductDetailsBloc(
      getToppingsUseCase: sl<GetToppingsUseCase>(),
      getOptionsUseCase: sl<GetOptionsUseCase>(),
    ),
  );
}

void _initCart() {
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSource(sl<ApiService>()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<CartRemoteDataSource>()),
  );
  sl.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<RemoveCartItemUseCase>(
    () => RemoveCartItemUseCase(sl<CartRepository>()),
  );
  sl.registerFactory<CartBloc>(
    () => CartBloc(
      getCartUseCase: sl<GetCartUseCase>(),
      addToCartUseCase: sl<AddToCartUseCase>(),
      removeCartItemUseCase: sl<RemoveCartItemUseCase>(),
    ),
  );
}

void _initProfile() {
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: sl<GetProfileUseCase>(),
      updateProfileUseCase: sl<UpdateProfileUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      autoLoginUseCase: sl<AutoLoginUseCase>(),
    ),
  );
}

void _initFavorites() {
  sl.registerLazySingleton<FavoriteRemoteDataSource>(
    () => FavoriteRemoteDataSource(sl<ApiService>()),
  );
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(sl<FavoriteRemoteDataSource>()),
  );
  sl.registerLazySingleton<ToggleFavoriteUseCase>(
    () => ToggleFavoriteUseCase(sl<FavoriteRepository>()),
  );
  sl.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(sl<FavoriteRepository>()),
  );
  sl.registerFactory<FavoriteBloc>(
    () => FavoriteBloc(
      toggleFavoriteUseCase: sl<ToggleFavoriteUseCase>(),
      getFavoritesUseCase: sl<GetFavoritesUseCase>(),
    ),
  );
}
