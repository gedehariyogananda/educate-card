import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'widgets/swiper_card.dart';
import 'models/card_data.dart';
import 'widgets/flip_card.dart';
import 'utils/theme_colors.dart';
import 'screens/tutorial_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Static variable untuk track tutorial status
  static bool tutorialCompleted = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCard',
      initialRoute: tutorialCompleted ? '/home' : '/tutorial',
      routes: {
        '/tutorial': (context) => const TutorialScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<BaseDatas> cards = datas;
  bool isSoundEnabled = true;
  late FlutterTts flutterTts;
  int currentCardIndex = 0;

  // Showcase keys
  final GlobalKey _soundButtonKey = GlobalKey();
  final GlobalKey _menuButtonKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();
  final GlobalKey _progressKey = GlobalKey();

  bool _showShowcase = true;

  @override
  void initState() {
    super.initState();
    _initTts();

    // Show showcase after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showShowcase && MyApp.tutorialCompleted) {
        _startShowcase();
      }
    });
  }

  void _startShowcase() {
    ShowCaseWidget.of(
      context,
    ).startShowCase([_soundButtonKey, _cardKey, _progressKey, _menuButtonKey]);
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
    return ShowCaseWidget(
      builder: (context) => MaterialApp(
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
              Showcase(
                key: _soundButtonKey,
                title: 'Kontrol Suara',
                description:
                    'Tekan untuk menghidupkan atau mematikan suara narasi',
                targetBorderRadius: BorderRadius.circular(25),
                child: Container(
                  margin: EdgeInsets.only(right: 8),
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
                    tooltip: isSoundEnabled
                        ? 'Matikan Suara'
                        : 'Nyalakan Suara',
                  ),
                ),
              ),
              Showcase(
                key: _menuButtonKey,
                title: 'Menu Bantuan',
                description: 'Akses tutorial dan tips penggunaan',
                targetBorderRadius: BorderRadius.circular(25),
                child: PopupMenuButton<String>(
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(Icons.more_vert, color: Colors.white, size: 20),
                  ),
                  onSelected: (String value) {
                    if (value == 'tutorial') {
                      Navigator.pushNamed(context, '/tutorial');
                    } else if (value == 'showcase') {
                      _startShowcase();
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'tutorial',
                      child: Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: ThemeColors.baseColor,
                          ),
                          SizedBox(width: 8),
                          Text('Lihat Tutorial'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'showcase',
                      child: Row(
                        children: [
                          Icon(
                            Icons.tips_and_updates,
                            color: ThemeColors.baseColor,
                          ),
                          SizedBox(width: 8),
                          Text('Tips Penggunaan'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Showcase(
                    key: _cardKey,
                    title: 'Kartu Pembelajaran',
                    description:
                        'Ketuk untuk membalik kartu, swipe atas/bawah untuk navigasi',
                    targetBorderRadius: BorderRadius.circular(10),
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
              ),
              Showcase(
                key: _progressKey,
                title: 'Progress Pembelajaran',
                description:
                    'Menunjukkan kartu ke berapa dan kemajuan belajar Anda',
                targetBorderRadius: BorderRadius.circular(10),
                child: Container(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
