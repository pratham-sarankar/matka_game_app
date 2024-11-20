enum UserRole {
  admin,
  user,
}

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.user:
        return 'User';
    }
  }

  static UserRole fromCode(int? code) {
    switch (code) {
      case 0:
        return UserRole.admin;
      case 1:
        return UserRole.user;
      default:
        return UserRole.user;
    }
  }
}
