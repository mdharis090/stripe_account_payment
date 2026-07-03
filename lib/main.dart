// import 'package:flutter/material.dart';
// import 'package:payment_method_stripe/core/view_models/payment_view_model.dart';
// import 'package:payment_method_stripe/core/views/payment_screen.dart';
// import 'package:provider/provider.dart';
// import 'core/utils/connectivity_service.dart';


// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => PaymentViewModel()),
//         ChangeNotifierProvider(create: (_) => ConnectivityService()),
//       ],
//       child: MaterialApp(
//         title: 'Payment App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           useMaterial3: true,
//         ),
//         home: Consumer<ConnectivityService>(
//           builder: (context, conn, child) {
//             return Stack(
//               children: [
//                 child!,
//                 if (!conn.isOnline)
//                   Positioned(
//                     left: 0,
//                     right: 0,
//                     top: 0,
//                     child: Container(
//                       color: Colors.red,
//                       padding: EdgeInsets.symmetric(vertical: 8),
//                       child: SafeArea(
//                         child: Center(
//                           child: Text(
//                             'No internet connection. Please check your network.',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             );
//           },
//           child: PaymentScreen(userId: 1), // Pass userId
//         ),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
//  }

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_method_stripe/core/Widgets/home.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey ='';

  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}