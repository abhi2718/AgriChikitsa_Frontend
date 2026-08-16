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
import '../../../../widgets/searchable_selection_sheet.dart';
import '../../../../widgets/text.widgets/text.dart';

class MandiPricesScreen extends HookWidget {
  const MandiPricesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    final useViewModel = useMemoized(() => Provider.of<MandiPricesModel>(context, listen: false));
    useEffect(() {
      useViewModel.reinitalize();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        useViewModel.fetchStates(context);
      });
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
                                    : InkWell(
                                        onTap: () async {
                                          final selected =
                                              await SearchableSelectionSheet.show<String>(
                                            context: context,
                                            title: AppLocalization.of(context)
                                                .getTranslatedValue("signupFormSelectState")
                                                .toString(),
                                            items: provider.stateList.cast<String>(),
                                            selectedItem: provider.selectedState.isNotEmpty
                                                ? provider.selectedState
                                                : null,
                                            itemAsString: (item) => item,
                                          );
                                          if (selected != null) {
                                            provider.setSelectedState(selected);
                                            provider.fetchDistrict(context);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 14),
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: BaseText(
                                                  title: provider.selectedState.isEmpty
                                                      ? AppLocalization.of(context)
                                                          .getTranslatedValue("signupFormSelectState")
                                                          .toString()
                                                      : provider.selectedState,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: provider.selectedState.isEmpty
                                                        ? Colors.grey[600]
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                            ],
                                          ),
                                        ),
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
                                    : InkWell(
                                        onTap: () async {
                                          final selected =
                                              await SearchableSelectionSheet.show<String>(
                                            context: context,
                                            title: AppLocalization.of(context)
                                                .getTranslatedValue("signupFormSelectDistrict")
                                                .toString(),
                                            items: provider.districtList.cast<String>(),
                                            selectedItem: provider.selectedDistrict.isNotEmpty
                                                ? provider.selectedDistrict
                                                : null,
                                            itemAsString: (item) => item,
                                          );
                                          if (selected != null) {
                                            provider.setSelectedDistrict(selected);
                                            provider.fetchMarket(context);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 14),
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: BaseText(
                                                  title: provider.selectedDistrict.isEmpty
                                                      ? AppLocalization.of(context)
                                                          .getTranslatedValue("signupFormSelectDistrict")
                                                          .toString()
                                                      : provider.selectedDistrict,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: provider.selectedDistrict.isEmpty
                                                        ? Colors.grey[600]
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                            ],
                                          ),
                                        ),
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
                                    : InkWell(
                                        onTap: () async {
                                          final selected =
                                              await SearchableSelectionSheet.show<String>(
                                            context: context,
                                            title: AppLocalization.of(context)
                                                .getTranslatedValue("selectMandi")
                                                .toString(),
                                            items: provider.marketList.cast<String>(),
                                            selectedItem: provider.selectedMarket.isNotEmpty
                                                ? provider.selectedMarket
                                                : null,
                                            itemAsString: (item) => item,
                                          );
                                          if (selected != null) {
                                            provider.setSelectedMarket(selected);
                                            provider.fetchCommodities(context);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 14),
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: BaseText(
                                                  title: provider.selectedMarket.isEmpty
                                                      ? AppLocalization.of(context)
                                                          .getTranslatedValue("selectMandi")
                                                          .toString()
                                                      : provider.selectedMarket,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: provider.selectedMarket.isEmpty
                                                        ? Colors.grey[600]
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                            ],
                                          ),
                                        ),
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
                                    : InkWell(
                                        onTap: () async {
                                          final selected =
                                              await SearchableSelectionSheet.show<String>(
                                            context: context,
                                            title: AppLocalization.of(context)
                                                .getTranslatedValue("selectCrop")
                                                .toString(),
                                            items: provider.cropList.cast<String>(),
                                            selectedItem: provider.selectedCommodity.isNotEmpty
                                                ? provider.selectedCommodity
                                                : null,
                                            itemAsString: (item) => item,
                                          );
                                          if (selected != null) {
                                            provider.setSelectedCommodity(selected);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 14),
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: BaseText(
                                                  title: provider.selectedCommodity.isEmpty
                                                      ? AppLocalization.of(context)
                                                          .getTranslatedValue("selectCrop")
                                                          .toString()
                                                      : provider.selectedCommodity,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: provider.selectedCommodity.isEmpty
                                                        ? Colors.grey[600]
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.arrow_drop_down, color: Colors.grey),
                                            ],
                                          ),
                                        ),
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
                                            if (context.mounted) {
                                              Utils.model(
                                                  context, PricesScreen(pricesData: value['data']));
                                            }
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
