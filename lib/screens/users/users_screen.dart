import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/repositories/user_repository.dart';
import 'package:matka_game_app/screens/users/user_form_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen(this.userRepository, {super.key});

  final UserRepository userRepository;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      body: StreamBuilder(
        stream: widget.userRepository.streamUsers(),
        builder: (context, snapshot) {
          final users = snapshot.data!;
          final filteredUsers = users.where((user) {
            final fullName = user.fullName.toLowerCase();
            final email = user.email.toLowerCase();
            final search = searchController.text.toLowerCase();
            return fullName.contains(search) || email.contains(search);
          }).toList();
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: CupertinoSearchTextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        title: Text(user.fullName.isNotEmpty
                            ? user.fullName
                            : "Username"),
                        subtitle: user.email.isEmpty ? null : Text(user.email),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade700,
                          child: user.fullName.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : Text(
                                  user.fullName[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                        onTap: () {
                          Get.to(UserFormScreen(Get.find(), user: user));
                        },
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                        thickness: 1,
                      );
                    },
                    itemCount: filteredUsers.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
