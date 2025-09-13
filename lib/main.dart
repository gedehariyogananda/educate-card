import 'package:flutter/material.dart';
import 'widgets/swiper_card.dart';
import 'models/card_data.dart';
import 'widgets/flip_card.dart';
import 'utils/theme_colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<BaseDatas> cards = datas;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CardsSwiperWidget<BaseDatas>(
            cardData: cards,
            onCardChange: (index) {},
            cardBuilder: (context, index, visibleIndex) {
              final BaseDatas card = cards[index];
              return FlipCard(
                front: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ThemeColors.baseColor,
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
                    color: ThemeColors.baseColor,
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
