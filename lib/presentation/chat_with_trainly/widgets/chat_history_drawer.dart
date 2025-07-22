import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../services/chat_storage_service.dart';

class ChatHistoryDrawer extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onSessionSelected;
  final VoidCallback onNewChat;

  const ChatHistoryDrawer({
    super.key,
    required this.onSessionSelected,
    required this.onNewChat,
  });

  @override
  State<ChatHistoryDrawer> createState() => _ChatHistoryDrawerState();
}

class _ChatHistoryDrawerState extends State<ChatHistoryDrawer> {
  List<Map<String, dynamic>> _chatHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    setState(() => _isLoading = true);

    try {
      final history = await ChatStorageService.loadChatHistory();
      setState(() {
        _chatHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading chat history: $e');
    }
  }

  Future<void> _selectSession(String sessionId) async {
    try {
      final messages = await ChatStorageService.loadSessionById(sessionId);
      widget.onSessionSelected(messages);
      Navigator.pop(context);
    } catch (e) {
      print('Error loading session: $e');
    }
  }

  Future<void> _deleteSession(String sessionId) async {
    try {
      // Remove from local list
      setState(() {
        _chatHistory.removeWhere((session) => session['id'] == sessionId);
      });

      // Update storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('chat_history_sessions', jsonEncode(_chatHistory));
    } catch (e) {
      print('Error deleting session: $e');
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return 'Today ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Chat History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  '${_chatHistory.length} conversations',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add_comment,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              'New Chat',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('Start a fresh conversation'),
            onTap: () {
              widget.onNewChat();
              Navigator.pop(context);
            },
          ),
          Divider(),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _chatHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No chat history yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Start chatting with Trainly\nto see your conversations here',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _chatHistory.length,
                        itemBuilder: (context, index) {
                          final session = _chatHistory[index];
                          return ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme
                                    .lightTheme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.chat,
                                color: AppTheme.lightTheme.colorScheme
                                    .onSecondaryContainer,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              session['preview'] ?? 'Conversation',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_formatTimestamp(session['timestamp'])),
                                Text(
                                  '${session['messageCount']} messages',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: () => _deleteSession(session['id']),
                            ),
                            onTap: () => _selectSession(session['id']),
                          );
                        },
                      ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete_sweep),
            title: Text('Clear All History'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear Chat History'),
                  content: Text(
                      'Are you sure you want to delete all chat conversations? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: Text('Clear All'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ChatStorageService.clearAllHistory();
                setState(() {
                  _chatHistory.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
