import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/model/plots.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_income_list_screen.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/expenseTracker.screen/expense_view_model.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/plotHistory.screen/plot_history.dart';
import 'package:agriChikitsa/screens/tab.screens/agPlus.screen/widgets/gradient_button.dart';
import 'package:agriChikitsa/services/auth.dart';
import 'package:agriChikitsa/utils/utils.dart';
import 'package:agriChikitsa/widgets/skeleton/skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExpenseIncomeTracker extends HookWidget {
  const ExpenseIncomeTracker({super.key, required this.selectedPlot});
  final Plots selectedPlot;
  @override
  Widget build(BuildContext context) {
    final useViewModel = useMemoized(() => Provider.of<ExpenseViewModel>(context, listen: false));
    final authService = useMemoized(() => Provider.of<AuthService>(context, listen: false));
    final userId = authService.userInfo["user"]["_id"];
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!selectedPlot.kharchaKamaiRecord) {
          useViewModel.createRecord(
              context, selectedPlot, userId, selectedPlot.id, selectedPlot.cropHistoryId!);
        } else {
          useViewModel.fetchExpenseIncome(context, selectedPlot.id, selectedPlot.cropHistoryId!);
        }
      });
      return null;
    }, []);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.notificationBgColor,
        foregroundColor: AppColor.darkBlackColor,
        automaticallyImplyLeading: true,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalization.of(context).getTranslatedValue("expenseIncomeCalculator").toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: null,
          overflow: TextOverflow.visible,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FieldInfoCard(selectedPlot: selectedPlot),
            CropInfoCard(selectedPlot: selectedPlot),
            ActionButtonsCard(plot: selectedPlot)
          ],
        ),
      ),
    );
  }
}

class FieldInfoCard extends StatelessWidget {
  final Plots selectedPlot;

  const FieldInfoCard({super.key, required this.selectedPlot});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      height: dimension['height']! * 0.21,
      width: dimension['width']!,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl:
                  "https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              fit: BoxFit.fill,
              placeholder: (context, url) => Skeleton(
                height: dimension['height']! * 0.21,
                width: dimension['width']!,
                radius: 12,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedPlot.fieldName,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500, fontSize: 18, color: AppColor.whiteColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalization.of(context).getTranslatedValue("enterSoilType").toString(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: const Color(0xffFFDE41)),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      selectedPlot.soilType,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, fontSize: 13, color: AppColor.whiteColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CropInfoCard extends StatelessWidget {
  final Plots selectedPlot;

  const CropInfoCard({super.key, required this.selectedPlot});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      height: dimension['height']! * 0.21,
      width: dimension['width']!,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: selectedPlot.cropImage ??
                  "https://images.unsplash.com/photo-1593738226658-f3e01177c3f0?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              fit: BoxFit.cover,
              placeholder: (context, url) => Skeleton(
                height: dimension['height']! * 0.21,
                width: dimension['width']!,
                radius: 12,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalization.of(context).locale.toString() == "en"
                      ? selectedPlot.cropName
                      : selectedPlot.cropNameHi,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500, fontSize: 28, color: AppColor.whiteColor),
                ),
                Text(
                  "${AppLocalization.of(context).getTranslatedValue("area").toString()} : ${selectedPlot.area}",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500, fontSize: 18, color: AppColor.whiteColor),
                ),
                Row(
                  children: [
                    Text(
                      AppLocalization.of(context).getTranslatedValue("dateOfPlantation").toString(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: const Color(0xffFFDE41)),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      selectedPlot.sowingDate ??
                          AppLocalization.of(context)
                              .getTranslatedValue("notPlantedYet")
                              .toString(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, fontSize: 12, color: AppColor.whiteColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButtonsCard extends StatelessWidget {
  final Plots plot;

  const ActionButtonsCard({super.key, required this.plot});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlotHistoryScreen(
                    selectedPlot: plot,
                  ),
                ),
              );
            },
            child: GradientButton(
              height: dimension["height"]! * 0.08,
              width: dimension["width"]!,
              title: AppLocalization.of(context).getTranslatedValue("oldCropsBtn").toString(),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExpenseIncomeListScreen(
                    selectedPlot: plot,
                  ),
                ),
              );
            },
            child: GradientButton(
              height: dimension["height"]! * 0.08,
              width: dimension["width"]!,
              title: AppLocalization.of(context).getTranslatedValue("addExpenseBtn").toString(),
            ),
          ),
        ],
      ),
    );
  }
}
