import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  double rating = 3;
  final TextEditingController reviewController = TextEditingController();

  Widget buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 32,
      ),
      onPressed: () {
        setState(() {
          rating = index.toDouble();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Our Service ⭐")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Give your feedback",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildStar(1),
                buildStar(2),
                buildStar(3),
                buildStar(4),
                buildStar(5),
              ],
            ),

            const SizedBox(height: 30),

            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Write your review...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Thank you for your review!")),
                  );
                },
                child: const Text("Submit Review"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
