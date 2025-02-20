
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DataWithId {
  final String id;
  final Map<String, dynamic> data;

  DataWithId({
    required this.id,
    required this.data,
  });

  DataWithId copyWith({
    String? id,
    Map<String, dynamic>? data,
  }) {
    return DataWithId(
      id: id ?? this.id,
      data: data ?? this.data,
    );
  }

  factory DataWithId.fromFirestore(DocumentSnapshot doc) {
    return DataWithId(
      id: doc.id,
      data: doc.data() as Map<String, dynamic>, // Ensure this cast works for your use case
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      ...data,
    };
  }

  @override
  String toString() => 'DataWithId(id: $id, data: $data)';

  @override
  bool operator ==(covariant DataWithId other) {
    if (identical(this, other)) return true;

    return id == other.id && mapEquals(data, other.data);
  }
  
  @override
  int get hashCode => id.hashCode ^ data.hashCode;
  

}