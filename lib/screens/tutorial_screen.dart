import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/theme_colors.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: [
        PageViewModel(
          title: "Selamat Datang di MoulsivyEdu! 🎓",
          body:
              "Aplikasi pembelajaran interaktif dengan kartu edukasi yang menyenangkan dan mudah dipahami.",
          image: _buildImageWithLogo(context),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: "Kontrol Suara 🔊",
          body:
              "Tekan tombol speaker di kanan atas untuk menghidupkan atau mematikan suara. Suara akan membantu Anda mendengar penjelasan setiap kartu.",
          image: _buildImage('🔊', Colors.orange),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: "Navigasi Kartu ⬆️⬇️",
          body:
              "• Swipe ke ATAS untuk melanjutkan ke kartu pembelajaran berikutnya\n• Swipe ke BAWAH untuk kembali ke kartu sebelumnya (undo)",
          image: _buildImage('👆', Colors.blue),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: "Flip Kartu 🔄",
          body:
              "Ketuk kartu untuk membalik dan melihat pertanyaan serta jawaban di bagian belakang kartu.",
          image: _buildImage('🔄', Colors.purple),
          decoration: _getPageDecoration(),
        ),
        PageViewModel(
          title: "Siap Belajar! 🚀",
          body:
              "Sekarang Anda sudah siap untuk memulai pembelajaran. Mari kita mulai petualangan belajar yang seru!",
          image: _buildImage('🚀', Colors.green),
          decoration: _getPageDecoration(),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Lewati',
          style: TextStyle(
            color: ThemeColors.baseColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      next: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: ThemeColors.baseColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.arrow_forward, color: Colors.white),
      ),
      done: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeColors.baseColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: ThemeColors.baseColor.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          'Mulai',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey.shade300,
        activeSize: Size(22.0, 10.0),
        activeColor: ThemeColors.baseColor,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  Widget _buildImageWithLogo(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: ThemeColors.baseColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: ThemeColors.baseColor.withOpacity(0.2),
                width: 3,
              ),
            ),
            child: SvgPicture.asset(
              'assets/logo_flashcard.svg',
              width: 100,
              height: 100,
            ),
          ),
          SizedBox(height: 16),
          Text('🎯', style: TextStyle(fontSize: 50)),
        ],
      ),
    );
  }

  Widget _buildImage(String emoji, Color color) {
    return Container(
      padding: EdgeInsets.all(35),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Text(emoji, style: TextStyle(fontSize: 85)),
    );
  }

  PageDecoration _getPageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
        color: ThemeColors.baseColor,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18.0,
        color: Colors.grey.shade700,
        height: 1.5,
      ),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
  }

  void _onIntroEnd(BuildContext context) async {
    // Save tutorial completed status to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_completed', true);

    // Log untuk debugging
    print('=== TUTORIAL SCREEN DEBUG ===');
    print('Tutorial completed, saving to SharedPreferences: true');
    final saved = prefs.getBool('tutorial_completed') ?? false;
    print('Verification - SharedPreferences value: $saved');
    print('Navigating to: /home (first time after onboarding)');
    print('===========================');

    // Navigate langsung ke home screen (pertama kali setelah onboarding)
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
