// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';

class CustomSettingsListTile extends StatelessWidget {
  const CustomSettingsListTile({
    super.key,
    required this.title,
    required this.ontap,
    required this.icon,
  });
  final String title;
  final IconData icon;
  final void Function() ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: SizedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.yellowColor, width: 2),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.yellowColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyles.font18Medium(
                  context,
                ).copyWith(color: AppColors.yellowColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
