import 'package:flutter/material.dart';

enum UserRole {
  admin,
  user,
}

extension UserRoleExtension on UserRole {
  bool get isAdmin {
    return this == UserRole.admin;
  }

  String get name {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.user:
        return 'User';
    }
  }

  int get code {
    switch (this) {
      case UserRole.admin:
        return 0;
      case UserRole.user:
        return 1;
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

  static List<DropdownMenuItem> get dropDownItems {
    return UserRole.values
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e.name),
            ))
        .toList();
  }
}
