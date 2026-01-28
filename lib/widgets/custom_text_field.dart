import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      enabled: enabled,
      style: PixelTextStyles.body,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: PixelTextStyles.bodyLight,
        hintText: hint,
        hintStyle: PixelTextStyles.bodyLight,
        prefixIcon: prefixIcon != null 
            ? Icon(prefixIcon, size: AppConstants.iconSizeM) 
            : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        
        // PIXEL STYLE BORDERS
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          borderSide: BorderSide(
            color: AppColors.black,
            width: AppConstants.pixelBorderWidthThin,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          borderSide: BorderSide(
            color: AppColors.black,
            width: AppConstants.pixelBorderWidthThin,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppConstants.pixelBorderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          borderSide: BorderSide(
            color: AppColors.danger,
            width: AppConstants.pixelBorderWidthThin,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          borderSide: BorderSide(
            color: AppColors.danger,
            width: AppConstants.pixelBorderWidth,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.pixelCardRadius),
          borderSide: BorderSide(
            color: AppColors.divider,
            width: AppConstants.pixelBorderWidthThin,
          ),
        ),
        
        filled: true,
        fillColor: enabled ? AppColors.white : AppColors.inputBg,
        errorStyle: PixelTextStyles.caption.copyWith(color: AppColors.danger),
      ),
    );
  }
}