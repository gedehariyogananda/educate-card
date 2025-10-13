enum CardCategory { momentum, impuls }

class BaseDatas {
  final String title;
  final String imageUrl;
  final String description;
  final String question;
  final String answer;
  final CardCategory category;

  BaseDatas({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.question,
    required this.answer,
    required this.category,
  });

  String get categoryName {
    switch (category) {
      case CardCategory.momentum:
        return 'Momentum';
      case CardCategory.impuls:
        return 'Impuls';
    }
  }
}

final List<BaseDatas> datas = [
  BaseDatas(
    title: 'Momentum',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.momentum,
    description:
        '1. Momentum adalah kelembaman atau inersia benda dalam gerak, juga dapat diartikan sebagai ukuran mudah atau sulitnya benda dihentikan. Semakin mudah benda itu dihentikan dari geraknya maka semakin kecil momentumnya dan sebaliknya.\n\n'
        '2. p = m × v dengan p = momentum (kg m per s atau Ns), m = massa (kg), v = kecepatan (m per s)\n\n'
        '3. Contoh dalam kehidupan sehari-hari: truk yang lebih berat memiliki momentum lebih besar daripada mobil kecil dengan kecepatan sama, pemain karate memukul tumpukan ubin dengan tangan cepat untuk menghasilkan gaya besar, peluncuran roket dimana ketika gas dan bahan bakar dikeluarkan dengan kecepatan tinggi ke belakang, roket akan terdorong ke depan dengan momentum yang sama besarnya tetapi berlawanan arah, serta permainan biliar di mana bola yang bergerak akan memantul dari bola lain.',
    question: 'Apa rumus momentum?',
    answer:
        'p = m × v, dimana p adalah momentum (kg·m/s atau Ns), m adalah massa (kg), dan v adalah kecepatan (m/s)',
  ),
  BaseDatas(
    title: 'Impuls',
    imageUrl: 'https://picsum.photos/300/200?random=1',
    category: CardCategory.impuls,
    description:
        'Impuls adalah perubahan momentum yang dialami oleh suatu benda. Impuls sama dengan gaya dikali waktu.',
    question: 'Apa rumus impuls?',
    answer: 'I = F × Δt atau I = Δp',
  ),
  BaseDatas(
    title: 'Momentum Linear',
    imageUrl: 'https://picsum.photos/300/200?random=2',
    category: CardCategory.momentum,
    description:
        'Momentum linear adalah hasil kali massa dengan kecepatan benda.',
    question: 'Satuan momentum adalah?',
    answer: 'kg·m/s atau N·s',
  ),
  BaseDatas(
    title: 'Hukum Kekekalan Momentum',
    imageUrl: 'https://picsum.photos/300/200?random=3',
    category: CardCategory.momentum,
    description:
        'Momentum total sistem tertutup sebelum dan sesudah tumbukan adalah sama.',
    question: 'Apa bunyi hukum kekekalan momentum?',
    answer: 'Momentum total sebelum = Momentum total sesudah',
  ),
  BaseDatas(
    title: 'Impuls Gaya',
    imageUrl: 'https://picsum.photos/300/200?random=4',
    category: CardCategory.impuls,
    description:
        'Impuls adalah hasil kali gaya dengan selang waktu gaya bekerja.',
    question: 'Satuan impuls adalah?',
    answer: 'N·s (Newton sekon)',
  ),
  BaseDatas(
    title: 'Tumbukan',
    imageUrl: 'https://picsum.photos/300/200?random=5',
    category: CardCategory.momentum,
    description:
        'Tumbukan dapat bersifat elastis, tidak elastis, atau sebagian elastis.',
    question: 'Sebutkan jenis-jenis tumbukan!',
    answer: 'Elastis sempurna, tidak elastis, dan sebagian elastis',
  ),
];
