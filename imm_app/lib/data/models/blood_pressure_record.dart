// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:imm_app/data/models/data_with_id.dart';
import 'package:imm_app/util/time_utils.dart';


class BloodPressureRecord {
  static String get collectionName => 'bloodPressureRecords';

  final String? id;
  final DateTime timestamp;
  final int systolic;
  final int diastolic;
  BloodPressureRecord({
    this.id,
    required this.timestamp,
    required this.systolic,
    required this.diastolic,
  });

  BloodPressureRecord copyWith({
    String? id,
    DateTime? tiemstamp,
    int? systolic,
    int? diastolic,
  }) {
    return BloodPressureRecord(
      id: id ?? this.id,
      timestamp: tiemstamp ?? this.timestamp,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'timestamp': timestamp,
      'systolic': systolic,
      'diastolic': diastolic,
    };
  }

  factory BloodPressureRecord.fromMap(Map<String, dynamic> map) {
    return BloodPressureRecord(
      id: map['id'] != null ? map['id'] as String : null,
      timestamp: map['timestamp'] != null ? convertToDateTime(map['timestamp']) : DateTime.fromMillisecondsSinceEpoch(0),
      systolic: map['systolic'] as int,
      diastolic: map['diastolic'] as int,
    );
  }

  factory BloodPressureRecord.fromDataWithId(DataWithId dataWithId) {
    return BloodPressureRecord.fromMap(dataWithId.toMap());
  }

  static Map<String, dynamic> createUpdateMap({
    DateTime? timestamp,
    int? systolic,
    int? diastolic,
  }) {
    final Map<String, dynamic> updateMap = {};
    if (timestamp != null) {
      updateMap['timestamp'] = timestamp;
    }
    if (systolic != null) {
      updateMap['systolic'] = systolic;
    }
    if (diastolic != null) {
      updateMap['diastolic'] = diastolic;
    }
    return updateMap;
  }
  
  String toJson() => json.encode(toMap());

  factory BloodPressureRecord.fromJson(String source) => BloodPressureRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BloodPressureRecord(id: $id, timestamp: $timestamp, systolic: $systolic, diastolic: $diastolic)';

  @override
  bool operator ==(covariant BloodPressureRecord other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.timestamp == timestamp &&
      other.systolic == systolic &&
      other.diastolic == diastolic;
  }

  @override
  int get hashCode => (id?.hashCode ?? 0) ^ timestamp.hashCode ^ systolic.hashCode ^ diastolic.hashCode;
}
