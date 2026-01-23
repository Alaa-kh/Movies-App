import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter/material.dart';

extension MotionX on Widget {
  Widget fadeUp({double dy = .10, Duration? d, Duration? delay}) => animate()
      .fadeIn(duration: d ?? 350.ms, delay: delay ?? 0.ms)
      .slideY(
        begin: dy,
        end: 0,
        duration: d ?? 350.ms,
        delay: delay ?? 0.ms,
        curve: Curves.easeOutCubic,
      );

  Widget slideX({double dx = .10, Duration? d, Duration? delay}) => animate()
      .fadeIn(duration: d ?? 220.ms, delay: delay ?? 0.ms)
      .slideX(
        begin: dx,
        end: 0,
        duration: d ?? 300.ms,
        delay: delay ?? 0.ms,
        curve: Curves.easeOutCubic,
      );

  Widget scaleIn({double s = .9, Duration? d, Duration? delay}) => animate()
      .fadeIn(duration: d ?? 220.ms, delay: delay ?? 0.ms)
      .scale(
        begin: Offset(s, s),
        end: const Offset(1, 1),
        duration: d ?? 240.ms,
        delay: delay ?? 0.ms,
        curve: Curves.easeOutBack,
      );

  Widget ripple({Duration? d}) =>
      animate(onPlay: (c) => c.repeat(reverse: true))
          .fadeIn(duration: 180.ms)
          .scale(
            begin: const Offset(.98, .98),
            end: const Offset(1.02, 1.02),
            duration: d ?? 900.ms,
          );

  Widget fadeDown({double dy = -.10, Duration? d, Duration? delay}) => animate()
      .fadeIn(duration: d ?? 350.ms, delay: delay ?? 0.ms)
      .slideY(
        begin: dy,
        end: 0,
        duration: d ?? 350.ms,
        delay: delay ?? 0.ms,
        curve: Curves.easeOutCubic,
      );

  Widget pop({Duration? d, Duration? delay}) => animate()
      .fadeIn(duration: d ?? 220.ms, delay: delay ?? 0.ms)
      .scale(
        begin: const Offset(.92, .92),
        end: const Offset(1, 1),
        duration: d ?? 280.ms,
        delay: delay ?? 0.ms,
        curve: Curves.easeOutBack,
      );

  Widget shimmer({Duration? d}) => animate(
    onPlay: (c) => c.repeat(),
  ).fadeIn(duration: 200.ms).shimmer(duration: d ?? 1400.ms);

  Widget stagger(int index, {int baseMs = 60, int startMs = 0}) =>
      fadeUp(delay: (startMs + index * baseMs).ms);
}
