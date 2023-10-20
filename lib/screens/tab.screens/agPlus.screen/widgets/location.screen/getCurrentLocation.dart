import 'dart:async';

import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/agPlus_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/getLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../../../utils/utils.dart';

class GetCurrentLocation extends HookWidget {
  const GetCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<AGPlusViewModel>(context, listen: false);
    useEffect(() {
      useViewModel.resetLocation();
      useViewModel.moveToCurrentLocation();
    }, []);
    Future<bool> _onWillPop() async {
      if (useViewModel.getCropListLoader) {
        return false;
      }
      Navigator.pop(context);
      Utils.model(context, const GetLocation());
      return true;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Consumer<AGPlusViewModel>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Stack(
                    children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        initialCameraPosition: provider.intialCameraPosition,
                        onMapCreated: (GoogleMapController controller) {
                          provider.shwowLocationName();
                          provider.controller.complete(controller);
                        },
                        onCameraMove: (CameraPosition cameraPosition) {
                          provider.setMapLocation(cameraPosition);
                        },
                        onCameraIdle: provider.shwowLocationName,
                      ),
                      Center(
                        child: Image.asset(
                          "assets/icons/picker.png",
                          width: 80,
                        ),
                      ),
                      Positioned(
                          bottom: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Card(
                              child: Container(
                                  padding: const EdgeInsets.all(0),
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/icons/picker.png",
                                      width: 25,
                                    ),
                                    title: Text(
                                      provider.location,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    dense: true,
                                  )),
                            ),
                          ))
                    ],
                  ),
                ),
                if (provider.getCropListLoader)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColor.whiteColor),
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            useViewModel.getCropListLoader ? null : useViewModel.getCropList(context);
          },
          child: const Icon(
            Icons.arrow_forward_ios,
            color: AppColor.extraDark,
          ),
        ),
      ),
    );
  }
}
