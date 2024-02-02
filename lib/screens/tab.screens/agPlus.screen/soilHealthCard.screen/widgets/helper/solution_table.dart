import 'package:flutter/material.dart';

import '../../../../../../utils/utils.dart';

class SolutionTable extends StatelessWidget {
  const SolutionTable({super.key});

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Container(
      margin: EdgeInsetsDirectional.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [BoxShadow(offset: Offset(3, 4), color: Colors.grey)],
      ),
      child: Column(
        children: [
          Container(
            height: dimension['height']! * (0.6 - 0.53),
            color: Color(0xffF5F5F5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Elements",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "Quantity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          TableTile(title: "Nano Urea For Foiler Spraying", quantity: "1200 mi/acre"),
          TableTile(title: "Nano Urea For Foiler Spraying", quantity: "1200 mi/acre"),
          TableTile(title: "UREA", quantity: "130 kg/hect"),
          TableTile(title: "DAP", quantity: "34.9 mg/kg"),
          TableTile(title: "MOP", quantity: "0.33 milli siman"),
          TableTile(title: "ZnSO4.7H20", quantity: "0 kg/hect"),
          TableTile(title: "Gypsum", quantity: "34.9 mg/kg"),
          TableTile(title: "Borax", quantity: "34.9 mg/kg"),
        ],
      ),
    );
  }
}

class TableTile extends StatelessWidget {
  const TableTile({
    super.key,
    required this.title,
    required this.quantity,
  });
  final String quantity;
  final String title;

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: dimension["height"]! * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          Text(quantity),
        ],
      ),
    );
  }
}
