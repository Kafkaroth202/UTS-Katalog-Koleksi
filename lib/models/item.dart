class Item {
  static const categories = ['book', 'movie', 'anime', 'game', 'other'];
  static const statuses = ['finished', 'ongoing', 'not_yet'];

  final int? id;
  final String category; // book, movie, anime, game, other
  final String title;
  final String? creator; // author / director / studio / developer / creator
  final int? year;
  final String status; // finished, ongoing, not_yet
  final double? rating; // 0.5-10, in steps of 0.5
  final String? description;
  final String? imageUrl;

  Item({
    this.id,
    required this.category,
    required this.title,
    this.creator,
    this.year,
    required this.status,
    this.rating,
    this.description,
    this.imageUrl,
  });

  static String categoryLabelFor(String category) {
    switch (category) {
      case 'book':
        return 'Book';
      case 'movie':
        return 'Movie';
      case 'anime':
        return 'Anime';
      case 'game':
        return 'Game';
      default:
        return 'Other';
    }
  }

  static String creatorLabelFor(String category) {
    switch (category) {
      case 'book':
        return 'Author';
      case 'movie':
        return 'Director';
      case 'anime':
        return 'Studio';
      case 'game':
        return 'Developer';
      default:
        return 'Creator';
    }
  }

  static String statusLabelFor(String category, String status) {
    if (status == 'finished') return 'Finished';
    if (status == 'not_yet') return 'Not yet';
    switch (category) {
      case 'book':
        return 'Reading';
      case 'game':
        return 'Playing';
      case 'other':
        return 'In progress';
      default:
        return 'Watching'; // movie, anime
    }
  }

  // 7.0 -> "7", 7.5 -> "7.5"
  static String formatRating(double r) =>
      r == r.truncateToDouble() ? r.toInt().toString() : r.toString();

  String get categoryLabel => categoryLabelFor(category);
  String get creatorLabel => creatorLabelFor(category);
  String get statusLabel => statusLabelFor(category, status);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'creator': creator,
      'year': year,
      'status': status,
      'rating': rating,
      'description': description,
      'image_url': imageUrl,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int?,
      category: map['category'] as String,
      title: map['title'] as String,
      creator: map['creator'] as String?,
      year: map['year'] as int?,
      status: map['status'] as String,
      rating: (map['rating'] as num?)?.toDouble(),
      description: map['description'] as String?,
      imageUrl: map['image_url'] as String?,
    );
  }
}
