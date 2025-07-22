import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/app_export.dart';
import '../../models/user_profile.dart';
import '../../models/workout_plan.dart';
import '../../services/gemini_client.dart';
import '../../services/gemini_service.dart';
import '../../services/chat_storage_service.dart';
import '../../services/response_formatter.dart';
import './widgets/chat_message_widget.dart';
import './widgets/voice_input_widget.dart';
import './widgets/chat_history_drawer.dart';

class ChatWithTrainly extends StatefulWidget {
  const ChatWithTrainly({super.key});

  @override
  State<ChatWithTrainly> createState() => _ChatWithTrainlyState();
}

class _ChatWithTrainlyState extends State<ChatWithTrainly>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  late GeminiClient _geminiClient;
  late SpeechToText _speechToText;
  late FlutterTts _flutterTts;

  bool _isLoading = false;
  bool _isListening = false;
  bool _speechEnabled = false;
  bool _isNewSession = true;
  WorkoutPlan? _currentWorkoutPlan;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeServices();
    _loadUserData();
    _loadCurrentSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveCurrentSession();
    _messageController.dispose();
    _scrollController.dispose();
    _speechToText.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Save session when app goes to background or is paused
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _saveCurrentSession();
    }
  }

  Future<void> _initializeServices() async {
    try {
      final geminiService = GeminiService();
      _geminiClient = GeminiClient(geminiService.dio, geminiService.authApiKey);

      _speechToText = SpeechToText();
      _flutterTts = FlutterTts();

      _speechEnabled = await _speechToText.initialize();

      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);

      if (_isNewSession) {
        _addInitialMessage();
      }
    } catch (e) {
      print('Error initializing services: $e');
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('user_profile');
    final workoutJson = prefs.getString('workout_plan');

    if (profileJson != null) {
      _userProfile = UserProfile.fromJson(jsonDecode(profileJson));
    }

    if (workoutJson != null) {
      _currentWorkoutPlan = WorkoutPlan.fromJson(jsonDecode(workoutJson));
    }
  }

  Future<void> _loadCurrentSession() async {
    try {
      final sessionData = await ChatStorageService.loadCurrentSession();
      if (sessionData.isNotEmpty) {
        setState(() {
          _messages.clear();
          for (final messageData in sessionData) {
            _messages.add(ChatMessage(
              text: messageData['text'] ?? '',
              isUser: messageData['isUser'] ?? false,
              timestamp: DateTime.parse(
                  messageData['timestamp'] ?? DateTime.now().toIso8601String()),
            ));
          }
          _isNewSession = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('Error loading current session: $e');
    }
  }

  Future<void> _saveCurrentSession() async {
    if (_messages.isEmpty) return;

    try {
      final sessionData = _messages
          .map((message) => {
                'text': message.text,
                'isUser': message.isUser,
                'timestamp': message.timestamp.toIso8601String(),
              })
          .toList();

      await ChatStorageService.saveCurrentSession(sessionData);
    } catch (e) {
      print('Error saving current session: $e');
    }
  }

  Future<void> _archiveAndStartNewSession() async {
    if (_messages.isNotEmpty) {
      // Archive current session to history
      await ChatStorageService.archiveCurrentSession();
    }

    // Clear current session
    await ChatStorageService.clearCurrentSession();

    // Reset UI
    setState(() {
      _messages.clear();
      _isNewSession = true;
    });

    _addInitialMessage();
  }

  void _loadSessionFromHistory(List<Map<String, dynamic>> sessionData) {
    setState(() {
      _messages.clear();
      for (final messageData in sessionData) {
        _messages.add(ChatMessage(
          text: messageData['text'] ?? '',
          isUser: messageData['isUser'] ?? false,
          timestamp: DateTime.parse(
              messageData['timestamp'] ?? DateTime.now().toIso8601String()),
        ));
      }
      _isNewSession = false;
    });
    _scrollToBottom();
  }

  void _addInitialMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text:
            "Hi! I'm Trainly, your AI personal workout coach. How can I help you today? You can ask me to:\n\n• Create a new workout plan\n• Modify your existing workouts\n• Add or remove exercises\n• Get workout suggestions\n\nJust tell me what you'd like to do!",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Save session after adding user message
    await _saveCurrentSession();

    try {
      final systemPrompt = _buildSystemPrompt();
      final chatMessages = [
        Message(role: 'user', content: systemPrompt),
        ..._messages
            .where((m) => m.isUser)
            .map((m) => Message(role: 'user', content: m.text)),
        Message(role: 'user', content: message),
      ];

      final response = await _geminiClient.createChat(
        messages: chatMessages,
        model: 'gemini-2.5-flash',
        maxTokens: 2048,
        temperature: 0.7,
      );

      await _processResponse(response.text);
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text:
              "Sorry, I'm having trouble connecting right now. Please try again later.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    }

    setState(() {
      _isLoading = false;
    });

    // Save session after AI response
    await _saveCurrentSession();
    _scrollToBottom();
  }

  String _buildSystemPrompt() {
    final userInfo =
        _userProfile?.profileSummary ?? "No profile information available";
    final currentPlan = _currentWorkoutPlan != null
        ? "Current workout plan: ${jsonEncode(_currentWorkoutPlan!.toJson())}"
        : "No current workout plan";

    return """
    You are Trainly, an AI personal workout coach. Help users plan, track, and adjust their workouts through natural conversation.
    
    User Profile: $userInfo
    $currentPlan
    
    IMPORTANT: When creating or updating workout plans, always respond with:
    1. A conversational response explaining what you're doing
    2. A complete JSON workout plan in this EXACT format:
    
    ```json
    {
      "monday": [{"exercise": "Exercise Name", "sets": 3, "reps": 15}],
      "tuesday": [{"exercise": "Yoga Session", "duration": "30 min"}],
      "wednesday": [{"exercise": "Push-ups", "sets": 3, "reps": 12}],
      "thursday": [{"exercise": "Rest Day", "duration": "Full rest"}],
      "friday": [{"exercise": "Cardio", "duration": "45 min"}],
      "saturday": [{"exercise": "Strength Training", "sets": 4, "reps": 10}],
      "sunday": [{"exercise": "Stretching", "duration": "20 min"}]
    }
    ```
    
    RULES:
    - Always include ALL 7 days (monday through sunday) in lowercase
    - Use "sets" and "reps" for strength exercises
    - Use "duration" for time-based activities
    - Even rest days should be included with appropriate activities
    - Make sure the JSON is properly formatted and valid
    
    Keep responses encouraging and personalized. Focus on the user's goals and preferences.
    """;
  }

  Future<void> _processResponse(String response) async {
    try {
      print('Raw response: $response'); // Debug log

      // Extract and process workout plan JSON if present
      final workoutJson = ResponseFormatter.extractJsonFromResponse(response);
      bool planWasUpdated = false;

      if (workoutJson != null &&
          ResponseFormatter.containsWorkoutPlan(response)) {
        print('Extracted JSON: $workoutJson'); // Debug log

        try {
          _currentWorkoutPlan = WorkoutPlan.fromJson(workoutJson);
          planWasUpdated = true;

          // Save workout plan
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'workout_plan', jsonEncode(_currentWorkoutPlan!.toJson()));

          print('Workout plan saved successfully'); // Debug log
        } catch (e) {
          print('Error creating workout plan from JSON: $e');
          planWasUpdated = false;
        }
      }

      // Format response to remove JSON and clean up text
      final formattedResponse =
          ResponseFormatter.formatGeminiResponse(response);

      // Create final response with clear feedback
      String finalResponse = formattedResponse;

      if (planWasUpdated) {
        // Add formatted workout plan text if JSON was found
        final planText = ResponseFormatter.formatWorkoutPlan(workoutJson!);

        // Provide clear feedback about planner update
        String updateMessage = "✅ I've updated your workout planner! ";

        if (formattedResponse.isNotEmpty) {
          finalResponse = '$formattedResponse\n\n$updateMessage\n\n$planText';
        } else {
          finalResponse =
              '$updateMessage\n\n$planText\n\n💡 Check the Planner tab to see your new workout schedule!';
        }
      } else if (formattedResponse.isEmpty) {
        // Fallback message when no clear response is available
        finalResponse =
            "I've processed your request! Let me know if you'd like me to create or modify your workout plan.";
      }

      setState(() {
        _messages.add(ChatMessage(
          text: finalResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      print('Error processing response: $e');
      setState(() {
        _messages.add(ChatMessage(
          text:
              "I've processed your request successfully! If you asked about workouts, check the Planner tab for any updates.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    }
  }

  Future<void> _startListening() async {
    if (!_speechEnabled) return;

    setState(() {
      _isListening = true;
    });

    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          _messageController.text = result.recognizedWords;
          setState(() {
            _isListening = false;
          });
        }
      },
    );
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: 8),
            Text('💬 Chat with Trainly'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_comment),
            tooltip: 'New Chat',
            onPressed: _archiveAndStartNewSession,
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.pushNamed(context, '/planner-view');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile-setup');
            },
          ),
        ],
      ),
      drawer: ChatHistoryDrawer(
        onSessionSelected: _loadSessionFromHistory,
        onNewChat: _archiveAndStartNewSession,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageWidget(message: _messages[index]);
              },
            ),
          ),
          if (_isLoading)
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Trainly is thinking...',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask Trainly anything...',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withAlpha(51),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  SizedBox(width: 8),
                  VoiceInputWidget(
                    isListening: _isListening,
                    onStartListening: _startListening,
                    onStopListening: _stopListening,
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
