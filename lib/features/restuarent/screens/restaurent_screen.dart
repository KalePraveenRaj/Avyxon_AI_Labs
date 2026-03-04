import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../providers/restaurent_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final controller = TextEditingController();
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(restaurantProvider, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Foodie Restaurant 🍽️"),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: state.messages.length,
              itemBuilder: (_, i) => MessageBubble(message: state.messages[i]),
            ),
          ),
          if (state.isTyping) const TypingIndicator(),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _inputBar() {
    void send() {
      final text = controller.text.trim();
      if (text.isEmpty) return;

      ref.read(restaurantProvider.notifier).sendMessage(text);
      controller.clear();
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Focus(
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.enter &&
                    !HardwareKeyboard.instance.isShiftPressed) {
                  send();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: "Enter option number...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.send), onPressed: send),
        ],
      ),
    );
  }
}
