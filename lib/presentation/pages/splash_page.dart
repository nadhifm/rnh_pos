import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/presentation/pages/home_page.dart';
import 'package:rnh_pos/presentation/pages/sign_in_page.dart';
import 'package:rnh_pos/presentation/provider/check_user_notifier.dart';

import '../../commont/state_enum.dart';

class SplashPage extends StatefulWidget {
  static const ROUTE_NAME = '/splash';

  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CheckUserNotifier>(context, listen: false).checkUser());

    Timer(
      const Duration(seconds: 2),
      () {
        final state =
            Provider.of<CheckUserNotifier>(context, listen: false).state;

        if (state == RequestState.Loaded) {
          Navigator.popAndPushNamed(context, HomePage.ROUTE_NAME);
        } else if (state == RequestState.Error) {
          Navigator.popAndPushNamed(context, SignInPage.ROUTE_NAME);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/logo.svg",
              height: 120,
              width: 120,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "RnH POS",
              style: GoogleFonts.poppins(
                fontSize: 32,
                color: const Color(0xFF1A3C40),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
