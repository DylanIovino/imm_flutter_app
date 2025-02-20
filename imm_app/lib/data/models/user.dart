// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:imm_app/data/models/data_with_id.dart';



class User {
  static String get collectionName => 'users';
  static String get subCollectionName => 'bloodPressureRecords';


  final String? id;
  final String email;
  final String? name;
  // height and weight for BMI calculation
  final double? heightInches;
  final double? weightLbs;

  User({
    this.id,
    required this.email,
    this.name,
    this.heightInches,
    this.weightLbs,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    double? heightInches,
    double? weightLbs,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      heightInches: heightInches ?? this.heightInches,
      weightLbs: weightLbs ?? this.weightLbs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'height': heightInches,
      'weight_lbs': weightLbs,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as String : null,
      email: map['email'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      heightInches: map['height'] != null ? map['height'] as double : null,
      weightLbs: map['weight_lbs'] != null ? map['weight_lbs'] as double : null,
    );
  }

  factory User.fromDataWithId(DataWithId dataWithId) {
    return User.fromMap(dataWithId.toMap());
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, height: $heightInches, weight_lbs: $weightLbs)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.email == email &&
      other.name == name &&
      other.heightInches == heightInches &&
      other.weightLbs == weightLbs;
  }

  @override
  int get hashCode {
    return (id?.hashCode ?? 0) ^
      email.hashCode ^
      (name?.hashCode ?? 0) ^
      (heightInches?.hashCode ?? 0) ^
      (weightLbs?.hashCode ?? 0);
  }
}
