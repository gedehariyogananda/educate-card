import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/swiper_card.dart';
import 'models/card_data.dart';
import 'widgets/flip_card.dart';
import 'utils/theme_colors.dart';
import 'screens/tutorial_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduCard',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/tutorial': (context) => const TutorialScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTutorialStatus();
  }

  Future<void> _checkTutorialStatus() async {
    await Future.delayed(Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final tutorialCompleted = prefs.getBool('tutorial_completed') ?? false;

    if (mounted) {
      if (tutorialCompleted) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/tutorial');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.baseColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(Icons.school, size: 80, color: ThemeColors.baseColor),
            ),
            SizedBox(height: 30),
            Text(
              'EduCard',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Aplikasi pembelajaran interaktif dengan kartu edukasi yang menyenangkan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 50),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
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
    _loadLastCardIndex();

    // Show showcase after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showShowcase) {
        _startShowcase();
      }
    });
  }

  // Load last card index from SharedPreferences
  Future<void> _loadLastCardIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt('last_card_index') ?? 0;
      final savedSoundState = prefs.getBool('sound_enabled') ?? true;
      final tutorialStatus = prefs.getBool('tutorial_completed') ?? false;

      // Log untuk debugging
      print('=== HOME PAGE DEBUG ===');
      print('Loading saved card index: $savedIndex');
      print('Sound enabled: $savedSoundState');
      print('Tutorial completed status: $tutorialStatus');
      print('====================');

      setState(() {
        currentCardIndex = savedIndex.clamp(0, cards.length - 1);
        isSoundEnabled = savedSoundState;
      });

      // Speak current card if sound is enabled
      if (isSoundEnabled && currentCardIndex < cards.length) {
        _speak(cards[currentCardIndex].description);
      }
    } catch (e) {
      print('Error loading saved state: $e');
    }
  }

  // Save current card index to SharedPreferences
  Future<void> _saveLastCardIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_card_index', currentCardIndex);
      await prefs.setBool('sound_enabled', isSoundEnabled);
    } catch (e) {
      print('Error saving state: $e');
    }
  }

  // Show reset dialog
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reset Progress'),
          content: Text(
            'Apakah Anda yakin ingin mengulang dari kartu pertama dan melihat tutorial lagi?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetProgress();
              },
              child: Text('Reset', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Reset progress to first card
  Future<void> _resetProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_card_index', 0);
      await prefs.setBool('tutorial_completed', false); // Reset tutorial status

      // Log untuk debugging
      print('=== RESET PROGRESS DEBUG ===');
      print('Resetting tutorial_completed to: false');
      final resetValue = prefs.getBool('tutorial_completed') ?? true;
      print('Verification - SharedPreferences value after reset: $resetValue');
      print('Navigating to: /tutorial');
      print('==========================');

      setState(() {
        currentCardIndex = 0;
      });

      // Navigate to tutorial
      Navigator.pushReplacementNamed(context, '/tutorial');

      // Speak first card if sound is enabled
      if (isSoundEnabled && cards.isNotEmpty) {
        _speak(cards[0].description);
      }

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Progress telah direset ke kartu pertama'),
          backgroundColor: ThemeColors.baseColor,
        ),
      );
    } catch (e) {
      print('Error resetting progress: $e');
    }
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
    // Save sound state
    _saveLastCardIndex();
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
                    } else if (value == 'reset') {
                      _showResetDialog();
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
                        // Save current card index
                        _saveLastCardIndex();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${currentCardIndex + 1}/${cards.length}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeColors.baseColor,
                            ),
                          ),
                          SizedBox(width: 8),
                          Tooltip(
                            message: 'Progress tersimpan otomatis',
                            child: Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
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
