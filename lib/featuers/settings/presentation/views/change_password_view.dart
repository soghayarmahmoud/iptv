import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' as g;
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/widgets/snack_bars/custom_snack_bar.dart';
import 'package:iptv/featuers/settings/presentation/manager/change_password/change_password_cubit.dart';
import 'package:iptv/featuers/settings/presentation/views/widgets/change_password_view_body.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if(state is ChangePasswordSuccess){
          CustomSnackBar().showCustomSnackBar(context: context, message: state.message, type: AnimatedSnackBarType.success);
          g.Get.back();
        }
        if(state is ChangePasswordError){
          CustomSnackBar().showCustomSnackBar(context: context, message: state.error, type: AnimatedSnackBarType.error);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(inAsyncCall: state is ChangePasswordLoading, progressIndicator: CircularProgressIndicator(color: AppColors.yellowColor,),  child: const Scaffold(body: ChangePasswordViewBody()));
      },
    );
  }
}
