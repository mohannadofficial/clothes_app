import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:ecommerce_app/core/common/snackbar.dart';
import 'package:ecommerce_app/core/constans/constans.dart';
import 'package:ecommerce_app/core/enum.dart';
import 'package:ecommerce_app/core/network/local/cache_helper.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/features/auth/controller/auth_state.dart';
import 'package:ecommerce_app/features/auth/repository/auth_repository.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState());

  void loginSubmit({
    required BuildContext context,
    required String userName,
    required String password,
  }) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
    final res = await _authRepository.loginSubmit(
      userName: userName,
      password: password,
    );

    res.fold(
      (l) {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.error,
          errorMessage: l.error,
        ));
        showSnackBar(
          context: context,
          message: AppConstans.errorMessage,
          subject: AppConstans.signIn,
          contentType: ContentType.failure,
        );
      },
      (r) {
        showSnackBar(
          context: context,
          message: AppConstans.successMessage,
          subject: AppConstans.signIn,
          contentType: ContentType.success,
        );
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.idle,
          userModel: r,
        ));
        CacheHelper.setData(key: 'token', value: state.userModel!.token);
        CacheHelper.setData(key: 'user_id', value: state.userModel!.userId);
        emit(state.copyWith(submissionStatus: SubmissionStatus.loaded));
      },
    );
  }

  void registerSubmit({
    required BuildContext context,
    required String fullName,
    required String userName,
    required String password,
  }) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
    final res = await _authRepository.registerSubmit(
      fullName: fullName,
      userName: userName,
      password: password,
    );

    res.fold(
      (l) {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.error,
          errorMessage: l.error,
        ));
        showSnackBar(
          context: context,
          message: l.error,
          subject: AppConstans.signUp,
          contentType: ContentType.failure,
        );
      },
      (r) {
        showSnackBar(
          context: context,
          message: AppConstans.successMessage,
          subject: AppConstans.signUp,
          contentType: ContentType.success,
        );
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.loaded,
        ));
      },
    );
  }

  void getDataSavedLogin(
      {required String token, required String userId}) async {
    final res =
        await _authRepository.getLoginCache(token: token, userId: userId);
    res.fold(
      (l) {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.error,
          errorMessage: l.error,
        ));
      },
      (r) {
        emit(state.copyWith(
          submissionStatus: SubmissionStatus.loaded,
          userModel: r,
        ));
      },
    );
  }

  void onBoarding() {
    CacheHelper.setData(key: 'first_time', value: 'false');
    emit(state);
  }

  void logOut() {
    CacheHelper.deleteData(key: 'token');
    CacheHelper.deleteData(key: 'user_id');
    sl<HomeCubit>().changeIndex(0);
    emit(const AuthState());
  }
}
