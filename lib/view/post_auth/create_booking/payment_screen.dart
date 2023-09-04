// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:naai/utils/colors_constant.dart';
// import 'package:naai/utils/image_path_constant.dart';
// import 'package:naai/utils/string_constant.dart';
// import 'package:naai/view/widgets/reusable_widgets.dart';
// import 'package:naai/view_model/post_auth/profile/profile_provider.dart';
// import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:sizer/sizer.dart';

// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   Razorpay _razorpay = Razorpay();
//   bool singleStaffListExpanded = false;
//   bool showArtistSlotDialogue = false;
//   bool transactionStarted = false;

//   @override
//   void initState() {
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

//     super.initState();
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     context.read<SalonDetailsProvider>().createBooking(
//           context,
//           "success",
//           response.paymentId,
//           response.orderId,
//         );
//     ReusableWidgets.showFlutterToast(context, '${response.paymentId}');
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     context.read<SalonDetailsProvider>().createBooking(
//           context,
//           "error",
//           response.message,
//           response.code.toString(),
//         );
//     ReusableWidgets.showFlutterToast(context, '${response.message}');
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {}

//   @override
//   Widget build(BuildContext context) {
//     Future(() {
//       if (!transactionStarted) {
//         transactionStarted = true;
//         var options = {
//           'key': 'rzp_test_3ASjsda4PANL3X',
//           'amount': context.read<SalonDetailsProvider>().totalPrice * 100,
//           'name': 'NAAI',
//           'description':
//               context.read<SalonDetailsProvider>().selectedSalonData.name,
//           'prefill': {
//             'contact': context.read<ProfileProvider>().userData.phoneNumber,
//             'email': context.read<ProfileProvider>().userData.gmailId,
//           }
//         };
//         _razorpay.open(options);
//       }
//     });
//     return Consumer<SalonDetailsProvider>(
//       builder: (context, provider, child) {
//         return Scaffold(
//           body: Stack(
//             children: <Widget>[
//               ReusableWidgets.appScreenCommonBackground(),
//               Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
