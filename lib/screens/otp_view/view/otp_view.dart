import 'package:flutter/material.dart';

import '../../login/view/widget/auth_common_widgets.dart';
import 'widget/otp_card.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D0D1A),
      body: Column(
        children: [
          AuthHeader(),
          Expanded(child: OtpCard()),
          AuthFooter(),
        ],
      ),
    );
  }
}
