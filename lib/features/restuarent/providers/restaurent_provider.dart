import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../models/food_item.dart';

class RestaurantState {
  final List<Message> messages;
  final List<FoodItem> cart;
  final bool isTyping;
  final bool isInMenu;

  RestaurantState({
    required this.messages,
    required this.cart,
    required this.isTyping,
    required this.isInMenu,
  });

  RestaurantState copyWith({
    List<Message>? messages,
    List<FoodItem>? cart,
    bool? isTyping,
    bool? isInMenu,
  }) {
    return RestaurantState(
      messages: messages ?? this.messages,
      cart: cart ?? this.cart,
      isTyping: isTyping ?? this.isTyping,
      isInMenu: isInMenu ?? this.isInMenu,
    );
  }
}

class RestaurantNotifier extends Notifier<RestaurantState> {
  final List<FoodItem> menu = const [
    FoodItem(name: "Margherita Pizza", price: 299),
    FoodItem(name: "Veg Burger", price: 199),
    FoodItem(name: "Pasta Alfredo", price: 249),
    FoodItem(name: "French Fries", price: 149),
    FoodItem(name: "Coke", price: 49),
  ];

  @override
  RestaurantState build() {
    return RestaurantState(
      messages: [
        Message(
          text: _mainMenu(),
          type: MessageType.bot,
          timestamp: DateTime.now(),
        ),
      ],
      cart: [],
      isTyping: false,
      isInMenu: false,
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = Message(
      text: text,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    await Future.delayed(const Duration(milliseconds: 700));

    final reply = _generateReply(text.trim());

    final botMessage = Message(
      text: reply,
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, botMessage],
      isTyping: false,
    );
  }

  String _generateReply(String input) {
    if (!state.isInMenu) {
      switch (input) {
        case "1":
          state = state.copyWith(isInMenu: true);
          return _menuOptions();

        case "2":
          return _cartText();

        case "3":
          return _placeOrder();

        case "4":
          return "👋 Thank you for visiting Foodie Restaurant!";

        default:
          return "❌ Invalid option.\n\n${_mainMenu()}";
      }
    } else {
      switch (input) {
        case "1":
          return _addToCart(menu[0]);

        case "2":
          return _addToCart(menu[1]);

        case "3":
          return _addToCart(menu[2]);

        case "4":
          return _addToCart(menu[3]);

        case "5":
          return _addToCart(menu[4]);

        case "6":
          state = state.copyWith(isInMenu: false);
          return _mainMenu();

        default:
          return "❌ Invalid selection.\nSelect item number.";
      }
    }
  }

  String _mainMenu() {
    return "🍽️ Welcome to Foodie Restaurant!\n\n"
        "1️⃣ View Menu\n"
        "2️⃣ View Cart\n"
        "3️⃣ Place Order\n"
        "4️⃣ Exit";
  }

  String _menuOptions() {
    return "📋 Our Menu:\n\n"
        "1️⃣ Margherita Pizza - ₹299\n"
        "2️⃣ Veg Burger - ₹199\n"
        "3️⃣ Pasta Alfredo - ₹249\n"
        "4️⃣ French Fries - ₹149\n"
        "5️⃣ Coke - ₹49\n"
        "6️⃣ Back to Main Menu";
  }

  String _addToCart(FoodItem item) {
    state = state.copyWith(cart: [...state.cart, item]);
    return "✅ ${item.name} added to cart.\n\nSelect another item or press 6 to go back.";
  }

  String _cartText() {
    if (state.cart.isEmpty) return "🛒 Your cart is empty.";

    double total = 0;
    String text = "🛒 Your Cart:\n\n";

    for (var item in state.cart) {
      text += "${item.name} - ₹${item.price}\n";
      total += item.price;
    }

    text += "\nTotal: ₹$total";
    return text;
  }

  String _placeOrder() {
    if (state.cart.isEmpty) return "🛒 Your cart is empty.";

    double total = state.cart.fold(0, (sum, item) => sum + item.price);

    state = state.copyWith(cart: []);

    return "🎉 Order placed successfully!\n\nTotal: ₹$total\nDelivery in 30 mins 🚀";
  }
}

final restaurantProvider =
    NotifierProvider<RestaurantNotifier, RestaurantState>(
      RestaurantNotifier.new,
    );
