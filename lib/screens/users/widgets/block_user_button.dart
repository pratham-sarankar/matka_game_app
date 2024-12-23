import 'package:flutter/material.dart';
import 'package:matka_game_app/repositories/user_repository.dart';
import 'package:matka_game_app/services/user_service.dart';

class BlockUserButton extends StatefulWidget {
  const BlockUserButton(
    this.user, {
    super.key,
    required this.repository,
  });

  final UserData user;
  final UserRepository repository;

  @override
  State<BlockUserButton> createState() => _BlockUserButtonState();
}

class _BlockUserButtonState extends State<BlockUserButton> {
  bool _loading = false;
  late bool isBlocked;

  @override
  void initState() {
    isBlocked = widget.user.isBlocked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          setState(() {
            _loading = true;
          });
          if (isBlocked) {
            await widget.repository.unblockUser(widget.user);
          } else {
            await widget.repository.blockUser(widget.user);
          }
          setState(() {
            isBlocked = !isBlocked;
          });
        } finally {
          setState(() {
            _loading = false;
          });
        }
      },
      child: Text(
        _loading
            ? loadingText
            : isBlocked
                ? "Unblock"
                : "Block" " User",
      ),
    );
  }

  String get loadingText {
    if (widget.user.isBlocked) {
      return "Unblocking...";
    } else {
      return "Blocking...";
    }
  }
}
