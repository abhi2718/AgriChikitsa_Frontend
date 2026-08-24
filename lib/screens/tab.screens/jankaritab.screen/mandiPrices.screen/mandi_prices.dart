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
      return null;
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
                                return provider.stateList.isEmpty
                                    ? EmptyDetailsList(
                                        onTap: () {},
                                        title: AppLocalization.of(context)
                                            .getTranslatedValue("signupFormSelectState")
                                            .toString())
                                    : _buildActiveDropdownCard(
                                        context: context,
                                        width: dimension['width']! * 0.90,
                                        title: provider.selectedState.isEmpty
                                            ? AppLocalization.of(context)
                                                .getTranslatedValue("signupFormSelectState")
                                                .toString()
                                            : provider.selectedState,
                                        isSelected: provider.selectedState.isNotEmpty,
                                        onTap: () => _openStatePicker(context, provider),
                                      );
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              Consumer<MandiPricesModel>(builder: (context, provider, child) {
                                return provider.districtList.isEmpty
                                    ? EmptyDetailsList(
                                        onTap: () => Utils.snackbar(
                                            AppLocalization.of(context)
                                                .getTranslatedValue("validateState")
                                                .toString(),
                                            context),
                                        title: AppLocalization.of(context)
                                            .getTranslatedValue("signupFormSelectDistrict")
                                            .toString())
                                    : _buildActiveDropdownCard(
                                        context: context,
                                        width: dimension['width']! * 0.90,
                                        title: provider.selectedDistrict.isEmpty
                                            ? AppLocalization.of(context)
                                                .getTranslatedValue("signupFormSelectDistrict")
                                                .toString()
                                            : provider.selectedDistrict,
                                        isSelected: provider.selectedDistrict.isNotEmpty,
                                        onTap: () => _openDistrictPicker(context, provider),
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
                                    : _buildActiveDropdownCard(
                                        context: context,
                                        width: dimension['width']! * 0.90,
                                        title: provider.selectedMarket.isEmpty
                                            ? AppLocalization.of(context)
                                                .getTranslatedValue("selectMandi")
                                                .toString()
                                            : provider.selectedMarket,
                                        isSelected: provider.selectedMarket.isNotEmpty,
                                        onTap: () => _openMandiPicker(context, provider),
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
                                    : _buildActiveDropdownCard(
                                        context: context,
                                        width: dimension['width']! * 0.90,
                                        title: provider.selectedCommodity.isEmpty
                                            ? AppLocalization.of(context)
                                                .getTranslatedValue("selectCrop")
                                                .toString()
                                            : provider.selectedCommodity,
                                        isSelected: provider.selectedCommodity.isNotEmpty,
                                        onTap: () => _openCropPicker(context, provider),
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

  Widget _buildActiveDropdownCard({
    required BuildContext context,
    required double width,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColor.extraDark,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.extraDark.withOpacity(0.15),
              blurRadius: 6.0,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: BaseText(
                title: title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.black : Colors.grey[700],
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColor.extraDark),
          ],
        ),
      ),
    );
  }

  Future<void> _openStatePicker(BuildContext context, MandiPricesModel provider) async {
    final selected = await SearchableSelectionSheet.show<String>(
      context: context,
      title: AppLocalization.of(context).getTranslatedValue("signupFormSelectState").toString(),
      items: provider.stateList.cast<String>(),
      selectedItem: provider.selectedState.isNotEmpty ? provider.selectedState : null,
      itemAsString: (item) => item,
    );
    if (!context.mounted) return;
    if (selected != null) {
      provider.setSelectedState(selected);
      await provider.fetchDistrict(context);
      if (context.mounted && provider.districtList.isNotEmpty) {
        await _openDistrictPicker(context, provider);
      }
    }
  }

  Future<void> _openDistrictPicker(BuildContext context, MandiPricesModel provider) async {
    final selected = await SearchableSelectionSheet.show<String>(
      context: context,
      title: AppLocalization.of(context).getTranslatedValue("signupFormSelectDistrict").toString(),
      items: provider.districtList.cast<String>(),
      selectedItem: provider.selectedDistrict.isNotEmpty ? provider.selectedDistrict : null,
      itemAsString: (item) => item,
    );
    if (!context.mounted) return;
    if (selected != null) {
      provider.setSelectedDistrict(selected);
      await provider.fetchMarket(context);
      if (context.mounted && provider.marketList.isNotEmpty) {
        await _openMandiPicker(context, provider);
      }
    }
  }

  Future<void> _openMandiPicker(BuildContext context, MandiPricesModel provider) async {
    final selected = await SearchableSelectionSheet.show<String>(
      context: context,
      title: AppLocalization.of(context).getTranslatedValue("selectMandi").toString(),
      items: provider.marketList.cast<String>(),
      selectedItem: provider.selectedMarket.isNotEmpty ? provider.selectedMarket : null,
      itemAsString: (item) => item,
    );
    if (!context.mounted) return;
    if (selected != null) {
      provider.setSelectedMarket(selected);
      await provider.fetchCommodities(context);
      if (context.mounted && provider.cropList.isNotEmpty) {
        await _openCropPicker(context, provider);
      }
    }
  }

  Future<void> _openCropPicker(BuildContext context, MandiPricesModel provider) async {
    final selected = await SearchableSelectionSheet.show<String>(
      context: context,
      title: AppLocalization.of(context).getTranslatedValue("selectCrop").toString(),
      items: provider.cropList.cast<String>(),
      selectedItem: provider.selectedCommodity.isNotEmpty ? provider.selectedCommodity : null,
      itemAsString: (item) => item,
    );
    if (selected != null) {
      provider.setSelectedCommodity(selected);
    }
  }
}
