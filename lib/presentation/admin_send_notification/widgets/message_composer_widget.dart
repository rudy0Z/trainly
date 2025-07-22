import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MessageComposerWidget extends StatelessWidget {
  final TextEditingController subjectController;
  final TextEditingController messageController;

  const MessageComposerWidget({
    super.key,
    required this.subjectController,
    required this.messageController,
  });

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
            'Message Composition',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Subject Field
          TextFormField(
            controller: subjectController,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: 'Subject',
              labelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF666666),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Message Field
          TextFormField(
            controller: messageController,
            maxLines: 8,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: 'Message',
              labelStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF666666),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Formatting Toolbar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                _buildFormatButton(Icons.format_bold, 'Bold'),
                _buildFormatButton(Icons.format_italic, 'Italic'),
                _buildFormatButton(Icons.format_underlined, 'Underline'),
                const VerticalDivider(color: Color(0xFFE0E0E0)),
                _buildFormatButton(Icons.format_list_bulleted, 'List'),
                _buildFormatButton(Icons.format_list_numbered, 'Numbered List'),
                const VerticalDivider(color: Color(0xFFE0E0E0)),
                _buildFormatButton(Icons.link, 'Link'),
                _buildFormatButton(Icons.image, 'Image'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.black,
          size: 18,
        ),
        onPressed: () {
          // Handle formatting action
        },
      ),
    );
  }
}
