import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
        centerTitle: true,
      ),
      body: Center(
        child: TextButton(
            onPressed: () async {
              await makePayment();
            },
            child: const Text("Make payment")),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay:
                  //     const PaymentSheetApplePay(merchantCountryCode: "+92"),
                  // googlePay: PaymentSheetGooglePay(
                  //     testEnv: true,
                  //     currencyCode: "US",
                  //     merchantCountryCode: ''),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'adnan'))
          .then((value) => {});

          displayPaymentSheet();
    } catch (e,s) {
      print("exception:$e$s");
    }
  }

  displayPaymentSheet()async{
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
           builder: (_)=>AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle,color: Colors.green,),
                    Text("Payment SuccessFull"),
                  ],
                )
              ],
            ),
           ));

           paymentIntent = null;
      }).onError((error, stackTrace) {
        print("error is:---->$error $stackTrace");
      });
    }on StripeException catch (e) {
      print("error is--->$e");
      showDialog(
        context: context,
         builder: (_)=>const AlertDialog(
          content: Text("cancelled"),
         ));
    }catch(e){
      print("$e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          headers: {
            'Authorization':
                'Bearer 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',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body,
          );
      print("payment Intent body->>> ${response.body.toString()} ");
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user:${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculateAmount = (int.parse(amount)) * 100;
    return calculateAmount.toString();
  }
}
