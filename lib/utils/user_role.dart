import 'package:flutter/material.dart';

enum UserType {
  admin,
  user,
}

extension UserTypeExtension on UserType {
  bool get isAdmin {
    return this == UserType.admin;
  }

  String get name {
    switch (this) {
      case UserType.admin:
        return 'Admin';
      case UserType.user:
        return 'User';
    }
  }

  int get code {
    switch (this) {
      case UserType.admin:
        return 0;
      case UserType.user:
        return 1;
    }
  }

  static UserType fromCode(int? code) {
    switch (code) {
      case 0:
        return UserType.admin;
      case 1:
        return UserType.user;
      default:
        return UserType.user;
    }
  }

  static List<DropdownMenuItem> get dropDownItems{
    return UserType.values.map((e) => DropdownMenuItem(
      value: e,
      child: Text(e.name),
    )).toList();
}
}
