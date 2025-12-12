import 'package:flutter/material.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';

class BigElevatedBtm extends StatelessWidget {
  const BigElevatedBtm(
      {super.key,
      required this.onPressed,
      required this.title,
      this.isCancel = false,
      this.isSmall = false,
      this.isDelete = false,
      this.isLoading = false});
  final void Function()? onPressed;
  final String title;
  final bool isLoading;
  final bool isDelete;
  final bool isSmall;
  final bool isCancel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: isLoading ? AppColors.yellowColor : null,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                    color: isCancel
                        ? AppColors.yellowColor
                        : Colors.transparent,
                    width: 1.3)),
            backgroundColor: isCancel
                ? AppColors.yellowColor
                : isDelete
                    ? AppColors.yellowColor
                    : AppColors.yellowColor),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                title,
                style: isDelete || isSmall
                    ? TextStyles.font20Bold(context).copyWith(
                        color: isCancel
                            ? AppColors.mainColorTheme
                            : Colors.white,
                      )
                    : TextStyles.font22Bold(context).copyWith(
                        color: isCancel
                            ? AppColors.mainColorTheme
                            : Colors.white,
                      ),
              ),
      ),
    );
  }
}