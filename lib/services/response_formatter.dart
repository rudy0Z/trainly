import 'dart:convert';

class ResponseFormatter {
  // Format Gemini API response by removing JSON and cleaning text
  static String formatGeminiResponse(String rawResponse) {
    try {
      // Remove JSON blocks from response
      String cleanedResponse = _removeJsonBlocks(rawResponse);

      // Clean up formatting issues
      cleanedResponse = _cleanFormatting(cleanedResponse);

      // Handle empty responses
      if (cleanedResponse.trim().isEmpty) {
        return "I've processed your request successfully!";
      }

      return cleanedResponse.trim();
    } catch (e) {
      print('Error formatting response: $e');
      return rawResponse; // Return original if formatting fails
    }
  }

  // Extract and parse JSON from response - Enhanced to handle multiple formats
  static Map<String, dynamic>? extractJsonFromResponse(String response) {
    try {
      // First, try to extract JSON from code blocks (```json ... ```)
      final codeBlockMatch =
          RegExp(r'```(?:json)?\s*(\{[\s\S]*?\})\s*```', caseSensitive: false)
              .firstMatch(response);
      if (codeBlockMatch != null) {
        final jsonStr = codeBlockMatch.group(1)!;
        try {
          return jsonDecode(jsonStr);
        } catch (e) {
          print('Error parsing JSON from code block: $e');
        }
      }

      // Then try to find any JSON object in the response
      final jsonMatches =
          RegExp(r'\{[^{}]*(?:\{[^{}]*\}[^{}]*)*\}').allMatches(response);

      for (final match in jsonMatches) {
        final jsonStr = match.group(0)!;
        try {
          final parsed = jsonDecode(jsonStr);
          // Check if this looks like a workout plan
          if (parsed is Map<String, dynamic> &&
              _isWorkoutPlanStructure(parsed)) {
            return parsed;
          }
        } catch (e) {
          // Continue to next match
          continue;
        }
      }

      return null;
    } catch (e) {
      print('Error extracting JSON: $e');
      return null;
    }
  }

  // Check if the JSON structure looks like a workout plan
  static bool _isWorkoutPlanStructure(Map<String, dynamic> json) {
    final weekDays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];

    // Check if at least one weekday exists as a key
    for (final day in weekDays) {
      if (json.containsKey(day)) {
        return true;
      }
    }

    return false;
  }

  // Remove JSON blocks from text - Enhanced to handle code blocks
  static String _removeJsonBlocks(String text) {
    // Remove code blocks with json
    text = text.replaceAll(
        RegExp(r'```(?:json)?\s*\{[\s\S]*?\}\s*```', caseSensitive: false), '');

    // Remove standalone JSON objects
    text = text.replaceAll(RegExp(r'\{[^{}]*(?:\{[^{}]*\}[^{}]*)*\}'), '');

    // Remove JSON arrays
    text = text.replaceAll(RegExp(r'\[[\s\S]*?\]'), '');

    // Remove remaining code blocks
    text = text.replaceAll(RegExp(r'```[\s\S]*?```'), '');

    return text;
  }

  // Clean formatting issues
  static String _cleanFormatting(String text) {
    // Remove excessive whitespace
    text = text.replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n');

    // Clean up bullet points
    text = text.replaceAll(RegExp(r'^•\s+', multiLine: true), '• ');

    // Remove trailing punctuation from incomplete sentences
    text = text.replaceAll(RegExp(r'\s+[,.]$'), '');

    // Ensure proper sentence endings
    text = text.replaceAll(RegExp(r'([a-z])\n'), r'$1.\n');

    // Remove extra spaces
    text = text.replaceAll(RegExp(r'  +'), ' ');

    return text;
  }

  // Format workout plan JSON into readable text
  static String formatWorkoutPlan(Map<String, dynamic> workoutJson) {
    final buffer = StringBuffer();
    buffer.writeln('📋 Your Updated Workout Plan:');
    buffer.writeln();

    final weekDays = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];

    for (final day in weekDays) {
      final exercises = workoutJson[day];
      if (exercises != null && exercises is List && exercises.isNotEmpty) {
        final dayName = day.substring(0, 1).toUpperCase() + day.substring(1);
        buffer.writeln('🗓️ **$dayName**');

        for (final exercise in exercises) {
          if (exercise is Map) {
            final name = exercise['exercise'] ?? 'Unknown Exercise';
            if (exercise.containsKey('sets') && exercise.containsKey('reps')) {
              buffer.writeln(
                  '  • $name: ${exercise['sets']} sets × ${exercise['reps']} reps');
            } else if (exercise.containsKey('duration')) {
              buffer.writeln('  • $name: ${exercise['duration']}');
            } else {
              buffer.writeln('  • $name');
            }
          }
        }
        buffer.writeln();
      }
    }

    return buffer.toString().trim();
  }

  // Check if response contains workout plan - Enhanced detection
  static bool containsWorkoutPlan(String response) {
    // Check for workout plan keywords along with JSON structure
    final hasWorkoutKeywords = RegExp(
            r'\b(workout|exercise|plan|training|fitness)\b',
            caseSensitive: false)
        .hasMatch(response);
    final hasWeekdayStructure = RegExp(
            r'\{[\s\S]*("monday"|"tuesday"|"wednesday"|"thursday"|"friday"|"saturday"|"sunday")[\s\S]*\}')
        .hasMatch(response);

    return hasWorkoutKeywords && hasWeekdayStructure;
  }

  // Format list items for better readability
  static String formatListItems(String text) {
    // Convert numbered lists to bullet points for consistency
    text = text.replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '• ');

    // Ensure proper spacing after bullet points
    text = text.replaceAll(RegExp(r'^•([^\s])', multiLine: true), r'• $1');

    return text;
  }
}
