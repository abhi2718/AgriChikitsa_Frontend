import 'package:flutter/material.dart';

class KharchaKamaiModel {
  final String id;
  final String userId;
  final String fieldId;
  final String cropHistoryId;

  final List<ExpenseModel> expenditures;
  final TotalExpenditures totalExpenditures;

  final List<IncomeModel> incomeRecords;

  final double totalYield;
  double totalIncome;
  double netProfit;
  final double profitPerUnit;

  final String status;
  final bool isKamaiActive;
  final bool isFinalSubmitted;

  KharchaKamaiModel({
    required this.id,
    required this.userId,
    required this.fieldId,
    required this.cropHistoryId,
    required this.expenditures,
    required this.totalExpenditures,
    required this.incomeRecords,
    required this.totalYield,
    required this.totalIncome,
    required this.netProfit,
    required this.profitPerUnit,
    required this.status,
    required this.isKamaiActive,
    required this.isFinalSubmitted,
  });

  factory KharchaKamaiModel.fromJson(Map<String, dynamic> json) {
    final recordId = json['_id'];

    return KharchaKamaiModel(
      id: recordId,
      userId: json['userId'],
      fieldId: json['feildId'],
      cropHistoryId: json['cropHistoryId'],
      expenditures: (json['expenditures'] as List? ?? [])
          .map((e) => ExpenseModel.fromJson(
                e,
                recordId: recordId,
              ))
          .toList(),
      totalExpenditures: TotalExpenditures.fromJson(json['totalExpenditures'] ?? {}),
      incomeRecords: (json['incomeRecords'] as List? ?? [])
          .map((e) => IncomeModel.fromJson(
                e,
                recordId: recordId,
              ))
          .toList(),
      totalYield: (json['totalYield'] ?? 0).toDouble(),
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      netProfit: (json['netProfit'] ?? 0).toDouble(),
      profitPerUnit: (json['profitPerUnit'] ?? 0).toDouble(),
      status: json['status'] ?? 'active',
      isKamaiActive: json['isKamaiActive'] ?? false,
      isFinalSubmitted: json['isFinalSubmitted'] ?? false,
    );
  }

  KharchaKamaiModel copyWith({
    bool? isFinalSubmitted,
    TotalExpenditures? totalExpenditures,
  }) {
    return KharchaKamaiModel(
      id: id,
      userId: userId,
      fieldId: fieldId,
      cropHistoryId: cropHistoryId,
      expenditures: expenditures,
      totalExpenditures: totalExpenditures ?? this.totalExpenditures,
      incomeRecords: incomeRecords,
      totalYield: totalYield,
      totalIncome: totalIncome,
      netProfit: netProfit,
      profitPerUnit: profitPerUnit,
      status: status,
      isKamaiActive: isKamaiActive,
      isFinalSubmitted: isFinalSubmitted ?? this.isFinalSubmitted,
    );
  }
}

class TotalExpenditures {
  double seeds;
  double machinery;
  double irrigation;
  double electricity;
  double harvest;
  double fertilisers;
  double pesticides;
  double labour;
  double other;
  double grandTotal;

  TotalExpenditures({
    required this.seeds,
    required this.machinery,
    required this.irrigation,
    required this.electricity,
    required this.harvest,
    required this.fertilisers,
    required this.pesticides,
    required this.labour,
    required this.other,
    required this.grandTotal,
  });

  factory TotalExpenditures.fromJson(Map<String, dynamic> json) {
    return TotalExpenditures(
      seeds: (json['seeds'] ?? 0).toDouble(),
      machinery: (json['machinery'] ?? 0).toDouble(),
      irrigation: (json['irrigation'] ?? 0).toDouble(),
      electricity: (json['electricity'] ?? 0).toDouble(),
      harvest: (json['harvest'] ?? 0).toDouble(),
      fertilisers: (json['fertilisers'] ?? 0).toDouble(),
      pesticides: (json['pesticides'] ?? 0).toDouble(),
      labour: (json['labour'] ?? 0).toDouble(),
      other: (json['other'] ?? 0).toDouble(),
      grandTotal: (json['grandTotal'] ?? 0).toDouble(),
    );
  }
}

