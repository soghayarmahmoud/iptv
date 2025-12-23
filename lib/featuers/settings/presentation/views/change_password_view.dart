import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/widgets/snack_bars/custom_snack_bar.dart';
import 'package:iptv/featuers/settings/presentation/manager/change_password/change_password_cubit.dart';
import 'package:iptv/featuers/settings/presentation/views/widgets/change_password_view_body.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          CustomSnackBar().showCustomSnackBar(
            context: context,
            message: state.message,
            type: SnackBarType.success,
          );
          g.Get.back();
        }
        if (state is ChangePasswordError) {
          CustomSnackBar().showCustomSnackBar(
            context: context,
            message: state.error,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            const Scaffold(body: ChangePasswordViewBody()),
            if (state is ChangePasswordLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.yellowColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
