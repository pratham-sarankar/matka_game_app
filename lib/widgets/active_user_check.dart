import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/widgets/inactive_user_dialog.dart';

class ActiveUserCheck extends StatefulWidget {
  final Widget child;

  const ActiveUserCheck({
    super.key,
    required this.child,
  });

  @override
  State<ActiveUserCheck> createState() => _ActiveUserCheckState();
}

class _ActiveUserCheckState extends State<ActiveUserCheck> {
  final _userService = Get.find<UserService>();
  bool _isChecking = true;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    final isActive = await _userService.isUserActive();
    if (mounted) {
      setState(() {
        _isActive = isActive;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isActive) {
      return const Scaffold(
        body: Center(
          child: InactiveUserDialog(),
        ),
      );
    }

    return widget.child;
  }
}
