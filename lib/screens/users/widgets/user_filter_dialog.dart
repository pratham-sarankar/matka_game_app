import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/utils/user_role.dart';

class UserFilterDialog extends StatefulWidget {
  final UserRole? initialRole;
  final bool? initialIsActive;
  final Function({UserRole? role, bool? isActive}) onApply;
  final VoidCallback onReset;

  const UserFilterDialog({
    super.key,
    this.initialRole,
    this.initialIsActive,
    required this.onApply,
    required this.onReset,
  });

  @override
  State<UserFilterDialog> createState() => _UserFilterDialogState();
}

class _UserFilterDialogState extends State<UserFilterDialog> {
  late UserRole? _selectedRole;
  late bool? _selectedIsActive;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
    _selectedIsActive = widget.initialIsActive;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Users',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.onReset();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Reset',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFcd1b65),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Role',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedRole == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedRole = null;
                    });
                  },
                ),
                ...UserRole.values.map(
                  (role) => FilterChip(
                    label: Text(role.name),
                    selected: _selectedRole == role,
                    onSelected: (selected) {
                      setState(() {
                        _selectedRole = selected ? role : null;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Status',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedIsActive == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedIsActive = null;
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Active'),
                  selected: _selectedIsActive == true,
                  onSelected: (selected) {
                    setState(() {
                      _selectedIsActive = selected ? true : null;
                    });
                  },
                ),
                FilterChip(
                  label: const Text('Blocked'),
                  selected: _selectedIsActive == false,
                  onSelected: (selected) {
                    setState(() {
                      _selectedIsActive = selected ? false : null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    widget.onApply(
                      role: _selectedRole,
                      isActive: _selectedIsActive,
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFcd1b65),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
