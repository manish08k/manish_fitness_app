import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:flutter/material.dart';

class PaymentService {
  late Razorpay _razorpay;

  void init({
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onFailure,
    required Function(ExternalWalletResponse) onWallet,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onWallet);
  }

  void openCheckout({
    required int amount,
    required String name,
    required String description,
  }) {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': amount, // in paise (₹500 = 50000)
      'name': name,
      'description': description,
      'prefill': {
        'contact': '9999999999',
        'email': 'user@email.com'
      }
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}
