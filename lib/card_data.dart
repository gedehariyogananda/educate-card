// Data model untuk card edukasi
class EduCard {
  final String imageUrl;
  final String description;

  EduCard({required this.imageUrl, required this.description});
}

// Contoh data card
final List<EduCard> eduCards = [
  EduCard(
    imageUrl: 'https://picsum.photos/300/200?random=1',
    description: 'Ini adalah deskripsi kartu pertama.',
  ),
  EduCard(
    imageUrl: 'https://picsum.photos/300/200?random=2',
    description: 'Ini adalah deskripsi kartu kedua.',
  ),
  EduCard(
    imageUrl: 'https://picsum.photos/300/200?random=3',
    description: 'Ini adalah deskripsi kartu ketiga.',
  ),
];
