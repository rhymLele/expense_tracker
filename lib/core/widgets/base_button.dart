import 'package:flutter/material.dart';

import '../constants/colors.dart';

class BaseButton extends StatefulWidget {
  final Function()? onPressed;
  final Widget? child;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? elevation;
  final double? padding;

  const BaseButton({
    super.key,
    this.onPressed,
    this.child,
    this.backgroundColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.elevation,
  });

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    reverseDuration: const Duration(milliseconds: 500),
  );

  late final Animation<double> _scale = Tween<double>(
    begin: 1.0,
    end: 0.93,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
      reverseCurve: Curves.elasticOut,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    _controller.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor ?? AppColors.primary,
            minimumSize: Size(
              widget.width ?? MediaQuery.of(context).size.width / 2,
              widget.height ?? 50,
            ),
            maximumSize: Size(
              widget.width ?? MediaQuery.of(context).size.width / 2,
              widget.height ?? 50,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
            ),
            elevation: widget.elevation,
            padding: widget.padding == null
                ? EdgeInsets.zero
                : EdgeInsets.all(widget.padding ?? 0),
          ),
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }
}
