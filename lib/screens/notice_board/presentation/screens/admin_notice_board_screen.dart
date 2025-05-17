import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:matka_game_app/models/notice.dart';
import 'package:matka_game_app/repositories/notice_repository.dart';
import 'package:matka_game_app/screens/notice_board/presentation/screens/add_edit_notice_screen.dart';
import 'package:intl/intl.dart';

class AdminNoticeBoardScreen extends StatefulWidget {
  const AdminNoticeBoardScreen({super.key});

  @override
  State<AdminNoticeBoardScreen> createState() => _AdminNoticeBoardScreenState();
}

class _AdminNoticeBoardScreenState extends State<AdminNoticeBoardScreen> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditNoticeScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xffcb1964),
        child: const Icon(CupertinoIcons.add),
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xffcb1964).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    CupertinoIcons.bell_fill,
                    color: Color(0xffcb1964),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Notice",
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(notice.createdAt),
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              notice.content,
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditNoticeScreen(
                          notice: notice,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    CupertinoIcons.pencil,
                    color: const Color(0xffcb1964),
                    size: 16,
                  ),
                  label: Text(
                    'Edit',
                    style: GoogleFonts.poppins(
                      color: const Color(0xffcb1964),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _showDeleteConfirmation(notice),
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: Colors.red.shade400,
                    size: 16,
                  ),
                  label: Text(
                    'Delete',
                    style: GoogleFonts.poppins(
                      color: Colors.red.shade400,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Notice notice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Notice',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this notice?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _noticeRepository.deleteNotice(notice.id);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y • h:mm a').format(date);
  }
}
