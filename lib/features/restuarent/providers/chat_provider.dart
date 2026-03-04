import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';

class ChatState {
  final List<Message> messages;
  final bool isTyping;

  ChatState({required this.messages, required this.isTyping});

  ChatState copyWith({List<Message>? messages, bool? isTyping}) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() => ChatState(messages: [], isTyping: false);

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = Message(
      text: text.trim(),
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(messages: [...state.messages, userMessage]);

    state = state.copyWith(isTyping: true);

    await Future.delayed(Duration(milliseconds: 500 + text.length * 8));

    final aiReply = _generateReply(text);

    state = state.copyWith(isTyping: false);

    final aiMessage = Message(
      text: aiReply,
      type: MessageType.ai,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(messages: [...state.messages, aiMessage]);
  }

  String _generateReply(String input) {
    final text = input.toLowerCase().trim();

    if (text.startsWith("hi") ||
        text.startsWith("hello") ||
        text.startsWith("hey")) {
      return "Hello! 😊\n\nI'm here to help you. What would you like to know?";
    }

    if (text.contains("thank")) {
      return "You're welcome! 😊 Feel free to ask anything else.";
    }

    if (text.contains("flutter")) {
      return "Flutter is a powerful UI toolkit by Google.\n\nIt allows you to build mobile, web, and desktop applications using a single Dart codebase.";
    }

    if (text.contains("riverpod")) {
      return "Riverpod is a modern state management solution for Flutter.\n\nIt improves scalability and avoids dependency on BuildContext.";
    }

    if (text.contains("ai")) {
      return "Artificial Intelligence (AI) allows machines to simulate intelligent behavior.\n\nIt includes learning, reasoning, and decision-making.";
    }

    if (text.endsWith("?")) {
      return "That's a thoughtful question.\n\nTo understand it clearly:\n\n1️⃣ Identify the main concept.\n2️⃣ Break it into smaller parts.\n3️⃣ Understand how each part works.\n\nIf you'd like, I can explain with an example.";
    }

    return "Thank you for your message.\n\nCould you please provide more details so I can assist you better?";
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatState>(
  ChatNotifier.new,
);
