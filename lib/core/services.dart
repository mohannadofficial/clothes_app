import 'package:ecommerce_app/features/auth/controller/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/repository/auth_repository.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/home/repository/home_repository.dart';
import 'package:ecommerce_app/features/payment/controller/payment_cubit.dart';
import 'package:ecommerce_app/features/payment/repository/payment_repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

class ServiceLocator {
  static inti() {
    // Controller
    sl.registerLazySingleton<AuthCubit>(
      () => AuthCubit(authRepository: sl()),
    );
    sl.registerLazySingleton<HomeCubit>(
      () => HomeCubit(homeRepository: sl()),
    );

    sl.registerLazySingleton<PaymentCubit>(
        (() => PaymentCubit(paymentRepository: sl())));

    // Repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepository(),
    );
    sl.registerLazySingleton<HomeRepository>(
      () => HomeRepository(),
    );
    sl.registerLazySingleton<PaymentRepository>(
      () => PaymentRepository(),
    );
  }
}
