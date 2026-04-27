import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool showAppBar;
  final bool safeArea;
  final EdgeInsetsGeometry? padding;

  const BaseScaffold({
    super.key,
    required this.body,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.showAppBar = true,
    this.safeArea = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = padding != null ? Padding(padding: padding!, child: body) : body;
    if (safeArea) content = SafeArea(child: content);

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      appBar: showAppBar
          ? AppBar(
              title: titleWidget ?? (title != null ? Text(title!) : null),
              leading: leading,
              actions: actions,
            )
          : null,
      body: content,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
