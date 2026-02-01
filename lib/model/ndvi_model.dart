import 'package:flutter/material.dart';

class NDVIResponse {
  final String messageHi;
  final String messageEn;
  final String advisoryHi;
  final String advisoryEn;
  final String audioEn;
  final String audioHi;
  final List<NDVIHistory> ndviHistory;
  final int totalRecords;
  final int statusCode;
  final Color statusColor;
  final String currentStagingEn;
  final String currentStagingHi;
  final String daysEn;
  final String daysHi;

  NDVIResponse({
    required this.messageHi,
    required this.messageEn,
    required this.advisoryEn,
    required this.advisoryHi,
    required this.audioEn,
    required this.audioHi,
    required this.ndviHistory,
    required this.totalRecords,
    required this.statusCode,
    required this.currentStagingEn,
    required this.currentStagingHi,
    required this.daysEn,
    required this.daysHi,
  }) : statusColor = _getStatusColor(statusCode);

  factory NDVIResponse.fromJson(Map<String, dynamic>? json, int? statusCode) {
    if (json == null || statusCode == null) {
      return NDVIResponse(
          messageHi: 'कोई डेटा मौजूद नहीं।',
          messageEn: 'No data available',
          advisoryEn: 'कोई डेटा मौजूद नहीं।',
          advisoryHi: 'No data available',
          audioEn: "",
          audioHi: "",
          ndviHistory: [],
          totalRecords: 0,
          statusCode: 0,
          currentStagingEn: "Not Available",
          currentStagingHi: "उपलब्ध नहीं",
          daysEn: "",
          daysHi: "");
    }
    return NDVIResponse(
      messageHi: json['message_hi'] ?? 'कोई डेटा मौजूद नहीं।',
      messageEn: json['message_en'] ?? 'No message available',
      advisoryEn: json['advisory_en'] ?? 'No message available',
      advisoryHi: json['advisory_hi'] ?? 'कोई डेटा मौजूद नहीं।',
      audioEn: json['audio_en'] ?? '',
      audioHi: json['audio_hi'] ?? '',
      ndviHistory:
          (json['ndvi_history'] as List<dynamic>?)?.map((e) => NDVIHistory.fromJson(e)).toList() ??
              [],
      totalRecords:
          json['total_ndvi_records'] != null ? (json['total_ndvi_records'] as num).toInt() : 0,
      statusCode: statusCode,
      currentStagingEn: json["currentCropStage_en"] ?? "N/A",
      currentStagingHi: json["currentCropStage_hi"] ?? "N/A",
      daysEn: json["days_en"] ?? "",
      daysHi: json["days_hi"] ?? "",
    );
  }

  static Color _getStatusColor(int code) {
    switch (code) {
      case 200:
        return Colors.green;
      case 400:
        return Colors.orange;
      case 404:
        return Colors.yellow;
      case 422:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class NDVIHistory {
  final DateTime date;
  final double ndviValue;
  final String id;

  NDVIHistory({
    required this.date,
    required this.ndviValue,
    required this.id,
  });

  factory NDVIHistory.fromJson(Map<String, dynamic>? json) {
    if (json == null ||
        !json.containsKey('date') ||
        !json.containsKey('ndvi_value') ||
        !json.containsKey('_id')) {
      return NDVIHistory(
        date: DateTime.fromMillisecondsSinceEpoch(0),
        ndviValue: 0.0,
        id: 'Unknown',
      );
    }
    return NDVIHistory(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      ndviValue: (json['ndvi_value'] as num?)?.toDouble() ?? 0.0,
      id: json['_id'] ?? 'Unknown',
    );
  }
}
