import 'package:flutter/material.dart';

class VoiceInputWidget extends StatelessWidget {
  final bool isListening;
  final VoidCallback onStartListening;
  final VoidCallback onStopListening;

  const VoiceInputWidget({
    super.key,
    required this.isListening,
    required this.onStartListening,
    required this.onStopListening,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isListening ? onStopListening : onStartListening,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isListening
              ? Colors.red
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          isListening ? Icons.stop : Icons.mic,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
