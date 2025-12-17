// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart' as g;
import 'package:iptv/core/services/cache_helper.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_images.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/core/utils/g_functions.dart';
import 'package:iptv/core/widgets/btms/custom_btm_field.dart';
import 'package:iptv/core/widgets/fields/custom_text_field.dart';
import 'package:iptv/core/widgets/snack_bars/custom_snack_bar.dart';

import 'package:iptv/featuers/home/presentation/views/home_view.dart';
import 'package:iptv/featuers/start/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:iptv/generated/l10n.dart';

class StartViewBody extends StatefulWidget {
  const StartViewBody({super.key});

  @override
  State<StartViewBody> createState() => _StartViewBodyState();
}

class _StartViewBodyState extends State<StartViewBody> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction;
  String? username, password;
  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    final Color leftBg = const Color(0xFF000000);
    final Color rightBg = AppColors.mainColorTheme;
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            color: leftBg,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            Assets.imagesLogo,
                            width: 96,
                            height: 96,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Bee Player',
                            style: TextStyles.font18ExtraBold(
                              context,
                            ).copyWith(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        S.current.anew_experience,
                        style: TextStyles.font22Bold(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.current.enjoy,
                        style: TextStyles.font18Medium(
                          context,
                        ).copyWith(color: Colors.white70, height: 1.4),
                      ),
                      const SizedBox(height: 28),

                      Text(
                        S.current.thanks,
                        style: TextStyles.font18ExtraBold(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            color: rightBg,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: autovalidateMode,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          S.current.Continue_Using_the_App,
                          style: TextStyles.font22ExtraBold(
                            context,
                          ).copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          onChanged: (value) {
                            username = value;
                          },
                          hintText: S.current.username,
                          isPassword: false,
                          obscureText: false,
                          isInLogin: false,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          onChanged: (value) {
                            password = value;
                          },
                          hintText: S.current.password,
                          isPassword: true,
                          obscureText: true,
                          isInLogin: false,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                              activeColor: AppColors.yellowColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Text(
                              S.current.remember_me,
                              style: TextStyles.font18Medium(
                                context,
                              ).copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              g.Get.off(
                                () => const HomeView(),
                                transition: g.Transition.fade,
                                duration: const Duration(milliseconds: 400),
                              );
                            }
                            if (state is AuthError) {
                              CustomSnackBar().showCustomSnackBar(
                                context: context,
                                message: state.error,
                                type: SnackBarType.error,
                              );
                            }
                          },
                          builder: (context, state) {
                            return BigElevatedBtm(
                              isLoading: state is AuthLoading,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (rememberMe) {
                                    await CacheHelper.instance.saveData(
                                      key: 'rememberMeFlag',
                                      value: rememberMe,
                                    );
                                    await cleanAllStorage();
                                    context.read<AuthCubit>().login(
                                      username!,
                                      password!,
                                    );
                                  } else {
                                    await cleanAllStorage();
                                    context.read<AuthCubit>().login(
                                      username!,
                                      password!,
                                    );
                                  }
                                } else {
                                  setState(() {
                                    autovalidateMode = AutovalidateMode.always;
                                  });
                                }
                              },
                              title: S.current.continueBtm,
                            );
                          },
                        ),

                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
