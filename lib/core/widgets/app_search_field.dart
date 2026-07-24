import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_shadow.dart';
import '../../app/theme/app_text_style.dart';
import '../constants/app_strings.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? hintText;
  final VoidCallback? onClear;

  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.mediumRadius,
        boxShadow: AppShadow.softCardShadow,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyle.bodyLarge.copyWith(color: AppColors.textPrimary),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: hintText ?? AppStrings.searchPlaceholder,
          hintStyle: AppTextStyle.bodyLarge,
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: const Icon(
              Icons.clear,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: onClear,
          )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.mediumRadius,
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 14.0,
          ),
        ),
      ),
    );
  }
}