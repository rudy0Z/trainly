import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../admin_notifications.dart';

class NotificationComposerWidget extends StatefulWidget {
  final VoidCallback onClose;
  final Function(NotificationData) onCreate;

  const NotificationComposerWidget({
    super.key,
    required this.onClose,
    required this.onCreate,
  });

  @override
  State<NotificationComposerWidget> createState() =>
      _NotificationComposerWidgetState();
}

class _NotificationComposerWidgetState
    extends State<NotificationComposerWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  NotificationPriority _selectedPriority = NotificationPriority.normal;
  bool _sendNow = false;
  Set<String> _selectedRecipients = <String>{};
  final List<String> _allRecipients = [
    'All Members',
    'Premium Members',
    'Basic Members',
    'Trainers',
    'Staff',
    'New Members',
  ];

  @override
  void initState() {
    super.initState();
    _selectedRecipients.add('All Members');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withAlpha(128),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(16.sp),
          constraints: BoxConstraints(maxHeight: 80.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'New Notification',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Icon(
                        Icons.close,
                        size: 24.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Input
                      Text(
                        'Title',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      TextField(
                        controller: _titleController,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter notification title...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF666666),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                          ),
                          contentPadding: EdgeInsets.all(12.sp),
                        ),
                      ),
                      SizedBox(height: 16.sp),
                      // Content Input
                      Text(
                        'Content',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      TextField(
                        controller: _contentController,
                        maxLines: 4,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter notification content...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF666666),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                          ),
                          contentPadding: EdgeInsets.all(12.sp),
                        ),
                      ),
                      SizedBox(height: 16.sp),
                      // Priority Selection
                      Text(
                        'Priority',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: DropdownButton<NotificationPriority>(
                          value: _selectedPriority,
                          isExpanded: true,
                          underline: const SizedBox(),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          items: NotificationPriority.values.map((priority) {
                            return DropdownMenuItem<NotificationPriority>(
                              value: priority,
                              child: Text(
                                priority.name.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (NotificationPriority? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedPriority = newValue;
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 16.sp),
                      // Recipients Selection
                      Text(
                        'Recipients',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Container(
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Column(
                          children: _allRecipients.map((recipient) {
                            return CheckboxListTile(
                              title: Text(
                                recipient,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                              value: _selectedRecipients.contains(recipient),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedRecipients.add(recipient);
                                  } else {
                                    _selectedRecipients.remove(recipient);
                                  }
                                });
                              },
                              activeColor: Colors.black,
                              checkColor: Colors.white,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 16.sp),
                      // Send Now Option
                      Row(
                        children: [
                          Checkbox(
                            value: _sendNow,
                            onChanged: (bool? value) {
                              setState(() {
                                _sendNow = value ?? false;
                              });
                            },
                            activeColor: Colors.black,
                            checkColor: Colors.white,
                          ),
                          Text(
                            'Send immediately',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Footer Actions
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                ),
                child: Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onClose,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.sp),
                    // Create Button
                    Expanded(
                      child: GestureDetector(
                        onTap: _createNotification,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.sp),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _sendNow ? 'Send Now' : 'Save Draft',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createNotification() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      return;
    }

    final notification = NotificationData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      status: _sendNow ? NotificationStatus.sent : NotificationStatus.draft,
      priority: _selectedPriority,
      timestamp: DateTime.now(),
      recipientCount: _calculateRecipientCount(),
      deliveredCount: _sendNow ? _calculateRecipientCount() : 0,
      readCount: 0,
    );

    widget.onCreate(notification);
  }

  int _calculateRecipientCount() {
    int count = 0;
    for (final recipient in _selectedRecipients) {
      switch (recipient) {
        case 'All Members':
          count += 200;
          break;
        case 'Premium Members':
          count += 75;
          break;
        case 'Basic Members':
          count += 125;
          break;
        case 'Trainers':
          count += 15;
          break;
        case 'Staff':
          count += 10;
          break;
        case 'New Members':
          count += 25;
          break;
      }
    }
    return count;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
