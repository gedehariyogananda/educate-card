class EduCard {
  final String imageUrl;
  final String description;
  final String question;
  final String answer;

  EduCard({
    required this.imageUrl,
    required this.description,
    required this.question,
    required this.answer,
  });
}

final List<EduCard> eduCards = [
  EduCard(
    imageUrl: 'https://picsum.photos/300/200?random=1',
    description: 'Deskripsi kartu pertama.',
    question: 'Apa ibu kota Indonesia?',
    answer: 'Jakarta',
  ),
  EduCard(
    imageUrl: 'https://picsum.photos/300/200?random=2',
    description: 'Deskripsi kartu kedua.',
    question: '2 + 2 = ?',
    answer: '4',
  ),
  EduCard(
    imageUrl: 'https://picsum.photos/300/200?random=3',
    description: 'Deskripsi kartu ketiga.',
    question: 'Warna langit saat cerah?',
    answer: 'Biru',
  ),
];
