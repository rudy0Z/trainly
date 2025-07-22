import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './widgets/attachment_widget.dart';
import './widgets/delivery_tracking_widget.dart';
import './widgets/message_composer_widget.dart';
import './widgets/message_templates_widget.dart';
import './widgets/notification_preview_widget.dart';
import './widgets/priority_selector_widget.dart';
import './widgets/recipient_preview_widget.dart';
import './widgets/recipient_selector_widget.dart';
import './widgets/schedule_options_widget.dart';
import './widgets/send_options_widget.dart';

class AdminSendNotification extends StatefulWidget {
  const AdminSendNotification({super.key});

  @override
  State<AdminSendNotification> createState() => _AdminSendNotificationState();
}

class _AdminSendNotificationState extends State<AdminSendNotification> {
  final _messageController = TextEditingController();
  final _subjectController = TextEditingController();

  String _selectedRecipientType = 'All Members';
  String _selectedPriority = 'Normal';
  String _selectedTemplate = '';
  bool _isScheduled = false;
  DateTime? _scheduledDate;
  List<String> _attachments = [];
  bool _isPreviewMode = false;
  bool _isSending = false;
  Map<String, dynamic> _deliveryStatus = {};

  final List<String> _recipientTypes = [
    'All Members',
    'Active Members',
    'Trainers',
    'Premium Members',
    'New Members',
    'Inactive Members',
  ];

  final List<String> _priorityLevels = [
    'Low',
    'Normal',
    'High',
    'Urgent',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  void _handleSendNotification() {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    // Simulate sending notification
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSending = false;
        _deliveryStatus = {
          'total': 150,
          'sent': 150,
          'delivered': 145,
          'failed': 5,
          'timestamp': DateTime.now(),
        };
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification sent successfully')),
      );
    });
  }

  void _handleScheduleNotification() {
    if (_scheduledDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Notification scheduled for ${_scheduledDate!.toString().split('.')[0]}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Send Notification',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              _isPreviewMode ? Icons.edit : Icons.preview,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isPreviewMode = !_isPreviewMode;
              });
            },
          ),
        ],
      ),
      body: _isPreviewMode
          ? NotificationPreviewWidget(
              subject: _subjectController.text,
              message: _messageController.text,
              priority: _selectedPriority,
              recipientType: _selectedRecipientType,
              attachments: _attachments,
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipient Selection
                  RecipientSelectorWidget(
                    selectedRecipientType: _selectedRecipientType,
                    recipientTypes: _recipientTypes,
                    onRecipientTypeChanged: (value) {
                      setState(() {
                        _selectedRecipientType = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Message Composer
                  MessageComposerWidget(
                    subjectController: _subjectController,
                    messageController: _messageController,
                  ),

                  const SizedBox(height: 24),

                  // Message Templates
                  MessageTemplatesWidget(
                    selectedTemplate: _selectedTemplate,
                    onTemplateSelected: (template) {
                      setState(() {
                        _selectedTemplate = template;
                        _messageController.text = template;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Priority Selection
                  PrioritySelectorWidget(
                    selectedPriority: _selectedPriority,
                    priorityLevels: _priorityLevels,
                    onPriorityChanged: (value) {
                      setState(() {
                        _selectedPriority = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Schedule Options
                  ScheduleOptionsWidget(
                    isScheduled: _isScheduled,
                    scheduledDate: _scheduledDate,
                    onScheduledChanged: (value) {
                      setState(() {
                        _isScheduled = value;
                      });
                    },
                    onDateSelected: (date) {
                      setState(() {
                        _scheduledDate = date;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Recipient Preview
                  RecipientPreviewWidget(
                    recipientType: _selectedRecipientType,
                    memberCount: 150,
                  ),

                  const SizedBox(height: 24),

                  // Attachments
                  AttachmentWidget(
                    attachments: _attachments,
                    onAttachmentAdded: (attachment) {
                      setState(() {
                        _attachments.add(attachment);
                      });
                    },
                    onAttachmentRemoved: (index) {
                      setState(() {
                        _attachments.removeAt(index);
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Send Options
                  SendOptionsWidget(
                    isSending: _isSending,
                    isScheduled: _isScheduled,
                    onSendPressed: _handleSendNotification,
                    onSchedulePressed: _handleScheduleNotification,
                  ),

                  const SizedBox(height: 24),

                  // Delivery Tracking
                  if (_deliveryStatus.isNotEmpty)
                    DeliveryTrackingWidget(
                      deliveryStatus: _deliveryStatus,
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}
