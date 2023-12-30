import 'package:agriChikitsa/l10n/app_localizations.dart';
import 'package:agriChikitsa/res/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../agristick_view_model.dart';

class DatePicker extends StatelessWidget {
  DatePicker({super.key});
  @override
  Widget build(BuildContext context) {
    final useViewModel = Provider.of<AgristickViewModel>(context, listen: false);
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Consumer<AgristickViewModel>(
            builder: (context, provider, child) {
              return Text(
                "${useViewModel.selectedDate.toLocal()}".split(' ')[0],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.notificationBgColor),
            onPressed: () {
              useViewModel.selectDate(context);
            },
            child: Text(
              AppLocalization.of(context).getTranslatedValue("selectDate").toString(),
              style: const TextStyle(color: AppColor.darkBlackColor),
            ),
          ),
        ],
      ),
    );
  }
}
