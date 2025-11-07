enum CardCategory { momentum, impuls, hkm, tumbukan  }

class BaseDatas {
  final String title;
  final String imageUrl;
  final String description;
  final CardCategory category;
  // Optional audio asset paths for front (title/intro) and back (description)
  final String? audioFrontAsset;
  final String? audioBackAsset;
  // Optional TeX formulas to render nicely with LaTeX
  final List<String>? formulasTex;
  // Optional custom TTS phrases: override how formulas and keterangan are spoken
  final List<String>?
  soundFormulas; // e.g., ["impuls sama dengan perubahan momentum", ...]
  final List<String>?
  soundKeterangan; // e.g., ["impuls dalam satuan newton detik", ...]

  BaseDatas({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.category,
    this.audioFrontAsset,
    this.audioBackAsset,
    this.formulasTex,
    this.soundFormulas,
    this.soundKeterangan,
  });

  String get categoryName {
    switch (category) {
      case CardCategory.momentum:
        return 'Momentum';
      case CardCategory.impuls:
        return 'Impuls';
      case CardCategory.hkm:
        return 'Hukum Kekekalan Momentum';
      case CardCategory.tumbukan:
        return 'Tumbukan';
    }
  }
}

final List<BaseDatas> datas = [
  BaseDatas(
    title: 'Pengertian Momentum',
    imageUrl: 'assets/resources/pengertian-momen.png',
    category: CardCategory.momentum,
    description: 'Momentum adalah kelembaman atau inersia benda dalam gerak.',
    audioFrontAsset: 'audio/pengertian-impuls.aac',
    // audioBackAsset: 'audio/momentum_pengertian_back.mp3',
  ),
  BaseDatas(
    title: 'Sifat Momentum',
    imageUrl: 'assets/resources/sifat-momentum.png',
    category: CardCategory.momentum,
    description:
        'Semakin mudah benda itu dihentikan dari geraknya maka semakin kecil momentumnya dan sebaliknya.',
    // audioFrontAsset: 'audio/momentum_sifat_front.mp3',
    // audioBackAsset: 'audio/momentum_sifat_back.mp3',
  ),
  BaseDatas(
    title: 'Persamaan Momentum',
    imageUrl: 'assets/resources/rumus-momentum.png',
    category: CardCategory.momentum,
    description:
        'p = m * v dengan p = momentum (kg/m atau Ns), m = massa (kg), v = kecepatan (m/s)',
    formulasTex: [r"p = m \cdot v"],
    soundFormulas: ['momentum sama dengan massa dikali kecepatan'],
    soundKeterangan: [
      'pe sama dengan momentum dalam kilogram per meter atau newton detik',
      'm sama dengan massa dalam kilogram',
      've sama dengan kecepatan dalam meter per detik',
    ],
    // audioFrontAsset: 'audio/momentum_rumus_front.mp3',
    // audioBackAsset: 'audio/momentum_rumus_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Sehari hari',
    imageUrl: 'assets/resources/contoh1-momentum.png',
    category: CardCategory.momentum,
    description:
        'Truk yang lebih berat memiliki momentum lebih besar daripada mobil kecil dengan kecepatan sama.',
    // audioFrontAsset: 'audio/momentum_contoh1_front.mp3',
    // audioBackAsset: 'audio/momentum_contoh1_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Sehari hari',
    imageUrl: 'assets/resources/contoh2-momentum.png',
    category: CardCategory.momentum,
    description:
        'Pemain karate memukul tumpukan ubin dengan tangan cepat untuk menghasilkan gaya besar.',
    // audioFrontAsset: 'audio/momentum_contoh2_front.mp3',
    // audioBackAsset: 'audio/momentum_contoh2_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Sehari hari',
    imageUrl: 'assets/resources/contoh3-momentum.png',
    category: CardCategory.momentum,
    description:
        'Peluncuran roket dimana ketika gas dan bahan bakar dikeluarkan dengan kecepatan tinggi ke belakang, roket akan terdorong ke depan dengan momentum yang sama besarnya tetapi berlawanan arah',
    // audioFrontAsset: 'audio/momentum_contoh3_front.mp3',
    // audioBackAsset: 'audio/momentum_contoh3_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Sehari hari',
    imageUrl: 'assets/resources/contoh4-momentum.png',
    category: CardCategory.momentum,
    description:
        'Permainan biliar di mana bola yang bergerak akan memantul dari bola lain.',
    // audioFrontAsset: 'audio/momentum_contoh4_front.mp3',
    // audioBackAsset: 'audio/momentum_contoh4_back.mp3',
  ),
  BaseDatas(
    title: 'Pengertian Impuls',
    imageUrl: 'assets/resources/pengertian-impuls.png',
    category: CardCategory.impuls,
    description: 'Impuls adalah perubahan dari momentum.',
    audioFrontAsset: 'audio/pengertian-impuls.aac',
    // audioBackAsset: 'audio/impuls_pengertian_back.mp3',
  ),
  BaseDatas(
    title: 'Persamaan Impuls',
    imageUrl: 'assets/resources/rumus-impuls.png',
    category: CardCategory.impuls,
    description: """
I=Δp
I=m(v'-v)
I=F·Δt
F·Δt=m(v'-v)

Keterangan:
I=impuls (Ns)
Δp=perubahan momentum (kg.m/s)
Δt=selang waktu (s)
m=massa benda (kg)
v'=kecepatan akhir (m/s)
v=kecepatan awal (m/s)
F=gaya (N)
""",
    formulasTex: [
      r"I = \Delta p",
      r"I = m (v' - v)",
      r"I = F \cdot \Delta t",
      r"F \cdot \Delta t = m (v' - v)",
    ],
    soundFormulas: [
      'impuls sama dengan perubahan momentum',
      'impuls sama dengan massa benda kurung buka kecepatan akhir dikurangi kecepatan awal',
      'impuls sama dengan ef dikali selang waktu',
      'ef dikali selang waktu sama dengan massa benda kurung buka kecepatan akhir dikurangi kecepatan awal',
    ],
    soundKeterangan: [
      'i sama dengan impuls dalam satuan newton detik',
      'delta p sama dengan perubahan momentum dalam kilogram meter per detik',
      'delta t sama dengan selang waktu dalam detik',
      'm sama dengan massa benda dalam kilogram',
      've aksen adalah kecepatan akhir dalam meter per detik',
      've adalah kecepatan awal dalam meter per detik',
      'ef adalah gaya dalam newton',
    ],
    // audioFrontAsset: 'audio/impuls_rumus_front.mp3',
    // audioBackAsset: 'audio/impuls_rumus_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Sehari hari',
    imageUrl: 'assets/resources/contoh1-impuls.png',
    category: CardCategory.impuls,
    description:
        'Menendang bola: \n\nSaat kaki menendang bola, gaya besar bekerja dalam waktu singkat sehingga bola mengalami perubahan momentum dan bergerak cepat ke depan.',
    // audioFrontAsset: 'audio/impuls_contoh1_front.mp3',
    // audioBackAsset: 'audio/impuls_contoh1_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Sehari hari',
    imageUrl: 'assets/resources/contoh2-impuls.png',
    category: CardCategory.impuls,
    description:
        'Pemukul memukul bola baseball: \n\nKetika pemukul mengenai bola, gaya besar diberikan dalam waktu singkat. Impuls yang besar membuat bola terpental jauh dengan kecepatan tinggi.',
    // audioFrontAsset: 'audio/impuls_contoh2_front.mp3',
    // audioBackAsset: 'audio/impuls_contoh2_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Sehari hari',
    imageUrl: 'assets/resources/contoh3-impuls.png',
    category: CardCategory.impuls,
    description:
        'Menangkap bola dengan tangan: \n\nPenangkap memperlambat bola secara bertahap (memperpanjang waktu tumbukan) agar gaya yang dirasakan tangan lebih kecil.',
  ),
  BaseDatas(
    title: 'Contoh Sehari hari',
    imageUrl: 'assets/resources/contoh4-impuls.png',
    category: CardCategory.impuls,
    description:
        'Bola basket memantul di lantai: \n\nGaya dari lantai mengubah arah dan kecepatan bola, menunjukkan perubahan momentum akibat impuls dari lantai.',
  ),
  BaseDatas(
    title: 'Hukum Kekekalan Momentum',
    imageUrl: 'assets/resources/hkm.png',
    category: CardCategory.hkm,
    description:
        "Menyatakan bahwa total momentum sistem sebelum dan sesudah tumbukan adalah sama.",
    formulasTex: [
      r"p = p'",
      r"p_1 + p_2 = p'_1 + p'_2",
      r"m_1 v_1 + m_2 v_2 = m_1 v'_1 +",
      r"m_2 v'_2",
    ],
    soundFormulas: [
      'momentum awal sama dengan momentum akhir',
      'jumlah total momentum awal sama dengan jumlah total momentum akhir',
      'jumlah total masa dikali kecepatan awal sama dengan jumlah total massa dikali kecepatan akhir',
    ],
  ),
  BaseDatas(
    title: 'Pengertian Tumbukan',
    imageUrl: 'assets/resources/pengertian-tumbukan.png',
    category: CardCategory.tumbukan,
    description:
        'Tumbukan adalah interaksi antara dua benda atau lebih yang saling bertukar gaya dalam selang waktu tertentu, yang mana momentum total sistem benda tersebut akan tetap konstan (kekal) jika tidak ada gaya luar yang bekerja.',
    // audioFrontAsset: 'audio/tumbukan_pengertian_front.mp3',
    // audioBackAsset: 'audio/tumbukan_pengertian_back.mp3',
  ),
  BaseDatas(
    title: 'Koefisien Restitusi',
    imageUrl: 'assets/resources/sifat-tumbukan.png',
    category: CardCategory.tumbukan,
    description:
        'Semakin elastis tumbukan, semakin besar nilai koefisien restitusi (e) dan semakin besar pula energi kinetik yang dipertahankan setelah tumbukan.',
    formulasTex: [r"e = - \frac{v'_1 - v'_2}{v_1 - v_2}"],
    soundFormulas: [
      'koefisien restitusi sama dengan negatif perbandingan antara selisih kecepatan dua benda setelah tumbukan dengan selisih kecepatan dua benda sebelum tumbukan',
    ],
  ),
  BaseDatas(
    title: 'Jenis Tumbukan',
    imageUrl: 'assets/resources/jenis1-tumbukan.png',
    category: CardCategory.tumbukan,
    description:
        'Jenis jenis tumbukan ada 3, yaitu tumbukan lenting sempurna, lenting sebagian, dan tidak lenting sama sekali.',
  ),
  BaseDatas(
    title: 'Jenis Tumbukan: Tumbukan Lenting Sempurna',
    imageUrl: 'assets/resources/contoh1-tumbukan.png',
    category: CardCategory.tumbukan,
    description:
        'Peristiwa tumbukan yang terjadi jika energi kinetik pada sistem tersebut adalah tetap (kekal). Dalam peristiwa ini, koefisien restitusi (e) bernilai 1.',
    // audioFrontAsset: 'audio/tumbukan_lenting_sempurna_front.mp3',
    // audioBackAsset: 'audio/tumbukan_lenting_sempurna_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Tumbukan Lenting Sempurna',
    imageUrl: 'assets/resources/jenis2-tumbukan.png',
    category: CardCategory.tumbukan,
    description:
        'Contoh: Tumbukan antar partikel subatomik atau atom yang sangat elastis, tumbukan antara bola biliar dalam kondisi ideal.',
    // audioFrontAsset: 'audio/tumbukan_lenting_sempurna_front.mp3',
    // audioBackAsset: 'audio/tumbukan_lenting_sempurna_back.mp3',
  ),
  BaseDatas(
    title: 'Jenis Tumbukan: Tumbukan Lenting Sebagian',
    imageUrl: 'assets/resources/contoh2-tumbukan.png',
    category: CardCategory.tumbukan,
    description:
        'Tumbukan lenting sebagian adalah tabrakan antar benda di mana hukum kekekalan momentum tetap berlaku, tetapi energi kinetik total tidak sepenuhnya kekal karena sebagian energi berubah menjadi panas, suara, atau deformasi benda. Dalam peristiwa ini, koefisien restitusi (e) bernilai antara 0 dan 1 (0 < e < 1).',
    // audioFrontAsset: 'audio/tumbukan_lenting_sebagian_front.mp3',
    // audioBackAsset: 'audio/tumbukan_lenting_sebagian_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Tumbukan Lenting Sebagian',
    imageUrl: 'assets/resources/jenis3-tumbukan.png',
    category: CardCategory.tumbukan,
    description:
        'Contoh: Tumbukan antara bola karet dengan lantai, atau bola basket yang dijatuhkan dari ketinggian tertentu lalu tidak memantul setinggi semula.',
    // audioFrontAsset: 'audio/tumbukan_lenting_sempurna_front.mp3',
    // audioBackAsset: 'audio/tumbukan_lenting_sempurna_back.mp3',
  ),
  BaseDatas(
    title: 'Jenis Tumbukan: Tumbukan Tidak Lenting Sama Sekali',
    imageUrl: 'assets/resources/contoh3-tumbukan.png',
    category: CardCategory.tumbukan,
    description:
        'Tumbukan tidak lenting sama sekali adalah tabrakan antar benda di mana setelah tumbukan kedua benda menyatu dan bergerak bersama. Pada jenis tumbukan ini, hanya hukum kekekalan momentum yang berlaku, sedangkan energi kinetik total berkurang secara signifikan karena sebagian besar berubah menjadi energi panas, bunyi, atau bentuk deformasi permanen. Dalam peristiwa ini, koefisien restitusi (e) = 0.',
    // audioFrontAsset: 'audio/tumbukan_tidak_lenting_front.mp3',
    // audioBackAsset: 'audio/tumbukan_tidak_lenting_back.mp3',
  ),
  BaseDatas(
    title: 'Contoh Tumbukan Tidak Lenting Sama Sekali',
    imageUrl: 'assets/resources/peluru.png',
    category: CardCategory.tumbukan,
    description:
        'Contoh: Tumbukan antara peluru yang menancap pada balok kayu, atau dua mobil yang bertabrakan dan menempel menjadi satu setelah benturan.',
    // audioFrontAsset: 'audio/tumbukan_lenting_sempurna_front.mp3',
    // audioBackAsset: 'audio/tumbukan_lenting_sempurna_back.mp3',
  ),
];
