import 'package:ecommerce_app/core/network/local/cache_helper.dart';
import 'package:ecommerce_app/core/network/remote/dio_helper.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/auth/controller/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/controller/auth_state.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/payment/controller/payment_cubit.dart';
import 'package:ecommerce_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';

// Contact me  info@mohnd-info.com to get backend api (Laravel) if you want it

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  await ServiceLocator.inti();
  await CacheHelper.init();
  String? token = CacheHelper.getData(key: 'token');
  String? userId = CacheHelper.getData(key: 'user_id');

  runApp(MyApp(
    token: token,
    userId: userId,
  ));
}

class MyApp extends StatelessWidget {
  final String? token;
  final String? userId;
  const MyApp({super.key, this.token, this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<HomeCubit>()
            ..getCategories(token!)
            ..getProduct(token!),
        ),
        BlocProvider(
          create: ((context) => sl<PaymentCubit>()..getDataPayment()),
        ),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          String? firstTime = CacheHelper.getData(key: 'first_time');
          String? token = CacheHelper.getData(key: 'token');
          String? userId = CacheHelper.getData(key: 'user_id');
          if (token != null && userId != null && firstTime != null) {
            sl<AuthCubit>().getDataSavedLogin(token: token, userId: userId);

            sl<HomeCubit>().loadLikeProduct();
          }
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Ryzen App',
            theme: ThemeData(
              primarySwatch: Colors.red,
              fontFamily: 'Ubuntu',
              scaffoldBackgroundColor: AppColors.backGroundColor,
              iconTheme: const IconThemeData(
                color: AppColors.iconColor,
              ),
              appBarTheme: const AppBarTheme(
                color: AppColors.backGroundColor,
                elevation: 0.0,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: AppColors.backGroundColor,
                selectedItemColor: AppColors.iconColor,
                showSelectedLabels: false,
                showUnselectedLabels: false,
              ),
            ),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (token != null && userId != null && firstTime != null) {
                  if (state.userModel?.token == null) {
                    return ecommerceLoaderRoute;
                  } else {
                    return ecommerceLogInRoute;
                  }
                } else {
                  if (firstTime == null) {
                    return ecommerceOnBoarding;
                  } else {
                    return ecommerceLogOutRoute;
                  }
                }
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          );
        },
      ),
    );
  }
}
