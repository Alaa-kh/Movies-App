import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movies/router/routers.dart';
import 'package:movies/utils/theme.dart';
import 'package:movies/view/widgets/text_utils.dart';

class LogOutScreen extends StatelessWidget {
  const LogOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Get.dialog(
              Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(horizontal: 18),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  builder: (context, v, child) {
                    final scale = v < 0 ? 0.0 : v;
                    final opacity = v.clamp(0.0, 1.0);
                    return Transform.scale(
                      scale: scale,
                      child: Opacity(opacity: opacity, child: child),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A).withValues(alpha: .95),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white.withValues(alpha: .10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .22),
                          blurRadius: 22,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: .10),
                            border: Border.all(color: Colors.white.withValues(alpha: .16)),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'logout'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'logoutConfirm'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: gryClr,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: Get.back,
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.white.withValues(alpha: .22)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  'cancel'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Get.offAllNamed(Routes.authGate);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mainClr,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'logout'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              transitionDuration: const Duration(milliseconds: 220),
              transitionCurve: Curves.easeOut,
            );
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: .14),
                  Colors.white.withValues(alpha: .06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withValues(alpha: .16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .22),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: .12),
                    border: Border.all(color: Colors.white.withValues(alpha: .12)),
                  ),
                  child: const Icon(Icons.logout, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextUtils(
                    text: 'logout'.tr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: .7)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
