class KharchaKamaiModel {
  final String id;
  final String userId;
  final String fieldId;
  final String cropHistoryId;

  final List<ExpenseModel> expenditures;
  final TotalExpenditures totalExpenditures;

  final List<IncomeModel> incomeRecords;

  final double totalYield;
  final double totalIncome;
  final double netProfit;
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
  }) {
    return KharchaKamaiModel(
      id: id,
      userId: userId,
      fieldId: fieldId,
      cropHistoryId: cropHistoryId,
      expenditures: expenditures,
      totalExpenditures: totalExpenditures,
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
  final double seedNursery;
  final double fertilisers;
  final double pesticides;
  final double tractorMachinery;
  final double labour;
  final double other;
  final double grandTotal;

  TotalExpenditures({
    required this.seedNursery,
    required this.fertilisers,
    required this.pesticides,
    required this.tractorMachinery,
    required this.labour,
    required this.other,
    required this.grandTotal,
  });

  factory TotalExpenditures.fromJson(Map<String, dynamic> json) {
    return TotalExpenditures(
      seedNursery: (json['seedNursery'] ?? 0).toDouble(),
      fertilisers: (json['fertilisers'] ?? 0).toDouble(),
      pesticides: (json['pesticides'] ?? 0).toDouble(),
      tractorMachinery: (json['tractorMachinery'] ?? 0).toDouble(),
      labour: (json['labour'] ?? 0).toDouble(),
      other: (json['other'] ?? 0).toDouble(),
      grandTotal: (json['grandTotal'] ?? 0).toDouble(),
    );
  }
}

class ExpenseModel {
  final String? id;
  final String recordId;
  final String category;
  final String subCategory;
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
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      "category": category,
      "subcategory": subCategory,
      "amount": amount,
      "date": date.toIso8601String(),
      "description": description,
    };
  }
}

class IncomeModel {
  final String? id;
  final String recordId;
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
