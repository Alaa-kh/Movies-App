import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/utils/strings.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/auth/forgot_pass.dart';
import 'package:movies/view/widgets/auth/auth_text_form_filed.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../logic/controller/auth_controller.dart';
import '../../router/routers.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final AuthController _auth = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 350,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: mainClr,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(400),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 18, top: 50),
                child: TextUtils(
                  text: 'logIn'.tr,
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    AuthTextFormField(
                      hintText: 'enterEmail'.tr,
                      controller: _emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) return 'Email_required'.tr;
                        if (!RegExp(validationEmail).hasMatch(v)) {
                          return 'invalid_email'.tr;
                        }
                        return null;
                      },
                      prefixIcon:
                          const Icon(Icons.email_outlined, color: gryClr),
                    ),
                    const SizedBox(height: 20),
                    GetBuilder<AuthController>(
                      builder: (c) => AuthTextFormField(
                        hintText: 'password'.tr,
                        controller: _passwordController,
                        obscureText: !c.isVisibility,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          final v = value ?? '';
                          if (v.length < 6) {
                            return 'password_min_6'.tr;
                          }
                          return null;
                        },
                        prefixIcon:
                            const Icon(Icons.lock_outline, color: gryClr),
                        suffixIcon: IconButton(
                          onPressed: c.visibility,
                          icon: Icon(
                            c.isVisibility
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: gryClr,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.to(
                          () => const ForgotScreen(),
                          transition: Transition.downToUp,
                          duration: const Duration(milliseconds: 500),
                        ),
                        child: TextUtils(
                          text: 'forgotPass'.tr,
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: gryClr,
                        ),
                      ),
                    ),
                    const SizedBox(height: 72),
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
                            _auth.logInUsingFirebase(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                          }
                        },
                        child: TextUtils(
                          text: 'logIn'.tr,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('or'.tr, style: const TextStyle(height: 2.5)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: const BorderSide(color: gryClr),
                          ),
                        ),
                        onPressed: () => Get.offAllNamed(Routes.signupScreen),
                        child: TextUtils(
                          text: 'signUp'.tr,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: mainClr,
                        ),
                      ),
                    ),
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
