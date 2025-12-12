import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/generated/l10n.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.controller,
    required this.isPassword,
    required this.obscureText,
    required this.isInLogin,
    this.isEmail = false,
    this.isPhone = false,
    this.maxLines = 1,
    this.whiteColor = false,
  });

  final String hintText;
  final int maxLines;
  final bool whiteColor;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final bool isPassword, isInLogin, isEmail, isPhone;
  bool obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          // ignore: deprecated_member_use
          selectionColor: AppColors.whiteColor.withOpacity(0.5),
          selectionHandleColor: AppColors.whiteColor,
          cursorColor: AppColors.whiteColor,
        ),
      ),
      child: TextFormField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${widget.hintText}${S.current.is_required}';
          }
          if (widget.isPassword) {
            if (value.length < 8 && widget.isInLogin) {
              return S.current.at_least;
            }
          }
          if (widget.isPhone &&
              !RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(value)) {
            return 'Invalid phone';
          }
          return null;
        },
        obscureText: widget.obscureText,
        style: TextStyles.font20Medium(
          context,
        ).copyWith(color: AppColors.whiteColor),
        onChanged: widget.onChanged,
        keyboardType: widget.isEmail
            ? TextInputType.emailAddress
            : widget.isPhone
                ? TextInputType.phone
                : TextInputType.text,
        decoration: InputDecoration(
          fillColor: widget.whiteColor ? Colors.white : null,
          filled: widget.whiteColor,
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  icon: Icon(
                    widget.obscureText ? IconlyLight.show : IconlyLight.hide,
                    color: AppColors.whiteColor,
                    size: 26,
                  ),
                )
              : null,
          hintText: widget.hintText,
          hintStyle: TextStyles.font20Medium(
            context,
          ).copyWith(color: AppColors.whiteColor),
          errorStyle: TextStyles.font14Medium(
            context,
          ).copyWith(color: Colors.red),
          border: outLineBorder,
          enabledBorder: outLineBorder,
          focusedBorder: outLineBorder,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.yellowColor),
          ),
        ),
      ),
    );
  }

  var outLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Color(0xffD0D0D0)),
  );
}