import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.primary;
    final txtColor = textColor ?? Colors.white;

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacingL,
            horizontal: AppConstants.spacingXXL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
            side: BorderSide(
              color: AppColors.black,
              width: AppConstants.pixelBorderWidth,
            ),
          ),
          side: BorderSide(
            color: bgColor,
            width: AppConstants.pixelBorderWidth,
          ),
          backgroundColor: Colors.white,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(bgColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: bgColor, size: AppConstants.iconSizeM),
                    const SizedBox(width: AppConstants.spacingS),
                  ],
                  Text(
                    text,
                    style: PixelTextStyles.button.copyWith(color: bgColor),
                  ),
                ],
              ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.3),
            offset: Offset(
              AppConstants.pixelShadowOffset,
              AppConstants.pixelShadowOffset,
            ),
            blurRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(
            vertical: AppConstants.spacingL,
            horizontal: AppConstants.spacingXXL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.pixelButtonRadius),
            side: BorderSide(
              color: AppColors.black,
              width: AppConstants.pixelBorderWidth,
            ),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(txtColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: txtColor, size: AppConstants.iconSizeM),
                    const SizedBox(width: AppConstants.spacingS),
                  ],
                  Text(
                    text,
                    style: PixelTextStyles.button.copyWith(color: txtColor),
                  ),
                ],
              ),
      ),
    );
  }
}