import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/swiper_card.dart';
import 'models/card_data.dart';
import 'widgets/flip_card.dart';
import 'utils/theme_colors.dart';
import 'screens/tutorial_screen.dart';
import 'screens/menu_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoulsivyEdu',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/tutorial': (context) => const TutorialScreen(),
        '/menu': (context) => const MenuScreen(),
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
    final hasExited = prefs.getBool('has_exited_once') ?? false;

    if (mounted) {
      if (!tutorialCompleted) {
        // Belum onboarding -> ke tutorial
        Navigator.pushReplacementNamed(context, '/tutorial');
      } else if (hasExited) {
        // Sudah pernah exit -> ke menu
        Navigator.pushReplacementNamed(context, '/menu');
      } else {
        // Baru selesai onboarding, belum pernah exit -> langsung ke home
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeColors.baseColor,
              ThemeColors.baseColor.withOpacity(0.8),
              Color(0xFFBBDEFB), // Light Blue
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo container with SVG
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Transform.rotate(
                        angle: (1 - value) * 0.5,
                        child: Container(
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 25,
                                offset: Offset(0, 10),
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: SvgPicture.asset(
                            'assets/logo_flashcard.svg',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 32),
                // App name with animation
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 1100),
                  curve: Curves.easeOutCubic,
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 25 * (1 - value)),
                        child: Column(
                          children: [
                            Text(
                              'MoulsivyEdu',
                              style: TextStyle(
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: Offset(0, 3),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'Belajar Jadi Menyenangkan',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 36,
                                vertical: 4,
                              ),
                              child: Text(
                                'Aplikasi pembelajaran interaktif dengan kartu edukasi yang menyenangkan dan mudah dipahami',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.95),
                                  letterSpacing: 0.3,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 48),
                // Loading indicator with pulse animation
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 1300),
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulsing circle background
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0.8, end: 1.2),
                                duration: Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                                builder: (context, double scale, child) {
                                  return Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                    ),
                                  );
                                },
                                onEnd: () {
                                  // Loop the animation
                                },
                              ),
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 3.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Memuat pembelajaran...',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.92),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<BaseDatas> cards = datas;
  bool isSoundEnabled = true;
  late FlutterTts flutterTts;
  int currentCardIndex = 0;
  BuildContext? _showcaseContext;
  bool _swipeHintShown = false; // show once per app launch
  bool _showSwipeHintOverlay = false; // animated hint overlay visibility
  late AnimationController _hintController;
  late Animation<Offset> _hintSlide;

  final GlobalKey _soundButtonKey = GlobalKey();
  final GlobalKey _menuButtonKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();
  final GlobalKey _progressKey = GlobalKey();
  final GlobalKey _instructionButtonKey = GlobalKey();

  void _showInstructionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, ThemeColors.baseColor.withOpacity(0.05)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ThemeColors.baseColor,
                            ThemeColors.baseColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cara Penggunaan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey.shade600),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Instructions
                _buildInstructionItem(
                  Icons.swipe_left,
                  'Swipe Kiri ←',
                  'Balik kartu untuk melihat deskripsi pembelajaran',
                  Color(0xFF3F51B5), // Indigo instead of pink
                ),
                SizedBox(height: 16),
                _buildInstructionItem(
                  Icons.swipe_right,
                  'Swipe Kanan →',
                  'Pindah ke kartu sebelumnya',
                  Color(0xFF2196F3), // Blue
                ),
                SizedBox(height: 16),
                _buildInstructionItem(
                  Icons.swipe_up,
                  'Swipe Atas ↑',
                  'Pindah ke kartu berikutnya',
                  Color(0xFF66BB6A), // Green - keep as is
                ),
                SizedBox(height: 16),
                _buildInstructionItem(
                  Icons.swipe_down,
                  'Swipe Bawah ↓',
                  'Kembali ke kartu sebelumnya',
                  Color(0xFFFF9800), // Orange - keep as is
                ),
                SizedBox(height: 20),

                // Close button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.baseColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Mengerti',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructionItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initTts();
    // Initialize hint animation controller and slide tween
    _hintController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _hintSlide = Tween<Offset>(begin: Offset.zero, end: const Offset(-0.08, 0))
        .animate(
          CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
        );
    _loadLastCardIndex();
    _setHasOpenedApp(); // Set flag bahwa user sudah pernah masuk home
  }

  Future<void> _setHasOpenedApp() async {
    // Set flag bahwa user sudah pernah buka aplikasi (masuk ke home page)
    // Sehingga next time akan muncul menu screen
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_exited_once', true);
  }

  Future<void> _loadLastCardIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIndex = prefs.getInt('last_card_index') ?? 0;
      final savedSoundState = prefs.getBool('sound_enabled') ?? true;
      final tutorialStatus = prefs.getBool('tutorial_completed') ?? false;
      final showcaseShown = prefs.getBool('showcase_shown') ?? false;

      setState(() {
        currentCardIndex = savedIndex.clamp(0, cards.length - 1);
        isSoundEnabled = savedSoundState;
      });

      // Delay sedikit untuk animasi countdown selesai, baru speak
      await Future.delayed(Duration(milliseconds: 500));

      if (currentCardIndex < cards.length) {
        if (isSoundEnabled) {
          await _speak(cards[currentCardIndex].title);
        }
        _triggerSwipeHintOverlay();
      }

      if (!showcaseShown && tutorialStatus) {
        Future.delayed(Duration(milliseconds: 1000), () {
          _startShowcase();
          prefs.setBool('showcase_shown', true);
        });
      }

      // Hint now shown via animated overlay after initial title TTS completes
    } catch (e) {
      print('Error loading saved state: $e');
    }
  }

  void _triggerSwipeHintOverlay() {
    if (_swipeHintShown) return;
    _swipeHintShown = true;
    setState(() => _showSwipeHintOverlay = true);
    // Subtle slide animation
    _hintController.repeat(reverse: true);
    // Auto-hide after a few seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() => _showSwipeHintOverlay = false);
      _hintController.stop();
      _hintController.reset();
    });
  }

  Future<void> _saveLastCardIndex() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_card_index', currentCardIndex);
      await prefs.setBool('sound_enabled', isSoundEnabled);
    } catch (e) {
      print('Error saving state: $e');
    }
  }

  void _startShowcase() {
    if (_showcaseContext != null) {
      ShowCaseWidget.of(_showcaseContext!).startShowCase([
        _instructionButtonKey,
        _soundButtonKey,
        _cardKey,
        _progressKey,
        _menuButtonKey,
      ]);
    }
  }

  void _initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("id-ID");
    flutterTts.setSpeechRate(0.42); // Lebih lambat dari 0.5 agar lebih jelas
    flutterTts.setPitch(
      0.95,
    ); // Sedikit lebih rendah agar terdengar lebih natural
    flutterTts.setVolume(1.0); // Volume penuh
    flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _speak(String text) async {
    if (isSoundEnabled && text.isNotEmpty) {
      // Stop any ongoing speech first for a clean start
      try {
        await flutterTts.stop();
        await Future.delayed(Duration(milliseconds: 100));
      } catch (_) {}
      // Bersihkan karakter khusus yang bisa membuat TTS bingung
      String cleanedText = text
          .replaceAll('×', 'kali')
          .replaceAll('/', ' per ')
          .replaceAll('·', ' ')
          .replaceAll('\n\n', '. '); // Ganti baris baru dengan jeda

      await flutterTts.speak(cleanedText);
    }
  }

  void _toggleSound() {
    setState(() {
      isSoundEnabled = !isSoundEnabled;
    });
    if (!isSoundEnabled) {
      flutterTts.stop();
    }
    _saveLastCardIndex();
  }

  void _showCategoryStats() {
    final momentumCards = cards
        .where((card) => card.category == CardCategory.momentum)
        .length;
    final impulsCards = cards
        .where((card) => card.category == CardCategory.impuls)
        .length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, ThemeColors.baseColor.withOpacity(0.05)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ThemeColors.baseColor,
                            ThemeColors.baseColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.category_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Statistik Kategori',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey.shade600),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // Total Cards
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeColors.baseColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ThemeColors.baseColor.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dashboard_rounded,
                        color: ThemeColors.baseColor,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Total: ${cards.length} Kartu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.baseColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Momentum Category
                _buildCategoryItem(
                  'Momentum',
                  momentumCards,
                  cards.length,
                  Color(0xFF42A5F5), // Blue
                  Icons.speed_rounded,
                ),
                SizedBox(height: 16),
                // Impuls Category
                _buildCategoryItem(
                  'Impuls',
                  impulsCards,
                  cards.length,
                  Color(0xFF66BB6A), // Green
                  Icons.flash_on_rounded,
                ),
                SizedBox(height: 24),
                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.baseColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(
    String categoryName,
    int count,
    int total,
    Color color,
    IconData icon,
  ) {
    double percentage = (count / total * 100);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$count dari $total kartu (${percentage.toStringAsFixed(0)}%)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Progress Bar
          Container(
            width: double.infinity,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: count / total,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    try {
      _hintController.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (showcaseContext) {
        _showcaseContext = showcaseContext;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ThemeColors.baseColor,
                    ThemeColors.baseColor.withOpacity(0.85),
                    Color(0xFF5C6BC0), // Light Indigo
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThemeColors.baseColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                    spreadRadius: 0,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title Section
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MoulsivyEdu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Momentum & Impuls',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Action Buttons
                      Row(
                        children: [
                          // Instruction button
                          Showcase(
                            key: _instructionButtonKey,
                            title: 'Panduan Interaksi',
                            description:
                                'Ketuk untuk melihat cara berinteraksi dengan kartu - swipe, tap, dan navigasi',
                            titleTextStyle: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            descTextStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            targetBorderRadius: BorderRadius.circular(25),
                            child: Container(
                              margin: EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: _showInstructionDialog,
                                icon: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                tooltip: 'Cara Penggunaan',
                              ),
                            ),
                          ),
                          Showcase(
                            key: _soundButtonKey,
                            title: 'Kontrol Suara',
                            description:
                                'Tekan untuk menghidupkan atau mematikan suara narasi',
                            titleTextStyle: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            descTextStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            targetBorderRadius: BorderRadius.circular(25),
                            child: Container(
                              margin: EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: _toggleSound,
                                icon: Icon(
                                  isSoundEnabled
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                tooltip: isSoundEnabled
                                    ? 'Matikan Suara'
                                    : 'Nyalakan Suara',
                              ),
                            ),
                          ),
                          Showcase(
                            key: _menuButtonKey,
                            title: 'Tips Penggunaan',
                            titleTextStyle: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            description:
                                'Tekan untuk melihat tips penggunaan aplikasi',
                            targetBorderRadius: BorderRadius.circular(25),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.tips_and_updates,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                tooltip: 'Tips Penggunaan',
                                onPressed: _startShowcase,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Expanded(
                    child: Center(
                      child: Showcase(
                        key: _cardKey,
                        title: 'Kartu Pembelajaran',
                        description:
                            'Ketuk kartu untuk membalik, swipe kiri untuk balik, swipe atas/bawah untuk navigasi',
                        titleTextStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        descTextStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        targetBorderRadius: BorderRadius.circular(10),
                        child: CardsSwiperWidget<BaseDatas>(
                          cardData: cards,
                          initialIndex: currentCardIndex,
                          onCardChange: (index) {
                            setState(() {
                              currentCardIndex = index;
                            });
                            if (index >= 0 && index < cards.length) {
                              // Speak the title when a new front card becomes active
                              _speak(cards[index].title);
                            }
                            _saveLastCardIndex();
                          },
                          onAllCardsCompleted: () async {
                            // Trigger saat user swipe up di kartu terakhir
                            print('🎉 onAllCardsCompleted DIPANGGIL!');
                            print('Sound enabled: $isSoundEnabled');
                            if (isSoundEnabled) {
                              print('Mencoba memutar sound...');
                              // STOP dulu TTS yang sedang berjalan
                              await flutterTts.stop();
                              // Delay sedikit untuk memastikan TTS berhenti
                              await Future.delayed(Duration(milliseconds: 300));
                              // Putar sound celebration
                              await flutterTts.speak(
                                "Luar biasa! Anda telah menyelesaikan semua kartu pembelajaran!",
                              );
                            }
                          },
                          cardBuilder: (context, index, visibleIndex) {
                            final BaseDatas card = cards[index];
                            return FlipCard(
                              onFlippedToBack: () async {
                                if (isSoundEnabled) {
                                  await flutterTts.stop();
                                  await Future.delayed(
                                    Duration(milliseconds: 100),
                                  );
                                  _speak(card.description);
                                }
                              },
                              onFlippedToFront: () async {
                                // Optional: stop speaking when returning to front
                                if (isSoundEnabled) {
                                  await flutterTts.stop();
                                }
                              },
                              front: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      ThemeColors.baseColor,
                                      ThemeColors.baseColor.withOpacity(0.8),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ThemeColors.baseColor.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 15,
                                      offset: Offset(0, 8),
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                width: 300,
                                height: 400,
                                child: Stack(
                                  children: [
                                    // Background decoration
                                    Positioned(
                                      top: -30,
                                      right: -30,
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -40,
                                      left: -40,
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.05),
                                        ),
                                      ),
                                    ),
                                    // Category Badge (pojok kanan atas)
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              card.category ==
                                                  CardCategory.momentum
                                              ? Color(
                                                  0xFF42A5F5,
                                                ) // Blue for Momentum
                                              : Color(
                                                  0xFF66BB6A,
                                                ), // Green for Impuls
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          card.categoryName,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Main content - Centered
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Title di atas image
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.15),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.stars_rounded,
                                                  color: ThemeColors.baseColor,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  card.title,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ThemeColors.baseColor,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          // Image container (no tap action)
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child:
                                                  card.imageUrl.startsWith(
                                                    'http',
                                                  )
                                                  ? Image.network(
                                                      card.imageUrl,
                                                      height: 150,
                                                      width: 200,
                                                      fit: BoxFit.contain,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              height: 150,
                                                              width: 200,
                                                              color: Colors
                                                                  .grey
                                                                  .shade200,
                                                              child: Icon(
                                                                Icons
                                                                    .image_not_supported,
                                                                size: 50,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                            );
                                                          },
                                                    )
                                                  : Image.asset(
                                                      card.imageUrl,
                                                      height: 150,
                                                      width: 200,
                                                      fit: BoxFit.contain,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              height: 150,
                                                              width: 200,
                                                              color: Colors
                                                                  .grey
                                                                  .shade200,
                                                              child: Icon(
                                                                Icons
                                                                    .image_not_supported,
                                                                size: 50,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                            );
                                                          },
                                                    ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              back: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      ThemeColors.baseColor.withOpacity(0.9),
                                      ThemeColors.baseColor,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ThemeColors.baseColor.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 15,
                                      offset: Offset(0, 8),
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                width: 300,
                                height: 400,
                                child: Stack(
                                  children: [
                                    // Background decoration
                                    Positioned(
                                      top: -30,
                                      left: -30,
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -40,
                                      right: -40,
                                      child: Container(
                                        width: 150,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.05),
                                        ),
                                      ),
                                    ),
                                    // Full description content
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(24),
                                        child: Container(
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                              0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.25,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Text(
                                              card.description,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                height: 1.5,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ); // Close FlipCard
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
                    titleTextStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    descTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    targetBorderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: _showCategoryStats,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: ThemeColors.baseColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.analytics_outlined,
                                        size: 20,
                                        color: ThemeColors.baseColor,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Progress Belajar',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '${currentCardIndex + 1} dari ${cards.length} Kartu',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ThemeColors.baseColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ThemeColors.baseColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${((currentCardIndex + 1) / cards.length * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Stack(
                                  children: [
                                    FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor:
                                          (currentCardIndex + 1) / cards.length,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              ThemeColors.baseColor,
                                              ThemeColors.baseColor.withOpacity(
                                                0.7,
                                              ),
                                            ],
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
                      ), // Close Container
                    ), // Close GestureDetector
                  ), // Close Showcase
                  SizedBox(height: 20),
                ],
              ),
              if (_showSwipeHintOverlay)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 28,
                  child: IgnorePointer(
                    ignoring: true,
                    child: Center(
                      child: SlideTransition(
                        position: _hintSlide,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.swipe_left, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Geser ke kiri untuk lihat deskripsi',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
