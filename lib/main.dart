import 'package:flutter/material.dart';
import 'card_swipper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, dynamic>> cards = [
    {'color': Colors.blue, 'text': 'Card 1'},
    {'color': Colors.red, 'text': 'Card 2'},
    {'color': Colors.green, 'text': 'Card 3'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Stack Animation',
      home: Scaffold(
        body: Center(
          child: CardsSwiperWidget(
            cardData: cards,
            onCardChange: (index) {
              print('Top card index: $index');
            },
            cardBuilder: (context, index, visibleIndex) {
              final card = cards[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: card['color'] as Color,
                ),
                width: 300,
                height: 200,
                alignment: Alignment.center,
                child: Text(
                  card['text'] as String,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
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
