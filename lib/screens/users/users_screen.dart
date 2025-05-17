import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/repositories/user_repository.dart';
import 'package:matka_game_app/screens/users/user_form_screen.dart';
import 'package:matka_game_app/screens/users/widgets/user_filter_dialog.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/utils/user_role.dart';
import 'package:matka_game_app/screens/users/widgets/user_card.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen(this.userRepository, {super.key});

  final UserRepository userRepository;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final searchController = TextEditingController();
  UserRole? selectedRole;
  bool? isActive;
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: const Color(0xFFcd1b65),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: FirestoreListView<UserData>(
                query: widget.userRepository.query(
                  role: selectedRole,
                  isActive: isActive,
                ),
                itemBuilder: (context, snapshot) {
                  final user = snapshot.data();
                  final fullName = user.fullName.toLowerCase();
                  final email = user.email.toLowerCase();

                  if (searchQuery.isNotEmpty &&
                      !fullName.contains(searchQuery) &&
                      !email.contains(searchQuery)) {
                    return const SizedBox.shrink();
                  }

                  return UserCard(
                    user: user,
                    onTap: () {
                      Get.to(() =>
                          UserFormScreen(widget.userRepository, user: user));
                    },
                  );
                },
                loadingBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text('Error: ${error.toString()}'),
                ),
                emptyBuilder: (context) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/not-found.png",
                          height: 100,
                          opacity: const AlwaysStoppedAnimation(0.8),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No Users Found',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => UserFilterDialog(
        initialRole: selectedRole,
        initialIsActive: isActive,
        onReset: () {
          setState(() {
            selectedRole = null;
            isActive = null;
          });
        },
        onApply: ({
          UserRole? role,
          bool? isActive,
        }) {
          setState(() {
            selectedRole = role;
            this.isActive = isActive;
          });
        },
      ),
    );
  }
}
