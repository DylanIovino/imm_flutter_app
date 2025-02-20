import 'package:flutter/foundation.dart';
import 'package:imm_app/data/models/blood_pressure_record.dart';
import 'package:imm_app/data/models/user.dart';
import 'package:imm_app/data/repositories/firestore_repository.dart';


class BloodPressureRecordDataService {
  final FirestoreRepository _firestoreRepository;

  BloodPressureRecordDataService(this._firestoreRepository);

  Future<BloodPressureRecord?> createBloodPressureRecordFromData(String userId, DateTime time, int systolic, int diastolic) async {
    final record = BloodPressureRecord(timestamp: time, systolic: systolic, diastolic: diastolic);
    return createBloodPressureRecord(userId, record);
  }

  Future<BloodPressureRecord?> createBloodPressureRecord(String userId, BloodPressureRecord record) async {    
    final id = await _firestoreRepository.createSubcollectionDoc(User.collectionName, userId, BloodPressureRecord.collectionName, record.toMap());

    if (id == null) {
      debugPrint('BloodPressureRecordDataService: Failed to create blood pressure record');
      return null;
    }

    return record.copyWith(id: id);
  }

  Future<BloodPressureRecord?> getBloodPressureRecord(String userId, String id) async {
    final recordMap = await _firestoreRepository.readSubcollection(User.collectionName, userId, BloodPressureRecord.collectionName, id);

    if (recordMap == null) {
      debugPrint('BloodPressureRecordDataService: Failed to get blood pressure record');
      return null;
    }

    return BloodPressureRecord.fromDataWithId(recordMap);
  }

  Future<bool> updateBloodPressureRecord(String userId, String recordId, {DateTime? timestamp, int? systolic, int? diastolic}) async {
    final updateMap = BloodPressureRecord.createUpdateMap(timestamp: timestamp, systolic: systolic, diastolic: diastolic);

    final success = await _firestoreRepository.updateSubcollectionDoc(User.collectionName, userId, BloodPressureRecord.collectionName, recordId, updateMap);

    if (!success) {
      debugPrint('BloodPressureRecordDataService: Failed to update blood pressure record');
      return false;
    }

    return true;
  }

  Future<bool> deleteBloodPressureRecord(String userId, String recordId) async {
    final success = await _firestoreRepository.deleteSubcollectionDoc(User.collectionName, userId, BloodPressureRecord.collectionName, recordId);

    if (!success) {
      debugPrint('BloodPressureRecordDataService: Failed to delete blood pressure record');
    }

    return success;
  }
}