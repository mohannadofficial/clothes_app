import 'package:ecommerce_app/core/common/loader.dart';
import 'package:ecommerce_app/features/auth/login_screen.dart';
import 'package:ecommerce_app/features/auth/register_screen.dart';
import 'package:ecommerce_app/features/home/cart/cart_details.dart';
import 'package:ecommerce_app/features/home/cart/cart_order.dart';
import 'package:ecommerce_app/features/onboarding/onboarding_screen.dart';
import 'package:ecommerce_app/shop_layout.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final ecommerceLogOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
  '/register': (_) => const MaterialPage(child: RegisterScreen()),
});

final ecommerceOnBoarding = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: OnBoardingScreen()),
});

final ecommerceLogInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: ShopLayout()),
  '/product/': (_) => const MaterialPage(child: CartDetails()),
  '/product/order/:isHome': (route) => MaterialPage(
          child: CartOrder(
        isHome: route.pathParameters['isHome']!,
      )),
});

final ecommerceLoaderRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: Loader()),
});
