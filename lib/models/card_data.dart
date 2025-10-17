enum CardCategory { momentum, impuls }

class BaseDatas {
  final String title;
  final String imageUrl;
  final String description;
  final CardCategory category;

  BaseDatas({
    required this.title,
    required this.imageUrl,
    required this.description,
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
    title: 'Pengertian Momentum',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.momentum,
    description: 'Momentum adalah kelembaman atau inersia benda dalam gerak.',
  ),
  BaseDatas(
    title: 'Sifat Momentum',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.momentum,
    description:
        'Semakin mudah benda itu dihentikan dari geraknya maka semakin kecil momentumnya dan sebaliknya.',
  ),
  BaseDatas(
    title: 'Rumus Momentum',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.momentum,
    description:
        'p = m * v dengan p = momentum (kg/m atau Ns), m = massa (kg), v = kecepatan (m/s)',
  ),
  BaseDatas(
    title: 'Contoh Sehari-hari',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.momentum,
    description:
        'Truk yang lebih berat memiliki momentum lebih besar daripada mobil kecil dengan kecepatan sama.',
  ),
  BaseDatas(
    title: 'Contoh Sehari-hari',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.momentum,
    description:
        'Pemain karate memukul tumpukan ubin dengan tangan cepat untuk menghasilkan gaya besar.',
  ),
  BaseDatas(
    title: 'Contoh Sehari-hari',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.momentum,
    description:
        'Peluncuran roket dimana ketika gas dan bahan bakar dikeluarkan dengan kecepatan tinggi ke belakang, roket akan terdorong ke depan dengan momentum yang sama besarnya tetapi berlawanan arah',
  ),
  BaseDatas(
    title: 'Contoh Sehari-hari',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.momentum,
    description:
        'Permainan biliar di mana bola yang bergerak akan memantul dari bola lain.',
  ),
  BaseDatas(
    title: 'Pengertian Impuls',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.impuls,
    description: 'Impuls adalah perubahan dari momentum.',
  ),
  BaseDatas(
    title: 'Rumus Impuls',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.impuls,
    description:
        'I = p\nI = m(v\' - v)\nI = F · Δt\n\nKeterangan:\nI = impuls (N·s)\np = perubahan momentum\nt = selang waktu (s)\nm = massa (kg)\nv\' = kecepatan akhir (m/s)\nv = kecepatan awal (m/s)\nF = gaya (N)',
  ),
  BaseDatas(
    title: 'Contoh Sehari-hari',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.impuls,
    description:
        'Menendang bola\n\nSaat kaki menendang bola, gaya besar bekerja dalam waktu singkat sehingga bola mengalami perubahan momentum dan bergerak cepat ke depan.',
  ),
  BaseDatas(
    title: 'Contoh Sehari-hari',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.impuls,
    description:
        'Pemukul memukul bola baseball\n\nKetika pemukul mengenai bola, gaya besar diberikan dalam waktu singkat. Impuls yang besar membuat bola terpental jauh dengan kecepatan tinggi.',
  ),
  BaseDatas(
    title: 'Contoh Sehari-hari',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.impuls,
    description:
        'Menangkap bola dengan tangan\n\nPenangkap memperlambat bola secara bertahap (memperpanjang waktu tumbukan) agar gaya yang dirasakan tangan lebih kecil.',
  ),
  BaseDatas(
    title: 'Contoh Sehari-hari',
    imageUrl: 'assets/resources/gambar-momentum.png',
    category: CardCategory.impuls,
    description:
        'Bola basket memantul di lantai\n\nGaya dari lantai mengubah arah dan kecepatan bola, menunjukkan perubahan momentum akibat impuls dari lantai.',
  ),
];
