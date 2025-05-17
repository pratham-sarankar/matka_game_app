import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:matka_game_app/models/notice.dart';
import 'package:matka_game_app/repositories/notice_repository.dart';
import 'package:intl/intl.dart';

class UserNoticeBoardScreen extends StatefulWidget {
  const UserNoticeBoardScreen({super.key});

  @override
  State<UserNoticeBoardScreen> createState() => _UserNoticeBoardScreenState();
}

class _UserNoticeBoardScreenState extends State<UserNoticeBoardScreen> {
  final _noticeRepository = NoticeRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Notice Board",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FirestoreListView<Notice>(
        query: _noticeRepository.getNoticesQuery(),
        padding: const EdgeInsets.all(16),
        emptyBuilder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.doc_text_search,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "No notices found",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: GoogleFonts.poppins(
              color: Colors.red,
            ),
          ),
        ),
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        itemBuilder: (context, snapshot) {
          final notice = snapshot.data();
          return _buildNoticeCard(notice);
        },
      ),
    );
  }

  Widget _buildNoticeCard(Notice notice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffcb1964),
              Color(0xffab1865),
              Color(0xff770e66),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      CupertinoIcons.bell_fill,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Notice",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(notice.createdAt),
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                notice.content,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y • h:mm a').format(date);
  }
}
