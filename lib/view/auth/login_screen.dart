import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/auth/forgot_pass.dart';
import 'package:movies/view/auth/signup_screen.dart';
import 'package:movies/view/widgets/auth/auth_text_form_filed.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../logic/controller/auth_controller.dart';
import '../../utils/strings.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final AuthController controller = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(400),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 18, top: 50),
                child: TextUtils(
                  text: logIn,
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    AuthTextFormField(
                      hintText: enterEmail,
                      controller: emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final v = value ?? '';
                        if (v.isEmpty) return 'Email is required';
                        if (!RegExp(validationEmail).hasMatch(v)) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      prefixIcon:
                          const Icon(Icons.email_outlined, color: gryClr),
                    ),
                    const SizedBox(height: 20),
                    GetBuilder<AuthController>(
                      builder: (c) => AuthTextFormField(
                        hintText: password,
                        controller: passwordController,
                        obscureText: !c.isVisibility,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          final v = value ?? '';
                          if (v.length < 6) {
                            return 'Password should be longer or equal to 6 characters';
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
                        onTap: () {
                          Get.to(
                            ForgotScreen(),
                            transition: Transition.downToUp,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        child: const TextUtils(
                          text: forgotPass,
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(mainClr),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            controller.logInUsingFirebase(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );
                          }
                        },
                        child: const TextUtils(
                          text: logIn,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(or, style: TextStyle(height: 2.5)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: const BorderSide(color: gryClr),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Get.offAll(
                            SignUpScreen(),
                            transition: Transition.zoom,
                            duration: const Duration(milliseconds: 700),
                          );
                        },
                        child: const TextUtils(
                          text: signUp,
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
