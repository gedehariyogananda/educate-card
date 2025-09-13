class BaseDatas {
  final String imageUrl;
  final String description;
  final String question;
  final String answer;

  BaseDatas({
    required this.imageUrl,
    required this.description,
    required this.question,
    required this.answer,
  });
}

final List<BaseDatas> datas = [
  BaseDatas(
    imageUrl: 'https://picsum.photos/300/200?random=1',
    description: 'Deskripsi kartu pertama.',
    question: 'Apa ibu kota Indonesia?',
    answer: 'Jakarta',
  ),
  BaseDatas(
    imageUrl: 'https://picsum.photos/300/200?random=2',
    description: 'Deskripsi kartu kedua.',
    question: '2 + 2 = ?',
    answer: '4',
  ),
  BaseDatas(
    imageUrl: 'https://picsum.photos/300/200?random=3',
    description: 'Deskripsi kartu ketiga.',
    question: 'Warna langit saat cerah?',
    answer: 'Biru',
  ),
  BaseDatas(
    imageUrl: 'https://picsum.photos/300/200?random=4',
    description: 'Deskripsi kartu keempat.',
    question: 'Siapa penulis "Harry Potter"?',
    answer: 'J.K. Rowling',
  ),
  BaseDatas(
    imageUrl: 'https://picsum.photos/300/200?random=5',
    description: 'Deskripsi kartu kelima.',
    question: 'Planet terdekat Matahari?',
    answer: 'Merkurius',
  ),
];