class ExpenseModel {
  String? id;
  String recordId;
  final String category;
  final String subCategory;
  double? quantity;
  String? unit;
  final double amount;
  final DateTime date;
  final String description;

  ExpenseModel({
    this.id,
    required this.recordId,
    required this.category,
    required this.subCategory,
    required this.amount,
    required this.date,
    required this.description,
    this.quantity,
    this.unit,
  });

  factory ExpenseModel.fromJson(
    Map<String, dynamic> json, {
    required String recordId,
  }) {
    return ExpenseModel(
      id: json['_id'],
      recordId: recordId,
      category: json['category'],
      subCategory: json['subcategory'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      description: json['description'] ?? '',
      quantity: (json['quantity'] ?? 0).toDouble(),
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      "category": category,
      "subcategory": subCategory,
      "amount": amount,
      "date": date.toIso8601String(),
      "description": description,
      "quantity": quantity,
      "unit": unit,
    };
  }
}

class IncomeModel {
  String? id;
  String recordId;
  final double yieldAmount;
  final String yieldUnit;
  final double sellingPrice;
  final String priceUnit;
  final double totalIncome;
  final DateTime saleDate;
  final String notes;

  IncomeModel({
    this.id,
    required this.recordId,
    required this.yieldAmount,
    required this.yieldUnit,
    required this.sellingPrice,
    required this.priceUnit,
    required this.totalIncome,
    required this.saleDate,
    required this.notes,
  });

  factory IncomeModel.fromJson(
    Map<String, dynamic> json, {
    required String recordId,
  }) {
    return IncomeModel(
      id: json['_id'],
      recordId: recordId,
      yieldAmount: (json['yieldAmount'] ?? 0).toDouble(),
      yieldUnit: json['yieldUnit'] ?? 'quintal',
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      priceUnit: json['priceUnit'] ?? 'per quintal',
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      saleDate: DateTime.parse(json['saleDate']),
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      "yieldAmount": yieldAmount,
      "yieldUnit": yieldUnit,
      "sellingPrice": sellingPrice,
      "priceUnit": priceUnit,
      "totalIncome": totalIncome,
      "saleDate": saleDate.toIso8601String(),
      "notes": notes,
    };
  }
}

class ExpenseCategoryData {
  final String key;
  final String englishLabel;
  final String hindiLabel;
  final IconData icon;

  const ExpenseCategoryData({
    required this.key,
    required this.englishLabel,
    required this.hindiLabel,
    required this.icon,
  });
}

class CropProfitModel {
  final String recordId;
  final String cropHistoryId;
  final String cropName;
  final String? cropNameHi;
  final String cropImage;
  final String? cropVariety;
  final String status;
  final double totalIncome;
  final double totalExpenditure;
  final double netProfit;

  CropProfitModel({
    required this.recordId,
    required this.cropHistoryId,
    required this.cropName,
    this.cropNameHi,
    required this.cropImage,
    this.cropVariety,
    required this.status,
    required this.totalIncome,
    required this.totalExpenditure,
    required this.netProfit,
  });

  factory CropProfitModel.fromJson(Map<String, dynamic> json) {
    return CropProfitModel(
      recordId: json['recordId'] ?? '',
      cropHistoryId: json['cropHistoryId'] ?? '',
      cropName: json['cropName'] ?? '',
      cropNameHi: json['cropNameHi'],
      cropImage: json['cropImage'] ?? '',
      cropVariety: json['cropVariety'],
      status: json['status'] ?? '',
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpenditure: (json['totalExpenditure'] ?? 0).toDouble(),
      netProfit: (json['netProfit'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "recordId": recordId,
      "cropHistoryId": cropHistoryId,
      "cropName": cropName,
      "cropNameHi": cropNameHi,
      "cropImage": cropImage,
      "cropVariety": cropVariety,
      "status": status,
      "totalIncome": totalIncome,
      "totalExpenditure": totalExpenditure,
      "netProfit": netProfit,
    };
  }
}

class UnitOption {
  final String key;
  final String en;
  final String hi;

  UnitOption({required this.key, required this.en, required this.hi});
}
