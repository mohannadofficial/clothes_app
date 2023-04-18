import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/small_text.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/auth/controller/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/controller/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = state.userModel!.name.split(' ');
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        IconlyBold.profile,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BigText(
                      text: state.userModel!.name,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ListTile(
                      leading: const Icon(IconlyBold.profile),
                      title: SmallText(text: name[0]),
                      iconColor: AppColors.iconColor,
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      leading: const Icon(IconlyBold.profile),
                      title: SmallText(text: name[1]),
                      iconColor: AppColors.iconColor,
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      leading: const Icon(IconlyBold.logout),
                      title: const SmallText(text: 'Logout'),
                      iconColor: AppColors.iconColor,
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onTap: () => sl<AuthCubit>().logOut(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
