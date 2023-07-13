import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/hometab.screen/checkPrices.screen/checkPricesViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';

class CheckPricesScreen extends HookWidget {
  const CheckPricesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(
        () => Provider.of<CheckPricesModel>(context, listen: false));
    useEffect(() {
      useViewModel.reinitalize();
    }, []);
    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        centerTitle: true,
        leading: InkWell(
            onTap: () => useViewModel.goBack(context),
            child: const Icon(Icons.arrow_back)),
        title: const BaseText(
          // title: AppLocalizations.of(context)!.createPosthi,
          title: "Check Prices",
          style: TextStyle(
              color: AppColor.darkBlackColor,
              fontSize: 20,
              fontWeight: FontWeight.w500),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BaseText(
                  title: "Enter the following details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 20,
              ),
              Consumer<CheckPricesModel>(builder: (context, provider, child) {
                return Container(
                  width: dimension['width']! * 0.90,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[400]!,
                            blurRadius: 1.0,
                            spreadRadius: 1,
                            offset: Offset(0, 3))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButton(
                          hint: const BaseText(
                            title: "Select State",
                            style: TextStyle(),
                          ),
                          value: provider.selectedState.isEmpty
                              ? null
                              : useViewModel.selectedState,
                          alignment: AlignmentDirectional.center,
                          items: provider.stateList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: BaseText(
                                title: value,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            provider.setSelectedState(value!);
                          }),
                    ),
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              Consumer<CheckPricesModel>(builder: (context, provider, child) {
                return Container(
                  width: dimension['width']! * 0.90,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[400]!,
                            blurRadius: 1.0,
                            spreadRadius: 1,
                            offset: Offset(0, 3))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButton(
                          hint: const BaseText(
                            title: "Choose District",
                            style: TextStyle(),
                          ),
                          value: provider.selectedDistrict.isEmpty
                              ? null
                              : useViewModel.selectedDistrict,
                          alignment: AlignmentDirectional.center,
                          items: provider.districtList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: BaseText(
                                title: value,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            provider.setSelectedDistrict(value!);
                          }),
                    ),
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              Consumer<CheckPricesModel>(builder: (context, provider, child) {
                return Container(
                  width: dimension['width']! * 0.90,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[400]!,
                            blurRadius: 1.0,
                            spreadRadius: 1,
                            offset: Offset(0, 3))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButton(
                          hint: const BaseText(
                            title: "Choose Mandi/District",
                            style: TextStyle(),
                          ),
                          value: provider.selectedMandi.isEmpty
                              ? null
                              : useViewModel.selectedMandi,
                          alignment: AlignmentDirectional.center,
                          items: provider.mandiList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: BaseText(
                                title: value,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            provider.setSelectedMandi(value!);
                          }),
                    ),
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              Consumer<CheckPricesModel>(builder: (context, provider, child) {
                return Container(
                  width: dimension['width']! * 0.90,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[400]!,
                            blurRadius: 1.0,
                            spreadRadius: 1,
                            offset: Offset(0, 3))
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: DropdownButton(
                          hint: const BaseText(
                            title: "Select Crop",
                            style: TextStyle(),
                          ),
                          value: provider.selectedCrop.isEmpty
                              ? null
                              : useViewModel.selectedCrop,
                          alignment: AlignmentDirectional.center,
                          items: provider.cropList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: BaseText(
                                title: value,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            provider.setSelectedCrop(value!);
                          }),
                    ),
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: dimension['width']! * 0.35,
                  height: dimension['height']! * 0.07,
                  child: ElevatedButton(
                      onPressed: () {
                        useViewModel.fetchPrices(context);
                        useViewModel.goToPricesScreen(context);
                      },
                      child: const BaseText(
                          title: "Know Prices",
                          style: TextStyle(fontSize: 14))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
