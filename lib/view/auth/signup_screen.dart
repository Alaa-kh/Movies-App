import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/utils/strings.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/auth/auth_text_form_filed.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../logic/controller/auth_controller.dart';
import '../../router/routers.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController _auth = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
              height: 310,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: mainClr,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(250),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 18,  left: 18, top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextUtils(
                      text: 'signUp'.tr,
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    TextUtils(
                      text: 'createAccount'.tr,
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    AuthTextFormField(
                      hintText: 'enterName'.tr,
                      controller: _nameController,
                      obscureText: false,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.length <= 2 || !RegExp(validationName).hasMatch(v)) {
                          return 'enter_valid_name'.tr;
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.person_2_outlined, color: gryClr),
                    ),
                    const SizedBox(height: 20),
                    AuthTextFormField(
                      hintText: 'enterEmail'.tr,
                      controller: _emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (!RegExp(validationEmail).hasMatch(v)) {
                          return 'invalid_email'.tr;
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.email_outlined, color: gryClr),
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
                        prefixIcon: const Icon(Icons.lock_outline, color: gryClr),
                        suffixIcon: IconButton(
                          onPressed: c.visibility,
                          icon: Icon(
                            c.isVisibility ? Icons.visibility : Icons.visibility_off,
                            color: gryClr,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
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
                            _auth.signUpUsingFirebase(
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                          }
                        },
                        child: TextUtils(
                          text: 'signUp'.tr,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('or'.tr, style: const TextStyle(height: 2.5,color: mainClr)),
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
                        onPressed: () => Get.offNamed(Routes.loginScreen),
                        child: TextUtils(
                          text: 'logIn'.tr,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: mainClr,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
