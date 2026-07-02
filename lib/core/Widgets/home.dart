// // ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, library_private_types_in_public_api

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_stripe/flutter_stripe.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   Map<String, dynamic>? paymentIntentData;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stripe Tutorial'),
//       ),
//       body: Center(
//         child: InkWell(
//           onTap: () async {
//             // final paymentMethod = await Stripe.instance.createPaymentMethod(
//             //     params: const PaymentMethodParams.card(
//             //         paymentMethodData: PaymentMethodData()));
//             await makePayment();
//           },
//           child: Container(
//             height: 50,
//             width: 200,
//             color: Colors.green,
//             child: const Center(
//               child: Text(
//                 'Pay',
//                 style: TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> makePayment() async {
//     try {
//       paymentIntentData =
//           await createPaymentIntent('20', 'USD'); //json.decode(response.body);
//       // print('Response body==>${response.body.toString()}');
//       await Stripe.instance
//           .initPaymentSheet(
//               paymentSheetParameters: SetupPaymentSheetParameters(
//                   setupIntentClientSecret: 'Your Secret Key',
//                   paymentIntentClientSecret:
//                       paymentIntentData!['client_secret'],
//                   //applePay: PaymentSheetApplePay.,
//                   //googlePay: true,
//                   //testEnv: true,
//                   customFlow: true,
//                   style: ThemeMode.dark,
//                   // merchantCountryCode: 'US',
//                   merchantDisplayName: 'Kashif'))
//           .then((value) {});

//       ///now finally display payment sheeet
//       displayPaymentSheet();
//     } catch (e, s) {
//       print('Payment exception:$e$s');
//     }
//   }

//   displayPaymentSheet() async {
//     try {
//       await Stripe.instance
//           .presentPaymentSheet(
//               //       parameters: PresentPaymentSheetParameters(
//               // clientSecret: paymentIntentData!['client_secret'],
//               // confirmPayment: true,
//               // )
//               )
//           .then((newValue) {
//         print('payment intent' + paymentIntentData!['id'].toString());
//         print(
//             'payment intent' + paymentIntentData!['client_secret'].toString());
//         print('payment intent' + paymentIntentData!['amount'].toString());
//         print('payment intent' + paymentIntentData.toString());
//         //orderPlaceApi(paymentIntentData!['id'].toString());
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text("paid successfully")));

//         paymentIntentData = null;
//       }).onError((error, stackTrace) {
//         print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
//       });
//     } on StripeException catch (e) {
//       print('Exception/DISPLAYPAYMENTSHEET==> $e');
//       showDialog(
//           context: context,
//           builder: (_) => const AlertDialog(
//                 content: Text("Cancelled "),
//               ));
//     } catch (e) {
//       print('$e');
//     }
//   }

//   //  Future<Map<String, dynamic>>
//   createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount('20'),
//         'currency': currency,
//         'payment_method_types[]': 'card',
//       };
//       print(body);
//       var response = await http.post(
//           Uri.parse('https://api.stripe.com/v1/payment_intents'),
//           body: body,
//           headers: {
//             'Authorization': 'Bearer ' + 'your token',
//             'Content-Type': 'application/x-www-form-urlencoded'
//           });
//       print('Create Intent reponse ===> ${response.body.toString()}');
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//   }

//   calculateAmount(String amount) {
//     final a = (int.parse(amount)) * 100;
//     return a.toString();
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? paymentIntentData;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Payment')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : InkWell(
                onTap: makePayment,
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Pay \$20',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> makePayment() async {
    setState(() => isLoading = true);

    try {
      // Step 1: Backend se payment intent banwao
      paymentIntentData = await createPaymentIntent('20', 'USD');

      if (paymentIntentData == null || paymentIntentData!['client_secret'] == null) {
        _showMessage('Payment ISSUES IN.', isError: true);
        setState(() => isLoading = false);
        return;
      }

     
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'Kashif',
          style: ThemeMode.dark,
        ),
      );

      // Step 3: Payment sheet dikhao
      await Stripe.instance.presentPaymentSheet();

      // Yahan tak agar exception nahi aayi, matlab payment successful hai
      _showMessage(' Payment Successful!', isError: false);
      print('Payment success. ID: ${paymentIntentData!['id']}');

      paymentIntentData = null;
    } on StripeException catch (e) {
      // User ne cancel kiya ya card decline hua
      String errorMsg = e.error.localizedMessage ?? 'Payment cancel ya fail ho gaya';
      _showMessage(' $errorMsg', isError: true);
      print('Stripe error: ${e.error}');
    } catch (e) {
      _showMessage(' Some Wrong: $e', isError: true);
      print('General error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
  try {
    var response = await http.post(
      Uri.parse('http://172.17.2.49:3000/create-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': calculateAmount(amount),
        'currency': currency,
      }),
    ).timeout(const Duration(seconds: 10)); 

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      print('Backend error: ${data['error']}');
      return null;
    }

    return data;
  } catch (err) {
    print('Network/backend error: $err'); 
    return null;
  }
}

  String calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

  void _showMessage(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}