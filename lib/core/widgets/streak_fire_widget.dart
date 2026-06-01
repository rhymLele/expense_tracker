import 'dart:math';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class StreakFireWidget extends StatefulWidget {
  final int streak;
  final Color? color;
  final double size;

  const StreakFireWidget({
    super.key,
    required this.streak,
    this.color,
    this.size = 20,
  });

  @override
  State<StreakFireWidget> createState() => _StreakFireWidgetState();
}

class _StreakFireWidgetState extends State<StreakFireWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fireColor = widget.color ??
        (widget.streak > 0
            ? const Color(0xFFFF6B2B)
            : AppColors.textHint);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _scale,
          builder: (_, child) => Transform.scale(
            scale: widget.streak > 0 ? _scale.value : 1.0,
            child: child,
          ),
          child: Icon(
            Icons.local_fire_department_rounded,
            size: widget.size,
            color: fireColor,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          '${widget.streak}',
          style: AppTextStyles.labelMedium.copyWith(
            color: fireColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class ProgressRingWidget extends StatelessWidget {
  final int completed;
  final int total;
  final double size;
  final double strokeWidth;
  final Color? trackColor;
  final Color? progressColor;

  const ProgressRingWidget({
    super.key,
    required this.completed,
    required this.total,
    this.size = 56,
    this.strokeWidth = 5,
    this.trackColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final value = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: value,
              trackColor: trackColor ?? AppColors.background.withValues(alpha: 0.25),
              progressColor: progressColor ?? AppColors.background,
              strokeWidth: strokeWidth,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$completed',
                style: TextStyle(
                  fontSize: size * 0.28,
                  fontWeight: FontWeight.w700,
                  color: progressColor ?? AppColors.background,
                  height: 1,
                ),
              ),
              Text(
                '/$total',
                style: TextStyle(
                  fontSize: size * 0.19,
                  color: (progressColor ?? AppColors.background).withValues(alpha: 0.7),
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  const _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
