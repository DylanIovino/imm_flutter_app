enum UserType { user, unauthenticated }

extension UserTypeExtension on UserType {
  String get name {
    switch (this) {
      case UserType.user:
        return 'Parent';
      case UserType.unauthenticated:
        return 'Unauthenticated';
    }
  }
}