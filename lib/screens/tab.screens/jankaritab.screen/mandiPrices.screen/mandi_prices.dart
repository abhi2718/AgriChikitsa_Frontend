import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/mandiPrices.screen/mandi_prices_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/mandiPrices.screen/widgets/empty_details_list.dart';
import 'package:agriChikitsa/screens/tab.screens/jankaritab.screen/mandiPrices.screen/widgets/prices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/text.widgets/text.dart';

class MandiPricesScreen extends HookWidget {
  const MandiPricesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<MandiPricesModel>(context, listen: false));
    useEffect(() {
      useViewModel.reinitalize();
      useViewModel.fetchStates(context);
    }, []);

    return Scaffold(
      backgroundColor: AppColor.notificationBgColor,
      appBar: AppBar(
        backgroundColor: AppColor.whiteColor,
        foregroundColor: AppColor.darkBlackColor,
        centerTitle: true,
        leading:
            InkWell(onTap: () => useViewModel.goBack(context), child: const Icon(Icons.arrow_back)),
        title: BaseText(
          title: AppLocalization.of(context).getTranslatedValue("checkPrices").toString(),
          style: GoogleFonts.inter(
              color: AppColor.darkBlackColor, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        elevation: 0.0,
      ),
      body: Consumer<MandiPricesModel>(
        builder: (context, provider, child) {
          return useViewModel.stateLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.extraDark,
                  ),
                )
              : Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BaseText(
                                  title: AppLocalization.of(context)
                                      .getTranslatedValue("mandiFillDetails")
                                      .toString(),
                                  style:
                                      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500)),
                              const SizedBox(
                                height: 20,
                              ),
                              Consumer<MandiPricesModel>(builder: (context, provider, child) {
                                return useViewModel.stateList.isEmpty
                                    ? EmptyDetailsList(
                                        onTap: () {},
                                        title: AppLocalization.of(context)
                                            .getTranslatedValue("signupFormSelectState")
                                            .toString())
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        width: dimension['width']! * 0.90,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[400]!,
                                                  blurRadius: 1.0,
                                                  spreadRadius: 1,
                                                  offset: const Offset(0, 3))
                                            ],
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20)),
                                        child: DropdownButton(
                                            underline: Container(),
                                            isExpanded: true,
                                            hint: BaseText(
                                              title: AppLocalization.of(context)
                                                  .getTranslatedValue("signupFormSelectState")
                                                  .toString(),
                                              style: const TextStyle(),
                                            ),
                                            value: provider.selectedState.isEmpty
                                                ? null
                                                : useViewModel.selectedState,
                                            alignment: AlignmentDirectional.centerStart,
                                            items: provider.stateList
                                                .map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: BaseText(
                                                  title: value,
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                                onTap: () {
                                                  provider.setSelectedState(value);
                                                  provider.fetchDistrict(context);
                                                },
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              provider.setSelectedState(value!);
                                              useViewModel.fetchDistrict(context);
                                            }),
                                      );
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              Consumer<MandiPricesModel>(builder: (context, provider, child) {
                                return useViewModel.districtList.isEmpty
                                    ? EmptyDetailsList(
                                        onTap: () => Utils.snackbar(
                                            AppLocalization.of(context)
                                                .getTranslatedValue("validateState")
                                                .toString(),
                                            context),
                                        title: AppLocalization.of(context)
                                            .getTranslatedValue("signupFormSelectDistrict")
                                            .toString())
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        width: dimension['width']! * 0.90,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[400]!,
                                                  blurRadius: 1.0,
                                                  spreadRadius: 1,
                                                  offset: const Offset(0, 3))
                                            ],
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20)),
                                        child: DropdownButton(
                                            hint: BaseText(
                                              title: AppLocalization.of(context)
                                                  .getTranslatedValue("signupFormSelectDistrict")
                                                  .toString(),
                                              style: const TextStyle(),
                                            ),
                                            value: provider.selectedDistrict.isEmpty
                                                ? null
                                                : useViewModel.selectedDistrict,
                                            alignment: AlignmentDirectional.centerStart,
                                            isExpanded: true,
                                            underline: Container(),
                                            items: provider.districtList
                                                .map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: BaseText(
                                                  title: value,
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                                onTap: () {
                                                  provider.setSelectedDistrict(value);
                                                  provider.fetchMarket(context);
                                                },
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              provider.setSelectedDistrict(value!);
                                              provider.fetchMarket(context);
                                            }),
                                      );
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              Consumer<MandiPricesModel>(builder: (context, provider, child) {
                                return provider.marketList.isEmpty
                                    ? EmptyDetailsList(
                                        onTap: () => Utils.snackbar(
                                            AppLocalization.of(context)
                                                .getTranslatedValue("validateDistrict")
                                                .toString(),
                                            context),
                                        title: AppLocalization.of(context)
                                            .getTranslatedValue("selectMandi")
                                            .toString())
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        width: dimension['width']! * 0.90,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[400]!,
                                                  blurRadius: 1.0,
                                                  spreadRadius: 1,
                                                  offset: const Offset(0, 3))
                                            ],
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20)),
                                        child: DropdownButton(
                                            alignment: AlignmentDirectional.centerStart,
                                            isExpanded: true,
                                            underline: Container(),
                                            hint: BaseText(
                                              title: AppLocalization.of(context)
                                                  .getTranslatedValue("selectMandi")
                                                  .toString(),
                                              style: const TextStyle(),
                                            ),
                                            value: provider.selectedMarket.isEmpty
                                                ? null
                                                : useViewModel.selectedMarket,
                                            items: provider.marketList
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
                                              provider.setSelectedMarket(value!);
                                              provider.fetchCommodities(context);
                                            }),
                                      );
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              Consumer<MandiPricesModel>(builder: (context, provider, child) {
                                return provider.cropList.isEmpty
                                    ? EmptyDetailsList(
                                        onTap: () => Utils.snackbar(
                                            AppLocalization.of(context)
                                                .getTranslatedValue("validateMandi")
                                                .toString(),
                                            context),
                                        title: AppLocalization.of(context)
                                            .getTranslatedValue("selectCrop")
                                            .toString())
                                    : Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        width: dimension['width']! * 0.90,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[400]!,
                                                  blurRadius: 1.0,
                                                  spreadRadius: 1,
                                                  offset: const Offset(0, 3))
                                            ],
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20)),
                                        child: DropdownButton(
                                            hint: BaseText(
                                              title: AppLocalization.of(context)
                                                  .getTranslatedValue("selectCrop")
                                                  .toString(),
                                              style: const TextStyle(),
                                            ),
                                            value: provider.selectedCommodity.isEmpty
                                                ? null
                                                : useViewModel.selectedCommodity,
                                            alignment: AlignmentDirectional.centerStart,
                                            underline: Container(),
                                            isExpanded: true,
                                            items: provider.cropList
                                                .map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: BaseText(
                                                  title: value,
                                                  style: const TextStyle(fontSize: 14),
                                                ),
                                                onTap: () {
                                                  provider.setSelectedCommodity(value);
                                                },
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              provider.setSelectedCommodity(value!);
                                            }),
                                      );
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: SizedBox(
                                  width: dimension['width']! * 0.5,
                                  height: dimension['height']! * 0.07,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (useViewModel.selectedState.isNotEmpty &&
                                            useViewModel.selectedDistrict.isNotEmpty &&
                                            useViewModel.selectedMarket.isNotEmpty &&
                                            useViewModel.selectedCommodity.isNotEmpty) {
                                          useViewModel.fetchPrices(context).then((value) {
                                            Utils.model(
                                                context, PricesScreen(pricesData: value['data']));
                                          });
                                        } else {
                                          Utils.flushBarErrorMessage(
                                              AppLocalization.of(context)
                                                  .getTranslatedValue("alert")
                                                  .toString(),
                                              AppLocalization.of(context)
                                                  .getTranslatedValue("fillAllDetails")
                                                  .toString(),
                                              context);
                                        }
                                      },
                                      child: provider.priceLoader
                                          ? const CircularProgressIndicator(
                                              color: AppColor.whiteColor,
                                            )
                                          : BaseText(
                                              title: AppLocalization.of(context)
                                                  .getTranslatedValue("knowPrice")
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 16, color: AppColor.extraDark))),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // if (provider.loader)
                    if (provider.loader)
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
    );
  }
}
