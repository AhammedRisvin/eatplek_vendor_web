import 'package:flutter/material.dart';

import 'widget/auth_common_widgets.dart';
import 'widget/login_card.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D0D1A),
      body: Column(
        children: [
          AuthHeader(),
          Expanded(child: LoginCard()),
          AuthFooter(),
        ],
      ),
    );
  }
}
