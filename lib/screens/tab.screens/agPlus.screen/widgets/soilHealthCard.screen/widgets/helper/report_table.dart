import 'package:flutter/material.dart';

import '../../../../../../../utils/utils.dart';

class ReportTable extends StatelessWidget {
  const ReportTable({super.key});

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
                Text(
                  "Impact",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          TableTile(
            title: "Organic Carbon",
            quantity: "0.244%",
            impact: false,
          ),
          TableTile(
            title: "Available Nitrogen",
            quantity: "130kg/hect",
            impact: false,
          ),
          TableTile(
            title: "Available Sulphur",
            quantity: "34.9 mg/kg",
            impact: true,
          ),
          TableTile(
            title: "Electrical\nConductivity",
            quantity: "0.33 mili siman",
            impact: true,
          ),
          TableTile(
            title: "Available Phosphorus",
            quantity: "0 kg/hect",
            impact: false,
          ),
          TableTile(
            title: "Available Copper",
            quantity: "34.9 mg/kg",
            impact: true,
          ),
          TableTile(
            title: "Available Iron",
            quantity: "34.9 mg/kg",
            impact: true,
          ),
          TableTile(
            title: "Available Iron",
            quantity: "34.9 mg/kg",
            impact: true,
          ),
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
    required this.impact,
  });
  final String quantity;
  final String title;
  final bool impact;

  @override
  Widget build(BuildContext context) {
    final dimension = Utils.getDimensions(context, true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          Text(quantity),
          Container(
            height: dimension['height']! * 0.1,
            width: dimension["width"]! * 0.25,
            color: impact ? Colors.green : Colors.red,
            child: Center(
              child: Text(impact ? "Sufficient" : "Less"),
            ),
          )
        ],
      ),
    );
  }
}
