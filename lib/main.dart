import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  bool isSoundEnabled = true;
  late FlutterTts flutterTts;
  int currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("id-ID");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    if (isSoundEnabled && text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  void _toggleSound() {
    setState(() {
      isSoundEnabled = !isSoundEnabled;
    });
    if (!isSoundEnabled) {
      flutterTts.stop();
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCard',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.baseColor,
          elevation: 8,
          shadowColor: ThemeColors.baseColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          toolbarHeight: 70, // Tinggi AppBar sedikit lebih besar
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.school, color: Colors.white, size: 28),
              ),
              SizedBox(width: 12),
              Text(
                'EduCard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: _toggleSound,
                icon: Icon(
                  isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                  size: 26,
                ),
                tooltip: isSoundEnabled ? 'Matikan Suara' : 'Nyalakan Suara',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: CardsSwiperWidget<BaseDatas>(
                  cardData: cards,
                  onCardChange: (index) {
                    setState(() {
                      currentCardIndex = index;
                    });
                    if (index >= 0 && index < cards.length) {
                      _speak(cards[index].description);
                    }
                  },
                  cardBuilder: (context, index, visibleIndex) {
                    final BaseDatas card = cards[index];
                    return FlipCard(
                      front: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ThemeColors.baseColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
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
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                card.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      back: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ThemeColors.baseColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        width: 300,
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Q: ${card.question}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'A: ${card.answer}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
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
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '${currentCardIndex + 1}/${cards.length}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.baseColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (currentCardIndex + 1) / cards.length,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeColors.baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
