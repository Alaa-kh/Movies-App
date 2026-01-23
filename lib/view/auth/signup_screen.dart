import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/view/widgets/auth/auth_text_form_filed.dart';
import 'package:movies/view/widgets/text_utils.dart';

import '../../logic/controller/auth_controller.dart';
import '../../router/routers.dart';
import '../../utils/strings.dart';
import '../../utils/theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController controller = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
              child: Padding(
                padding: const EdgeInsets.only(left: 18, top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TextUtils(
                      text: signUp,
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 10),
                    TextUtils(
                      text: createAccount,
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
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
                      hintText: enterName,
                      controller: nameController,
                      obscureText: false,
                      validator: (value) {
                        final v = value ?? '';
                        if (v.length <= 2 ||
                            !RegExp(validationName).hasMatch(v)) {
                          return 'Enter valid Name';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.person_2_outlined,
                          color: Colors.grey),
                    ),
      
                    const SizedBox(height: 20),
      
                    AuthTextFormField(
                      hintText: enterEmail,
                      controller: emailController,
                      obscureText: false,
                      validator: (value) {
                        final v = value ?? '';
                        if (!RegExp(validationEmail).hasMatch(v)) {
                          return 'Invalid Email';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.email_outlined,
                          color: Colors.grey),
                    ),
      
                    const SizedBox(height: 20),
                    GetBuilder<AuthController>(
                      builder: (c) => AuthTextFormField(
                        hintText: password,
                        controller: passwordController,
                        obscureText: !c.isVisibility,
                        validator: (value) {
                          final v = value ?? '';
                          if (v.length < 6) {
                            return 'Password should be longer or equal to 6 characters';
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: Colors.grey),
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
      
                    const SizedBox(height: 30),
      
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
                            controller.signUpUsingFirebase(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );
                          }
                        },
                        child: const TextUtils(
                          text: signUp,
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
                        onPressed: () => Get.offNamed(Routes.loginScreen),
                        child: const TextUtils(
                          text: logIn,
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
