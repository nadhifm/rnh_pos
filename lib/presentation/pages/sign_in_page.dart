import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rnh_pos/presentation/provider/sign_in_notifier.dart';
import 'package:rnh_pos/presentation/widgets/custom_text_field.dart';
import 'package:rnh_pos/presentation/widgets/primary_button.dart';

import '../../commont/state_enum.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  static const ROUTE_NAME = '/sign-in';

  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masuk",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A3C40),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                controller: emailController,
                hint: "Email",
                inputType: TextInputType.emailAddress,
                asset: "assets/ic_email.svg",
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomTextField(
                controller: passwordController,
                hint: "Password",
                inputType: TextInputType.visiblePassword,
                asset: "assets/ic_password.svg",
              ),
              const SizedBox(
                height: 24.0,
              ),
              PrimaryButton(
                text: "Masuk",
                onPressed: () async {
                  showLoadingDialog();

                  await Provider.of<SignInNotifier>(
                    context,
                    listen: false,
                  ).signIn(emailController.text, passwordController.text);

                  if (!mounted) return;

                  final state = Provider.of<SignInNotifier>(
                    context,
                    listen: false,
                  ).state;
                  if (state == RequestState.Loaded) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, HomePage.ROUTE_NAME);
                  } else if (state == RequestState.Error) {
                    Navigator.pop(context);
                    final message = Provider.of<SignInNotifier>(
                      context,
                      listen: false,
                    ).message;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(message)));
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sigIn(String email, String password) async {
    showLoadingDialog();

    await Provider.of<SignInNotifier>(
      context,
      listen: false,
    ).signIn(email, password);

    if (!mounted) return;

    final state = Provider.of<SignInNotifier>(
      context,
      listen: false,
    ).state;
    if (state == RequestState.Loaded) {
      Navigator.pop(context);
      Navigator.pushNamed(context, HomePage.ROUTE_NAME);
    } else if (state == RequestState.Error) {
      Navigator.pop(context);
      final message = Provider.of<SignInNotifier>(
        context,
        listen: false,
      ).message;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16.0),
              height: 100,
              width: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    color: Color(0xFF1A3C40),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text("Loading"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
