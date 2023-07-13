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
                          hint: Text("Select State"),
                          value: provider.selectedState.isEmpty
                              ? null
                              : useViewModel.selectedState,
                          alignment: AlignmentDirectional.center,
                          items: provider.stateList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 14),
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
              const ExpansionTile(
                initiallyExpanded: false,
                title: Text("Choose District"),
                collapsedBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                children: [
                  ListTile(
                    title: Text("Aya Nagar"),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Choose District",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.darkColor, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {},
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                onSubmitted: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onEditingComplete: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Choose Mandi/District",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.darkColor, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {},
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                onSubmitted: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onEditingComplete: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Select Crop",
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColor.darkColor, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {},
                onTapOutside: (_) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                onSubmitted: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onEditingComplete: () {},
              ),
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
