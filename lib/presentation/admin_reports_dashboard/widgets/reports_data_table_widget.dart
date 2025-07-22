import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsDataTableWidget extends StatefulWidget {
  const ReportsDataTableWidget({super.key});

  @override
  State<ReportsDataTableWidget> createState() => _ReportsDataTableWidgetState();
}

class _ReportsDataTableWidgetState extends State<ReportsDataTableWidget> {
  int sortColumnIndex = 0;
  bool sortAscending = true;

  final List<Map<String, dynamic>> reportData = [
    {
      'date': '2025-07-11',
      'revenue': 1250.00,
      'members': 45,
      'classes': 12,
      'bookings': 128,
      'cancellations': 3,
    },
    {
      'date': '2025-07-10',
      'revenue': 980.00,
      'members': 38,
      'classes': 10,
      'bookings': 95,
      'cancellations': 5,
    },
    {
      'date': '2025-07-09',
      'revenue': 1420.00,
      'members': 52,
      'classes': 14,
      'bookings': 142,
      'cancellations': 2,
    },
    {
      'date': '2025-07-08',
      'revenue': 1180.00,
      'members': 41,
      'classes': 11,
      'bookings': 115,
      'cancellations': 8,
    },
    {
      'date': '2025-07-07',
      'revenue': 890.00,
      'members': 33,
      'classes': 9,
      'bookings': 89,
      'cancellations': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          _buildTableContent(),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          _buildHeaderCell('Date', 0, flex: 2),
          _buildHeaderCell('Revenue', 1, flex: 2),
          _buildHeaderCell('Members', 2, flex: 2),
          _buildHeaderCell('Classes', 3, flex: 2),
          _buildHeaderCell('Bookings', 4, flex: 2),
          _buildHeaderCell('Cancellations', 5, flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, int columnIndex, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: () => _sortTable(columnIndex),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            if (sortColumnIndex == columnIndex)
              Icon(
                sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableContent() {
    return Column(
      children: reportData.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final isEven = index % 2 == 0;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isEven ? Colors.white : const Color(0xFFF5F5F5),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFE0E0E0),
                width: index == reportData.length - 1 ? 0 : 1,
              ),
            ),
          ),
          child: Row(
            children: [
              _buildDataCell(data['date'], flex: 2),
              _buildDataCell('\$${data['revenue'].toStringAsFixed(2)}',
                  flex: 2),
              _buildDataCell(data['members'].toString(), flex: 2),
              _buildDataCell(data['classes'].toString(), flex: 2),
              _buildDataCell(data['bookings'].toString(), flex: 2),
              _buildDataCell(data['cancellations'].toString(), flex: 2),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDataCell(String value, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  void _sortTable(int columnIndex) {
    setState(() {
      if (sortColumnIndex == columnIndex) {
        sortAscending = !sortAscending;
      } else {
        sortColumnIndex = columnIndex;
        sortAscending = true;
      }

      reportData.sort((a, b) {
        dynamic aValue, bValue;

        switch (columnIndex) {
          case 0:
            aValue = a['date'];
            bValue = b['date'];
            break;
          case 1:
            aValue = a['revenue'];
            bValue = b['revenue'];
            break;
          case 2:
            aValue = a['members'];
            bValue = b['members'];
            break;
          case 3:
            aValue = a['classes'];
            bValue = b['classes'];
            break;
          case 4:
            aValue = a['bookings'];
            bValue = b['bookings'];
            break;
          case 5:
            aValue = a['cancellations'];
            bValue = b['cancellations'];
            break;
        }

        if (sortAscending) {
          return aValue.compareTo(bValue);
        } else {
          return bValue.compareTo(aValue);
        }
      });
    });
  }
}
