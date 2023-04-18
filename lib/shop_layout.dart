import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = sl<HomeCubit>();
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: cubit.screens[state.selectIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectIndex,
            onTap: cubit.changeIndex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.home),
                activeIcon: Icon(IconlyBold.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.heart),
                activeIcon: Icon(IconlyBold.heart),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.document),
                activeIcon: Icon(IconlyBold.document),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconlyLight.profile),
                activeIcon: Icon(IconlyBold.profile),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
