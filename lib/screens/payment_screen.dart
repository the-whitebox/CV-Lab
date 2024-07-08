import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:crewdog_cv_lab/payment_configuration.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String operatingSystem = Platform.operatingSystem;
    var applePayButton = ApplePayButton(
      paymentConfiguration: PaymentConfiguration.fromJsonString(
          defaultApplePay),
      paymentItems:const [
        PaymentItem(amount: "0.01",
            label: 'Item A',
            status: PaymentItemStatus.final_price),
        PaymentItem(amount: "0.01",
            label: 'Item B',
            status: PaymentItemStatus.final_price),
        PaymentItem(amount: "0.02",
            label: 'Total',
            status: PaymentItemStatus.final_price),
      ],
    height: 50,width: 250,
      onPaymentResult: (result) => debugPrint('Payment Result $result'),
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );

    var googlePayButton =GooglePayButton(paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
      paymentItems:const [
        PaymentItem(amount: "0.01",
            label: 'Item A',
            status: PaymentItemStatus.final_price),
        PaymentItem(amount: "0.01",
            label: 'Item B',
            status: PaymentItemStatus.final_price),
        PaymentItem(amount: "0.02",
            label: 'Total',
            status: PaymentItemStatus.final_price),
      ],
      height: 50,width: 250,
      onPaymentResult: (result) => debugPrint('Payment Result $result'),
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );


    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if(Platform.isIOS)applePayButton,
            const Text("data"),
            if(Platform.isAndroid)googlePayButton,

          ],),
      ),
    );
  }
}
