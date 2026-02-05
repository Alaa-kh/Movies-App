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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              Colors.white.withValues(alpha: .14),
              Colors.white.withValues(alpha: .06),
            ]
          : [
              scheme.primary.withValues(alpha: .10),
              scheme.surface,
            ],
    );

    final cardBorderColor = isDark
        ? Colors.white.withValues(alpha: .16)
        : scheme.outlineVariant.withValues(alpha: .80);

    final cardShadowColor = Colors.black.withValues(alpha: isDark ? .22 : .10);

    final cardTextColor = isDark ? Colors.white : scheme.onSurface;
    final cardIconBg = isDark
        ? Colors.white.withValues(alpha: .12)
        : scheme.primaryContainer.withValues(alpha: .80);
    final cardIconColor = isDark ? Colors.white : scheme.onPrimaryContainer;
    final chevronColor =
        isDark ? Colors.white.withValues(alpha: .70) : scheme.onSurfaceVariant;

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
                      color: isDark
                          ? const Color(0xFF2A2A2A).withValues(alpha: .95)
                          : scheme.surface.withValues(alpha: .98),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: .10)
                            : scheme.outlineVariant.withValues(alpha: .60),
                      ),
                   
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.white.withValues(alpha: .10)
                                : scheme.primaryContainer
                                    .withValues(alpha: .85),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: .16)
                                  : scheme.outlineVariant
                                      .withValues(alpha: .60),
                            ),
                          ),
                          child: Icon(
                            Icons.logout_rounded,
                            color: isDark
                                ? Colors.white
                                : scheme.onPrimaryContainer,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'logout'.tr,
                          style: TextStyle(
                            color: isDark ? Colors.white : scheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'logoutConfirm'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDark ? gryClr : scheme.onSurfaceVariant,
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
                                  side: BorderSide(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: .22)
                                        : scheme.outlineVariant
                                            .withValues(alpha: .80),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text(
                                  'cancel'.tr,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : scheme.onSurface,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
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
              gradient: cardGradient,
              border: Border.all(color: cardBorderColor),
              boxShadow: [
                BoxShadow(
                  color: cardShadowColor,
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
                    color: cardIconBg,
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: .12)
                          : scheme.outlineVariant.withValues(alpha: .60),
                    ),
                  ),
                  child: Icon(Icons.logout, color: cardIconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextUtils(
                    text: 'logout'.tr,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cardTextColor,
                  ),
                ),
                Icon(Icons.chevron_right, color: chevronColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
