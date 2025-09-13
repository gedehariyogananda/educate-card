import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'card_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EduCardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class EduCardPage extends StatefulWidget {
  const EduCardPage({super.key});

  @override
  State<EduCardPage> createState() => _EduCardPageState();
}

class _EduCardPageState extends State<EduCardPage> {
  final FlutterTts flutterTts = FlutterTts();
  int currentIndex = 0;
  bool isSoundOn = true;

  @override
  void initState() {
    super.initState();
    _speakCurrentCard();
  }

  Future<void> _speakCurrentCard() async {
    await flutterTts.stop();
    if (isSoundOn) {
      await flutterTts.speak(eduCards[currentIndex].description);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
            decoration: const BoxDecoration(
              color: Color(0xFFF06292), // Merah muda
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'EduCard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isSoundOn ? Icons.volume_up : Icons.volume_off,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      isSoundOn = !isSoundOn;
                    });
                    _speakCurrentCard();
                  },
                  tooltip: 'Sound On/Off',
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 480,
                child: Swiper(
                  itemCount: currentIndex < eduCards.length
                      ? eduCards.length
                      : currentIndex + 1,
                  itemBuilder: (context, index) {
                    if (index >= eduCards.length) {
                      // Jika sudah di akhir, tampilkan zonk (tidak ada kartu)
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.pinkAccent,
                              size: 64,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Progress selesai!',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final card = eduCards[index];
                    // List pattern belang/random
                    final List<List<Color>> gradients = [
                      [Colors.pinkAccent, Colors.orangeAccent],
                      [Colors.purpleAccent, Colors.pinkAccent],
                      [Colors.blueAccent, Colors.cyanAccent],
                      [Colors.amber, Colors.deepOrangeAccent],
                      [Colors.greenAccent, Colors.tealAccent],
                      [Colors.indigoAccent, Colors.lightBlueAccent],
                      [Colors.deepPurpleAccent, Colors.purple],
                      [Colors.limeAccent, Colors.yellowAccent],
                    ];
                    final gradientColors = gradients[index % gradients.length];
                    return Container(
                      width: 280,
                      height: 480,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white, width: 6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withOpacity(0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                            child: Image.network(
                              card.imageUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            card.description,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                  onIndexChanged: (index) async {
                    setState(() {
                      currentIndex = index;
                    });
                    await _speakCurrentCard();
                  },
                  loop: false,
                  layout: SwiperLayout.STACK,
                  itemWidth: 280,
                  itemHeight: 480,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.pink[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.pinkAccent,
                            width: 2,
                          ),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          double percent = (currentIndex + 1) / eduCards.length;
                          if (percent > 1.0) percent = 1.0;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            width: constraints.maxWidth * percent,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.pinkAccent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          );
                        },
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '${currentIndex + 1} / ${eduCards.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Progress Belajar',
                  style: TextStyle(
                    color: Colors.pink[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
