import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import 'app_text.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            AppSpacing.gapH16,
            const AppText.titleMedium(
              'Oops! Something went wrong.',
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapH8,
            AppText.bodyMedium(
              errorMessage,
              color: AppColors.error,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.gapH24,
              AppButton(
                text: 'Retry',
                onPressed: onRetry!,
                width: 120,
              ),
            ],
          ],
        ),
      ),
    );
  }
}