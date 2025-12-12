import 'package:flutter/material.dart';
import 'package:iptv/core/services/device_info_service.dart';
import 'package:iptv/core/services/secure_storage.dart';
import 'package:iptv/core/utils/app_colors.dart';
import 'package:iptv/core/utils/app_styles.dart';
import 'package:iptv/featuers/settings/presentation/views/widgets/custom_settings_list_tile.dart';
import 'package:iptv/generated/l10n.dart';

class PersonalInformationViewBody extends StatefulWidget {
  const PersonalInformationViewBody({super.key});

  @override
  State<PersonalInformationViewBody> createState() => _PersonalInformationViewBodyState();
}

class _PersonalInformationViewBodyState extends State<PersonalInformationViewBody> {
  String _macAddress = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    final deviceId = await DeviceInfoService.getDeviceId();
    final formattedId = DeviceInfoService.formatAsMAC(deviceId);
    setState(() {
      _macAddress = formattedId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondaryColorTheme, AppColors.mainColorTheme],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: FutureBuilder<String?>(
          future: getCustomId(),
          builder: (context, snapshot) {
            return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(S.current.Personal_information, style: TextStyles.font22ExtraBold(context).copyWith(color: AppColors.whiteColor),),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomSettingsListTile(title: '${S.current.user} : ${snapshot.data}', ontap: (){
                
              },icon: Icons.person_2,),
              SizedBox(height: 16,),
              CustomSettingsListTile(title: '${S.current.mac_address} : $_macAddress', ontap: (){
                
              },icon: Icons.info,),
             
            ],
          ),
          );
          },
        ),
      ),
    );
  }
}