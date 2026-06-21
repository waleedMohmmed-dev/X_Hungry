import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hungry_app/core/injection/injection.dart';
import 'package:hungry_app/core/theme/app_theme.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hungry_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:hungry_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:hungry_app/features/favorites/presentation/bloc/favorite_event.dart';
import 'package:hungry_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:hungry_app/features/profile/presentation/bloc/profile_event.dart';
import 'package:hungry_app/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()..add(const AutoLoginRequested())),
            BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()..add(const ProfileInit())),
            BlocProvider<HomeBloc>(create: (_) => sl<HomeBloc>()),
            BlocProvider<CartBloc>(create: (_) => sl<CartBloc>()),
            BlocProvider<FavoriteBloc>(create: (_) => sl<FavoriteBloc>()..add(const FavoritesRequested())),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SplashView(),
            debugShowCheckedModeBanner: false,
            title: 'Hungry App',
          ),
        );
      },
    );
  }
}
