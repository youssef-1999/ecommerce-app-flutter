import 'package:ecommerce_app/core/resources/color_manager.dart';
import 'package:ecommerce_app/core/routes_manager/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppDialogs {
  static void successDialog(String? message) {
    _showAppDialog(
      icon: Icons.check_circle_outline,
      lottieAsset: 'assets/lotti/success.json',
      message: message ?? 'Success',
      color: Colors.green,
    );
  }

  static void errorDialog(String? message) {
    _showAppDialog(
      icon: Icons.error_outline,
      lottieAsset: 'assets/lotti/error.json',
      message: message ?? 'Something went wrong',
      color: ColorManager.error,
    );
  }

  // named differently from Flutter's showDialog to avoid shadowing it
  static void _showAppDialog({
    required IconData icon,
    required String message,
    required Color color,
    required String lottieAsset,

  }) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieBuilder.asset(lottieAsset),
            Icon(icon, color: color, size: 64),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
