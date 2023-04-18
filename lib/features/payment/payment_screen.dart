import 'package:ecommerce_app/core/common/loader.dart';
import 'package:ecommerce_app/core/enum.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/payment/controller/payment_cubit.dart';
import 'package:ecommerce_app/features/payment/controller/payment_states.dart';
import 'package:ecommerce_app/features/payment/repository/payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:routemaster/routemaster.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatelessWidget {
  final Function(Map<String, dynamic>?)? onFinish;
  const PaymentScreen({super.key, this.onFinish});

  @override
  Widget build(BuildContext context) {
    int oneTime = 0;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final payment = sl<PaymentCubit>();
    return BlocBuilder<PaymentCubit, PaymentStates>(
      builder: (context, state) {
        if (state.checkoutUrl.isNotEmpty) {
          switch (state.submissionStatus) {
            case SubmissionStatus.idle:
              return Scaffold(
                  appBar: AppBar(
                    elevation: 0.0,
                    backgroundColor: AppColors.whiteColor,
                    leading: GestureDetector(
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF5420EF),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  body: GestureDetector(
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..setBackgroundColor(const Color(0x00000000))
                        ..setNavigationDelegate(
                          NavigationDelegate(
                            onProgress: (int progress) {},
                            onPageStarted: (String url) {},
                            onPageFinished: (String url) {},
                            onWebResourceError: (WebResourceError error) {},
                            onNavigationRequest: (NavigationRequest request) {
                              if (request.url.contains(payment.returnURL)) {
                                final uri = Uri.parse(request.url);
                                final payerID = uri.queryParameters['PayerID'];
                                if (payerID != null) {
                                  oneTime = oneTime + 1;

                                  if (oneTime == 1) {
                                    sl<PaymentRepository>()
                                        .executePayment(state.executeUrl,
                                            payerID, payment.accessToken)
                                        .then((id) {
                                      onFinish!(id);
                                    });
                                  }
                                }
                              }
                              if (request.url.contains(payment.cancelURL)) {
                                Routemaster.of(context).pop();
                              }
                              return NavigationDecision.navigate;
                            },
                          ),
                        )
                        ..loadRequest(Uri.parse(state.checkoutUrl)),
                    ),
                  ));

            case SubmissionStatus.inProgress:
              return const Loader();
            case SubmissionStatus.loaded:
              return const Loader();
            case SubmissionStatus.error:
              return const Loader();
          }
        } else {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              elevation: 0.0,
            ),
            body: const Center(child: Loader()),
          );
        }
      },
    );
  }
}
