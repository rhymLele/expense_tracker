import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';

class BaseTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? maxLength;
  final FocusNode? focusNode;
  final AutovalidateMode autovalidateMode;

  const BaseTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  State<BaseTextField> createState() => _BaseTextFieldState();
}

class _BaseTextFieldState extends State<BaseTextField> {
  FocusNode? _internalNode;
  FocusNode get _node => widget.focusNode ?? (_internalNode ??= FocusNode());

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _node.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _node.hasFocus);
  }

  @override
  void dispose() {
    _node.removeListener(_onFocusChange);
    _internalNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _node,
      autovalidateMode: widget.autovalidateMode,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      validator: widget.validator,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,

        // Unfocused: label hiện ở giữa field (màu xám, trông như hint)
        // Focused: label float lên trên border (đậm, đen) + hintText hiện bên dưới
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelStyle: const TextStyle(
          color: AppColors.textHint,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: TextStyle(
          color: _isFocused ? AppColors.textPrimary : AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),

        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingLg,
          vertical: AppSizes.paddingMd,
        ),

        // Border đậm đen khi focus
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: AppColors.divider.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
