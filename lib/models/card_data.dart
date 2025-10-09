class BaseDatas {
  final String title;
  final String imageUrl;
  final String description;
  final String question;
  final String answer;

  BaseDatas({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.question,
    required this.answer,
  });
}

final List<BaseDatas> datas = [
  BaseDatas(
    title: 'Momentum',
    imageUrl: 'assets/resources/gambar-momentum.png',
    description:
        '1. Momentum adalah kelembaman atau inersia benda dalam gerak, juga dapat diartikan sebagai ukuran mudah atau sulitnya benda dihentikan. Semakin mudah benda itu dihentikan dari geraknya maka semakin kecil momentumnya dan sebaliknya.\n\n'
        '2. p = m × v dengan p = momentum (kg m per s atau Ns), m = massa (kg), v = kecepatan (m per s)\n\n'
        '3. Contoh dalam kehidupan sehari-hari: truk yang lebih berat memiliki momentum lebih besar daripada mobil kecil dengan kecepatan sama, pemain karate memukul tumpukan ubin dengan tangan cepat untuk menghasilkan gaya besar, peluncuran roket dimana ketika gas dan bahan bakar dikeluarkan dengan kecepatan tinggi ke belakang, roket akan terdorong ke depan dengan momentum yang sama besarnya tetapi berlawanan arah, serta permainan biliar di mana bola yang bergerak akan memantul dari bola lain.',
    question: 'Apa rumus momentum?',
    answer:
        'p = m × v, dimana p adalah momentum (kg·m/s atau Ns), m adalah massa (kg), dan v adalah kecepatan (m/s)',
  ),
  BaseDatas(
    title: 'Geografi Indonesia',
    imageUrl: 'https://picsum.photos/300/200?random=1',
    description:
        'Indonesia adalah negara kepulauan terbesar di dunia dengan lebih dari 17.000 pulau.',
    question: 'Apa ibu kota Indonesia?',
    answer: 'Jakarta',
  ),
  BaseDatas(
    title: 'Matematika Dasar',
    imageUrl: 'https://picsum.photos/300/200?random=2',
    description: 'Penjumlahan adalah operasi dasar dalam matematika.',
    question: '2 + 2 = ?',
    answer: '4',
  ),
  BaseDatas(
    title: 'Sains Alam',
    imageUrl: 'https://picsum.photos/300/200?random=3',
    description:
        'Langit terlihat biru karena hamburan cahaya matahari di atmosfer.',
    question: 'Warna langit saat cerah?',
    answer: 'Biru',
  ),
  BaseDatas(
    title: 'Sastra Dunia',
    imageUrl: 'https://picsum.photos/300/200?random=4',
    description:
        'Harry Potter adalah serial novel fantasi yang sangat populer.',
    question: 'Siapa penulis "Harry Potter"?',
    answer: 'J.K. Rowling',
  ),
  BaseDatas(
    title: 'Astronomi',
    imageUrl: 'https://picsum.photos/300/200?random=5',
    description: 'Merkurius adalah planet terkecil di tata surya kita.',
    question: 'Planet terdekat Matahari?',
    answer: 'Merkurius',
  ),
];
