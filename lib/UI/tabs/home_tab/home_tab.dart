

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/providers/smart_home_provider.dart';
import 'package:smart_home/utils/app_assets.dart';
import 'package:smart_home/utils/app_colors.dart';
import 'package:smart_home/utils/app_styles.dart';
import 'custom_data_card.dart';
import 'custom_switch_control.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final smartHomeProvider = context.watch<SmartHomeProvider>();
   // bool autoMode = true;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        backgroundColor: AppColors.whiteColor,
        leading: Icon(
          Icons.settings_input_antenna,
          color: AppColors.primaryLight,
        ),
        title: Text('Home Status', style: AppStyles.bold18black),
      ),
      body: smartHomeProvider.isLoading
          ? const Center(child: CircularProgressIndicator()) ///handles the loading
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.02,
                horizontal: width * 0.07,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: height * 0.03,
                    crossAxisSpacing: width * 0.05,
                    childAspectRatio: 1.2,
                    children: [
                      CustomDataCard(
                        imageIcon: AppAssets.tempIcon,
                        text: 'Temperature',
                        statusText:
                            '${smartHomeProvider.temperature.toStringAsFixed(1)} C',
                      ),
                      CustomDataCard(
                        imageIcon: AppAssets.humidityIcon,
                        text: 'Humidity',
                        statusText:
                            '${smartHomeProvider.humidity.toStringAsFixed(1)} %',
                      ),
                      CustomDataCard(
                        isGasCard: true,
                        imageIcon: AppAssets.gasIcon,
                        text: 'Gas Status',
                        statusText: smartHomeProvider.gasSafe
                            ? 'Safe'
                            : 'Gas Leak!',
                        gasSafe: smartHomeProvider.gasSafe,
                      ),
                      CustomDataCard(
                        imageIcon: AppAssets.doorIcon,
                        text: 'Door State',
                        statusText: smartHomeProvider.doorState,
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.02),
                  Container(
                   padding: EdgeInsets.symmetric(
                     vertical: height*0.01,
                   ),
                    width: width*0.6,

                    decoration: BoxDecoration(
                        color: Color(0XFFF3FFF8),
                      borderRadius: BorderRadius.circular(10),
                      border: BoxBorder.all(
                        color: Colors.blue,
                        width: 1.5
                      )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppAssets.robotIcon,width: width*0.1,),
                        SizedBox(width: width*0.02,),
                        Text('Auto Mode',style: AppStyles.bold14black),
                        SizedBox(width: width*0.02,),
                        Switch(
                            value: smartHomeProvider.autoMode,
                            onChanged: smartHomeProvider.setAutoMode,

                          thumbColor: WidgetStateProperty.resolveWith((states) {
                            return AppColors.whiteColor;
                          }),

                          trackColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.primaryLight; // ON
                            }
                            return AppColors.offWhiteColor; // OFF
                          }),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  Row(
                    spacing: width * 0.02,
                    children: [
                      Image.asset(AppAssets.controlIcon, width: 20),
                      Expanded(
                        child: Text(
                          'Quick Controls',
                          style: AppStyles.bold18black,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),

                  ///Out side lights
                  CustomSwitchControl(
                    title: 'Out side lights',
                    icon: AppAssets.bulb,
                    animateLightIcon: true,
                    value: smartHomeProvider.outsideLightsOn,
                    onChanged: smartHomeProvider.setOutsideLights,
                    disabled: smartHomeProvider.autoMode,
                  ),

                  ///room fan
                  CustomSwitchControl(
                    title: 'Room Fan',
                    icon: AppAssets.fanImage,
                    value: smartHomeProvider.roomFanOn,
                    onChanged: smartHomeProvider.setRoomFan,
                    disabled: smartHomeProvider.autoMode,
                  ),

                  ///Kitchen Hood
                  CustomSwitchControl(
                    title: 'Kitchen Hood',
                    icon: AppAssets.fanImage,
                    value: smartHomeProvider.kitchenHoodOn,
                    onChanged: smartHomeProvider.setKitchenHood,
                    disabled: smartHomeProvider.autoMode,
                  ),

                  ///Main Door
                  CustomSwitchControl(
                    title: 'Main Door',
                    icon: AppAssets.doorImage,
                    isDoorLock: true,
                    value: smartHomeProvider.mainDoorLocked,
                    onChanged: smartHomeProvider.setMainDoorLocked,
                  ),
                ],
              ),
            ),
    );
  }
}
