import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/utils/strings.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/auth/auth_text_form_filed.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../logic/controller/auth_controller.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  late final AuthController _auth = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: mainClr,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(250),
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 18, top: 50, end: 18),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: const TextStyle(fontFamily: 'Cairo'),
                    children: [
                      TextSpan(
                        text: '${'forgot'.tr} ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                      ),
                      TextSpan(
                        text: 'password'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.normal,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Lottie.asset(forgotAnimate, repeat: false),
                    AuthTextFormField(
                      hintText: 'enterEmail'.tr,
                      controller: _emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Email_required'.tr;
                        if (!RegExp(validationEmail).hasMatch(v)) {
                          return 'invalid_email'.tr;
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.email_outlined, color: gryClr),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainClr,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _auth.resetPassword(_emailController.text.trim());
                          }
                        },
                        child: TextUtils(
                          text: 'send'.tr,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
