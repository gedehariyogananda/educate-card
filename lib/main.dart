import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/swiper_card.dart';
import 'models/card_data.dart';
import 'widgets/flip_card.dart';
import 'utils/theme_colors.dart';
import 'screens/tutorial_screen.dart';
import 'screens/menu_screen.dart';
import 'package:flutter_math_fork/flutter_math.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoulsifyEdu',
      initialRoute: '/',
      routes: {
        // Decider: no splash, route to onboarding on first run, otherwise to menu
        '/': (context) => const _StartupDecider(),
        '/tutorial': (context) => const TutorialScreen(),
        '/menu': (context) => const MenuScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

/// Startup decider without visible splash: routes to onboarding if not completed,
/// otherwise goes directly to MenuScreen.
class _StartupDecider extends StatefulWidget {
  const _StartupDecider();

  @override
  State<_StartupDecider> createState() => _StartupDeciderState();
}

class _StartupDeciderState extends State<_StartupDecider> {
  @override
  void initState() {
    super.initState();
    _decide();
  }

  Future<void> _decide() async {
    final prefs = await SharedPreferences.getInstance();
    final tutorialCompleted = prefs.getBool('tutorial_completed') ?? false;
    if (!mounted) return;
    if (!tutorialCompleted) {
      Navigator.pushReplacementNamed(context, '/tutorial');
    } else {
      Navigator.pushReplacementNamed(context, '/menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Minimal blank container to avoid any splash visuals
    return const SizedBox.shrink();
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
    // Splash hanya tampil statis sebentar lalu masuk sesuai status tutorial
    Future.delayed(const Duration(milliseconds: 1200), _navigateNext);
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final tutorialCompleted = prefs.getBool('tutorial_completed') ?? false;
    final hasExited = prefs.getBool('has_exited_once') ?? false;
    if (!mounted) return;
    if (!tutorialCompleted) {
      Navigator.pushReplacementNamed(context, '/tutorial');
    } else if (hasExited) {
      Navigator.pushReplacementNamed(context, '/menu');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeColors.baseColor,
                ThemeColors.baseColor.withOpacity(0.85),
                const Color(0xFF90CAF9),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // dekorasi lingkaran lembut
              Positioned(
                top: -40,
                right: -40,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: -60,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),

              // "Halloo..." di pojok kiri atas (badge)
              Positioned(
                top: 20,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Halloo...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              // welcome text di tengah atas
              Align(
                alignment: const Alignment(0, -0.55),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Welcome to the application moulsify education',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white.withOpacity(0.98),
                      height: 1.3,
                    ),
                  ),
                ),
              ),

              // Logo besar di bawah tengah dengan glow
              Align(
                alignment: const Alignment(0, 0.6),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.15),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/icon_moulsify_edu.png',
                    width: 240,
                    height: 240,
                    fit: BoxFit.contain,
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<BaseDatas> cards = datas;
  bool isSoundEnabled = true;
  late FlutterTts _tts;
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

      // Delay sedikit untuk animasi countdown selesai, lalu ucapkan judul
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

      // Hint muncul via overlay animasi setelah audio pertama (jika ada)
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

  Future<void> _initTts() async {
    _tts = FlutterTts();
    try {
      await _tts.setEngine('com.google.android.tts');
    } catch (_) {}
    // Ensure speak() future completes after utterance finishes
    try {
      await _tts.awaitSpeakCompletion(true);
    } catch (_) {}
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    const String idLocale = 'id-ID';
    const String enLocale = 'en-US';
    try {
      await _tts.setLanguage(idLocale);
      final voices = await _tts.getVoices;
      if (voices is List) {
        Map<String, dynamic>? pickFemale(List list, String locale) {
          for (final v in list) {
            try {
              final m = Map<String, dynamic>.from(v as Map);
              final name = (m['name'] ?? '').toString().toLowerCase();
              final gender = (m['gender'] ?? '').toString().toLowerCase();
              final loc = (m['locale'] ?? '').toString();
              if (loc == locale &&
                  (gender == 'female' ||
                      name.contains('female') ||
                      name.contains('-f'))) {
                return m;
              }
            } catch (_) {}
          }
          for (final v in list) {
            try {
              final m = Map<String, dynamic>.from(v as Map);
              final loc = (m['locale'] ?? '').toString();
              if (loc == locale) return m;
            } catch (_) {}
          }
          return null;
        }

        final l = List.from(voices);
        final sel = pickFemale(l, idLocale) ?? pickFemale(l, enLocale);
        if (sel != null) {
          await _tts.setVoice({"name": sel['name'], "locale": sel['locale']});
          await _tts.setLanguage(sel['locale']);
        }
      }
    } catch (e) {
      debugPrint('TTS voice selection error: $e');
      await _tts.setLanguage(enLocale);
    }
  }

  Future<void> _speak(String? text) async {
    if (!isSoundEnabled || text == null || text.trim().isEmpty) return;
    try {
      await _tts.stop();
      await _speakChunked(_verbalize(text));
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  Future<void> _speakChunked(String text, {int chunkLength = 400}) async {
    final t = text.trim();
    if (t.length <= chunkLength) {
      await _tts.speak(t);
      return;
    }
    int start = 0;
    while (start < t.length) {
      final end = (start + chunkLength < t.length)
          ? start + chunkLength
          : t.length;
      final part = t.substring(start, end);
      await _tts.speak(part);
      start = end;
    }
  }

  // Convert formula symbols to Indonesian speech-friendly phrases
  String _verbalize(String text) {
    String s = text;
    // Basic math replacements
    s = s.replaceAll('Δ', 'delta ');
    s = s.replaceAll('·', ' dikali ');
    s = s.replaceAll('·', ' dikali '); // ensure mid-dot handled
    s = s.replaceAll('*', ' dikali ');
    s = s.replaceAll('/', ' dibagi ');
    s = s.replaceAll('=', ' sama dengan ');
    s = s.replaceAll('+', ' ditambah ');
    s = s.replaceAll('-', ' dikurang ');
    s = s.replaceAll('^2', ' pangkat dua ');
    s = s.replaceAll('^3', ' pangkat tiga ');
    s = s.replaceAll("v'", ' v aksen ');
    // Parentheses as words for clarity in TTS
    s = s.replaceAll('(', ' kurung buka ');
    s = s.replaceAll(')', ' kurung tutup ');
    // Units
    // Common composite units first
    s = s.replaceAll('kg·m/s', ' kilogram meter per detik ');
    s = s.replaceAll('kg.m/s', ' kilogram meter per detik ');
    s = s.replaceAll('kg m/s', ' kilogram meter per detik ');
    s = s.replaceAll('N·s', ' newton detik ');
    s = s.replaceAll('N.s', ' newton detik ');
    s = s.replaceAll('N s', ' newton detik ');
    s = s.replaceAll('Ns', ' newton detik ');
    s = s.replaceAll('kg/m', ' kilogram per meter ');
    // Parenthesized units
    s = s.replaceAll('(kg)', '(kilogram)');
    s = s.replaceAll('(m/s)', '(meter per detik)');
    s = s.replaceAll("p'", ' pe aksen ');
    s = s.replaceAll("m'", ' em aksen ');
    s = s.replaceAll("t'", ' te aksen ');

    // Read single-letter symbols naturally when they appear standalone
    s = s.replaceAll(RegExp(r'\bI\s*=\s*'), ' i sama dengan ');
    s = s.replaceAll(RegExp(r'\bF\s*=\s*'), ' ef sama dengan ');
    s = s.replaceAll(RegExp(r"\bv'\s*=\s*"), ' ve aksen sama dengan ');
    s = s.replaceAll(RegExp(r'\bv\s*=\s*'), ' ve sama dengan ');
    s = s.replaceAll(RegExp(r'\bp\s*=\s*'), ' pe sama dengan ');
    s = s.replaceAll(RegExp(r'\bm\s*=\s*'), ' em sama dengan ');
    s = s.replaceAll(RegExp(r'\bt\s*=\s*'), ' te sama dengan ');

    // Standalone letters in keterangan context
    s = s.replaceAll(RegExp(r'\bI\b'), ' i ');
    s = s.replaceAll(RegExp(r'\bF\b'), ' ef ');
    s = s.replaceAll(RegExp(r'\bp\b'), ' pe ');
    s = s.replaceAll(RegExp(r'\bm\b'), ' em ');
    s = s.replaceAll(RegExp(r"\bv'\b"), ' ve aksen ');
    s = s.replaceAll(RegExp(r'\bv\b'), ' ve ');
    s = s.replaceAll(RegExp(r'\bt\b'), ' te ');

    // "delta p" and "delta t" clarity
    s = s.replaceAll(RegExp(r'\bdelta\s*p\b'), ' delta pe ');
    s = s.replaceAll(RegExp(r'\bdelta\s*t\b'), ' delta te ');
    s = s.replaceAll('(N·s)', '(newton detik)');
    s = s.replaceAll('(Ns)', '(newton detik)');
    s = s.replaceAll('(N)', '(newton)');
    s = s.replaceAll('(m)', '(meter)');
    s = s.replaceAll('(cm)', '(sentimeter)');
    s = s.replaceAll('(mm)', '(milimeter)');
    s = s.replaceAll('(km)', '(kilometer)');
    s = s.replaceAll('(s)', '(detik)');
    // Simple standalone units by word boundary (best-effort)
    s = s.replaceAll(RegExp(r'\bkg\b'), ' kilogram ');
    s = s.replaceAll(RegExp(r'\bNs\b', caseSensitive: false), ' newton detik ');
    s = s.replaceAll('m/s', ' meter per detik ');
    // Collapse multiple spaces
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s;
  }

  // Convert simple TeX (from formulasTex) to readable Indonesian text then pass to _verbalize
  String _verbalizeTex(String tex) {
    var t = tex.trim();
    // Normalize TeX tokens
    t = t.replaceAll('\\cdot', '·');
    t = t.replaceAll('\\times', '·');
    t = t.replaceAll('\\Delta', 'Δ');
    // Remove braces commonly used in TeX
    t = t.replaceAll('{', '').replaceAll('}', '');
    // Map Δp and Δt to semantic phrases directly before symbol-level replacements
    t = t.replaceAll(RegExp(r'(Δ)\s*p'), ' perubahan momentum ');
    t = t.replaceAll(RegExp(r'(Δ)\s*t'), ' selang waktu ');
    // Clean extra spaces
    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
    return _verbalize(t);
  }

  // Sanitize/normalize TeX before rendering to avoid parser issues
  String _sanitizeTex(String tex) {
    var t = tex.trim();
    // Replace common unicode symbols with TeX commands
    t = t.replaceAll('·', r'\cdot');
    t = t.replaceAll('Δ', r'\Delta');
    // Remove surrounding $ if any
    if (t.startsWith(r'$') && t.endsWith(r'$') && t.length > 2) {
      t = t.substring(1, t.length - 1);
    }
    return t;
  }

  // Extract explanatory "keterangan" lines from description to show under formulas
  // - If description contains 'Keterangan:', take the lines after it (split by newline)
  // - Else if contains 'dengan', take the text after it (split by comma)
  // - Else return empty list
  List<String> _extractKeteranganItems(String description) {
    final d = description.trim();
    final lower = d.toLowerCase();
    final ketLabel = 'keterangan:';
    if (lower.contains(ketLabel)) {
      final start = lower.indexOf(ketLabel) + ketLabel.length;
      final after = d.substring(start).trim();
      return after
          .split(RegExp(r'\r?\n'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    final denganLabel = 'dengan';
    if (lower.contains(denganLabel)) {
      final start = lower.indexOf(denganLabel) + denganLabel.length;
      final after = d.substring(start).trim();
      return after
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return [];
  }

  void _toggleSound() {
    setState(() {
      isSoundEnabled = !isSoundEnabled;
    });
    if (!isSoundEnabled) {
      _tts.stop();
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
    final hkmCards = cards
        .where((card) => card.category == CardCategory.hkm)
        .length;
    final tumbukanCards = cards
        .where((card) => card.category == CardCategory.tumbukan)
        .length;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    ThemeColors.baseColor.withOpacity(0.05),
                  ],
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
                  SizedBox(height: 16),
                  // Scrollable content
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                          SizedBox(height: 16),
                          // Momentum Category
                          _buildCategoryItem(
                            'Momentum',
                            momentumCards,
                            cards.length,
                            Color(0xFF42A5F5), // Blue
                            Icons.speed_rounded,
                          ),
                          SizedBox(height: 12),
                          // Impuls Category
                          _buildCategoryItem(
                            'Impuls',
                            impulsCards,
                            cards.length,
                            Color(0xFF66BB6A), // Green
                            Icons.flash_on_rounded,
                          ),
                          SizedBox(height: 12),
                          // Hukum Kekekalan Momentum Category
                          _buildCategoryItem(
                            'Kekekalan Momentum',
                            hkmCards,
                            cards.length,
                            Color(0xFF7E57C2), // Deep Purple
                            Icons.compare_arrows_rounded,
                          ),
                          SizedBox(height: 12),
                          // Tumbukan Category
                          _buildCategoryItem(
                            'Tumbukan',
                            tumbukanCards,
                            cards.length,
                            Color(0xFFFB8C00), // Orange
                            Icons.sports_martial_arts_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
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
    double percentage = total > 0 ? (count / total * 100) : 0;

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
                widthFactor: total > 0 ? (count / total) : 0,
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
    try {
      _tts.stop();
    } catch (_) {}
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
                            'MoulsifyEdu',
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
                              // Speak the front title when a new card becomes active
                              _speak(cards[index].title);
                            }
                            _saveLastCardIndex();
                          },
                          onAllCardsCompleted: () async {},
                          cardBuilder: (context, index, visibleIndex) {
                            final BaseDatas card = cards[index];
                            // Certain titles should show description before formulas on the back side
                            final bool showDescFirst =
                                card.title == '-' || card.title == '-';
                            return FlipCard(
                              onFlippedToBack: () async {
                                // Always read formulas first, then keterangan (and fallback to deskripsi jika tidak ada keterangan)
                                await _tts.stop();
                                final texList = card.formulasTex ?? const [];
                                final soundFormulas =
                                    card.soundFormulas ?? const [];
                                final soundKeterangan =
                                    card.soundKeterangan ?? const [];
                                final hasAnyFormula =
                                    texList.isNotEmpty ||
                                    soundFormulas.isNotEmpty;

                                final buffer = StringBuffer();
                                if (hasAnyFormula) {
                                  final formulasSpeech =
                                      soundFormulas.isNotEmpty
                                      ? soundFormulas.join('. ')
                                      : texList
                                            .map((f) => _verbalizeTex(f))
                                            .join('. ');
                                  // Rumus selalu duluan
                                  buffer.write('Persamaan : ');
                                  buffer.write(formulasSpeech);
                                  // Keterangan setelah rumus
                                  if (soundKeterangan.isNotEmpty) {
                                    buffer.write('. Keterangan: ');
                                    buffer.write(soundKeterangan.join('. '));
                                  } else {
                                    final items = _extractKeteranganItems(
                                      card.description,
                                    );
                                    if (items.isNotEmpty) {
                                      buffer.write('. Keterangan: ');
                                      buffer.write(
                                        items.map(_verbalize).join('. '),
                                      );
                                    } else {
                                      // Jika tidak ada keterangan, fallback baca deskripsi ringkas
                                      buffer.write('. ');
                                      buffer.write(
                                        _verbalize(card.description),
                                      );
                                    }
                                  }
                                } else {
                                  // Tanpa rumus, baca deskripsi
                                  buffer.write(_verbalize(card.description));
                                }
                                await _speakChunked(buffer.toString());
                              },
                              onFlippedToFront: () async {
                                // Return to front: speak front title again
                                await _tts.stop();
                                await _speak(card.title);
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
                                          color: () {
                                            switch (card.category) {
                                              case CardCategory.momentum:
                                                return const Color(
                                                  0xFF42A5F5,
                                                ); // Blue
                                              case CardCategory.impuls:
                                                return const Color(
                                                  0xFF66BB6A,
                                                ); // Green
                                              case CardCategory.hkm:
                                                return const Color(
                                                  0xFF7E57C2,
                                                ); // Deep Purple
                                              case CardCategory.tumbukan:
                                                return const Color(
                                                  0xFFFB8C00,
                                                ); // Orange
                                            }
                                          }(),
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
                                            constraints: BoxConstraints(
                                              // Limit width so long titles wrap nicely inside the card
                                              maxWidth: 260,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
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
                                            child: Center(
                                              child: Text(
                                                card.title,
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: ThemeColors.baseColor,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
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
                                          // Removed front-side formula preview per request; formulas shown on back below description only
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if ((card.formulasTex ?? [])
                                                    .isNotEmpty) ...[
                                                  if (showDescFirst) ...[
                                                    // Show description first
                                                    Text(
                                                      card.description,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 1.5,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    const SizedBox(height: 12),
                                                    // Then show formulas section
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 8,
                                                          ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                0.14,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.25,
                                                                ),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Persamaan :',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ...card.formulasTex!.map(
                                                      (f) => Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              bottom: 12,
                                                            ),
                                                        child: Math.tex(
                                                          _sanitizeTex(f),
                                                          mathStyle:
                                                              MathStyle.display,
                                                          textStyle:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                              ),
                                                          onErrorFallback:
                                                              (err) => Text(
                                                                f,
                                                                style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ] else ...[
                                                    // Original order: formulas first, then description/keterangan
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 8,
                                                          ),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                0.14,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.25,
                                                                ),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          'Persamaan :',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ...card.formulasTex!.map(
                                                      (f) => Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              bottom: 12,
                                                            ),
                                                        child: Math.tex(
                                                          _sanitizeTex(f),
                                                          mathStyle:
                                                              MathStyle.display,
                                                          textStyle:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                              ),
                                                          onErrorFallback:
                                                              (err) => Text(
                                                                f,
                                                                style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    if (_extractKeteranganItems(
                                                      card.description,
                                                    ).isNotEmpty) ...[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              12,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(
                                                                0.10,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          border: Border.all(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                  0.22,
                                                                ),
                                                            width: 1,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Keterangan:',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 6,
                                                            ),
                                                            ..._extractKeteranganItems(
                                                              card.description,
                                                            ).map(
                                                              (item) => Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                      bottom: 6,
                                                                    ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      margin:
                                                                          const EdgeInsets.only(
                                                                            top:
                                                                                6,
                                                                          ),
                                                                      width: 6,
                                                                      height: 6,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 8,
                                                                    ),
                                                                    Expanded(
                                                                      child: Text(
                                                                        item,
                                                                        style: const TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              14,
                                                                          height:
                                                                              1.4,
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
                                                    ] else ...[
                                                      // Fallback to raw description when no clear keterangan found
                                                      Text(
                                                        card.description,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          height: 1.5,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ],
                                                  ],
                                                ] else ...[
                                                  // No formulas: show description as-is
                                                  Text(
                                                    card.description,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      height: 1.5,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ],
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
