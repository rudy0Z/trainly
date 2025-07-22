import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatStorageService {
  static const String _currentSessionKey = 'current_chat_session';
  static const String _chatHistoryKey = 'chat_history_sessions';
  static const String _sessionCountKey = 'session_count';
  static const int _maxStoredSessions = 20;

  // Save current chat session
  static Future<void> saveCurrentSession(
      List<Map<String, dynamic>> messages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentSessionKey, jsonEncode(messages));
  }

  // Load current chat session
  static Future<List<Map<String, dynamic>>> loadCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionData = prefs.getString(_currentSessionKey);
    if (sessionData == null) return [];

    try {
      final List<dynamic> decoded = jsonDecode(sessionData);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // Save session to history when app closes
  static Future<void> archiveCurrentSession() async {
    final currentSession = await loadCurrentSession();
    if (currentSession.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getString(_chatHistoryKey) ?? '[]';

    try {
      final List<dynamic> history = jsonDecode(historyData);
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();

      // Create session summary
      final sessionSummary = {
        'id': sessionId,
        'timestamp': DateTime.now().toIso8601String(),
        'messageCount': currentSession.length,
        'preview': _generatePreview(currentSession),
        'messages': currentSession,
      };

      history.insert(0, sessionSummary);

      // Keep only the most recent sessions
      if (history.length > _maxStoredSessions) {
        history.removeRange(_maxStoredSessions, history.length);
      }

      await prefs.setString(_chatHistoryKey, jsonEncode(history));
      await _incrementSessionCount();
    } catch (e) {
      print('Error archiving chat session: $e');
    }
  }

  // Load all chat history sessions
  static Future<List<Map<String, dynamic>>> loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyData = prefs.getString(_chatHistoryKey) ?? '[]';

    try {
      final List<dynamic> decoded = jsonDecode(historyData);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  // Load specific session by ID
  static Future<List<Map<String, dynamic>>> loadSessionById(
      String sessionId) async {
    final history = await loadChatHistory();
    final session = history.firstWhere(
      (s) => s['id'] == sessionId,
      orElse: () => {},
    );

    if (session.isEmpty) return [];
    return List<Map<String, dynamic>>.from(session['messages'] ?? []);
  }

  // Clear current session
  static Future<void> clearCurrentSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentSessionKey);
  }

  // Clear all chat history
  static Future<void> clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatHistoryKey);
    await prefs.remove(_sessionCountKey);
    await clearCurrentSession();
  }

  // Generate preview text for session
  static String _generatePreview(List<Map<String, dynamic>> messages) {
    if (messages.isEmpty) return 'Empty conversation';

    // Find first user message for preview
    final userMessage = messages.firstWhere(
      (m) => m['isUser'] == true,
      orElse: () => {'text': 'New conversation'},
    );

    final text = userMessage['text'] as String;
    return text.length > 50 ? '${text.substring(0, 50)}...' : text;
  }

  // Track session count for analytics
  static Future<void> _incrementSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(_sessionCountKey) ?? 0;
    await prefs.setInt(_sessionCountKey, currentCount + 1);
  }

  // Get total session count
  static Future<int> getTotalSessionCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sessionCountKey) ?? 0;
  }
}
