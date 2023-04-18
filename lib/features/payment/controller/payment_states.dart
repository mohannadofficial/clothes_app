// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:ecommerce_app/core/enum.dart';
import 'package:ecommerce_app/models/payment_model.dart';

class PaymentStates extends Equatable {
  final String checkoutUrl;
  final String executeUrl;
  final List<PaymentModel> paymentModelList;
  final SubmissionStatus submissionStatus;

  const PaymentStates({
    this.checkoutUrl = '',
    this.executeUrl = '',
    this.paymentModelList = const [],
    this.submissionStatus = SubmissionStatus.idle,
  });

  @override
  List<Object?> get props => [
        checkoutUrl,
        executeUrl,
        paymentModelList,
        submissionStatus,
      ];

  PaymentStates copyWith({
    String? checkoutUrl,
    String? executeUrl,
    List<PaymentModel>? paymentModelList,
    SubmissionStatus? submissionStatus,
  }) {
    return PaymentStates(
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      executeUrl: executeUrl ?? this.executeUrl,
      paymentModelList: paymentModelList ?? this.paymentModelList,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }
}
