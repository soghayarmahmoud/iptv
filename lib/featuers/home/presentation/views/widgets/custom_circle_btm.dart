// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CircleButton({super.key, 
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(1000),
          child: Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.secondaryColorTheme, AppColors.mainColorTheme],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.whiteColor.withOpacity(0.08), width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 18, offset: Offset(0, 10)),
              ],
            ),
            child: Icon(icon, size: 54, color: AppColors.whiteColor),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          label,
          style: TextStyles.font14Medium(context).copyWith(color: AppColors.yellowColor),
        ),
      ],
    );
  }
}