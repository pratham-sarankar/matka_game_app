import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/models/notice.dart';
import 'package:matka_game_app/repositories/notice_repository.dart';

class AddEditNoticeScreen extends StatefulWidget {
  final Notice? notice;

  const AddEditNoticeScreen({
    super.key,
    this.notice,
  });

  @override
  State<AddEditNoticeScreen> createState() => _AddEditNoticeScreenState();
}

class _AddEditNoticeScreenState extends State<AddEditNoticeScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _noticeRepository = NoticeRepository();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.notice != null) {
      _contentController.text = widget.notice!.content;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveNotice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.notice == null) {
        await _noticeRepository.addNotice(_contentController.text.trim());
      } else {
        await _noticeRepository.updateNotice(
          widget.notice!.id,
          _contentController.text.trim(),
        );
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.notice == null ? 'Add Notice' : 'Edit Notice',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xffcb1964)),
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(
                CupertinoIcons.checkmark,
              ),
              onPressed: _saveNotice,
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xffcb1964).withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _contentController,
                        maxLines: 8,
                        decoration: InputDecoration(
                          hintText: 'Write your notice here...',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter notice content';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveNotice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffcb1964),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.notice == null
                                ? CupertinoIcons.add
                                : CupertinoIcons.checkmark,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.notice == null
                                ? 'Add Notice'
                                : 'Update Notice',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
