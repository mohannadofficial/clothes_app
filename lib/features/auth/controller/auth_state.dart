import 'package:ecommerce_app/core/enum.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final UserModel? userModel;
  final SubmissionStatus submissionStatus;
  final String errorMessage;

  const AuthState({
    this.userModel,
    this.submissionStatus = SubmissionStatus.idle,
    this.errorMessage = '',
  });

  AuthState copyWith({
    final UserModel? userModel,
    final SubmissionStatus? submissionStatus,
    final String? errorMessage,
  }) {
    return AuthState(
      userModel: userModel ?? this.userModel,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        userModel,
        submissionStatus,
        errorMessage,
      ];
}
