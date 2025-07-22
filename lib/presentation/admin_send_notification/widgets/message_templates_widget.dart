import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MessageTemplatesWidget extends StatelessWidget {
  final String selectedTemplate;
  final Function(String) onTemplateSelected;

  const MessageTemplatesWidget({
    super.key,
    required this.selectedTemplate,
    required this.onTemplateSelected,
  });

  final List<Map<String, String>> templates = const [
    {
      'title': 'Welcome Message',
      'preview':
          'Welcome to our gym! We\'re excited to have you join our fitness community...',
      'content':
          'Welcome to our gym! We\'re excited to have you join our fitness community. Here\'s everything you need to know to get started on your fitness journey.',
    },
    {
      'title': 'Class Reminder',
      'preview':
          'Don\'t forget about your upcoming class tomorrow at 10:00 AM...',
      'content':
          'Don\'t forget about your upcoming class tomorrow at 10:00 AM. Please arrive 10 minutes early and bring a water bottle.',
    },
    {
      'title': 'Membership Expiry',
      'preview':
          'Your membership expires in 7 days. Renew now to continue enjoying...',
      'content':
          'Your membership expires in 7 days. Renew now to continue enjoying our premium facilities and exclusive classes.',
    },
    {
      'title': 'New Class Announcement',
      'preview': 'We\'re excited to announce a new class starting next week...',
      'content':
          'We\'re excited to announce a new class starting next week. Join us for this exciting fitness opportunity!',
    },
    {
      'title': 'Maintenance Notice',
      'preview':
          'Please note that our facility will be undergoing maintenance...',
      'content':
          'Please note that our facility will be undergoing maintenance this weekend. We apologize for any inconvenience.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Message Templates',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                final isSelected = selectedTemplate == template['content'];

                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected ? Colors.black : const Color(0xFFE0E0E0),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.black
                                    : const Color(0xFFE0E0E0),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.black,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              template['title']!,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          template['preview']!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF666666),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
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
    );
  }
}
