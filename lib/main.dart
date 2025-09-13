import 'package:flutter/material.dart';
import 'card_swipper.dart';
import 'card_data.dart';
import 'flip_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Gunakan data EduCard dari card_data.dart
  final List<EduCard> cards = eduCards;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Stack Animation',
      home: Scaffold(
        body: Center(
          child: CardsSwiperWidget<EduCard>(
            cardData: cards,
            onCardChange: (index) {
              print('Top card index: $index');
            },
            cardBuilder: (context, index, visibleIndex) {
              final EduCard card = cards[index];
              return FlipCard(
                front: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 255, 124, 167),
                  ),
                  width: 300,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        card.imageUrl,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        card.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                back: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 255, 124, 167),
                  ),
                  width: 300,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Q: ${card.question}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A: ${card.answer}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onCardCollectionAnimationComplete: (bool value) {},
          ),
        ),
      ),
    );
  }
}
