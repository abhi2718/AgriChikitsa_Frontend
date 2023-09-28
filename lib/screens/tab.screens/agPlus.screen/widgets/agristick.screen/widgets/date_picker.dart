import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../agristick_view_model.dart';

class DatePicker extends StatelessWidget {
  DatePicker({super.key});
  @override
  Widget build(BuildContext context) {
    final useViewModel =
        Provider.of<AgristickViewModel>(context, listen: false);
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Consumer<AgristickViewModel>(
            builder: (context, provider, child) {
              return Text(
                "${useViewModel.selectedDate.toLocal()}".split(' ')[0],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              );
            },
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () {
              useViewModel.selectDate(context);
            },
            child: Text('Select Date'),
          ),
        ],
      ),
    );
  }
}