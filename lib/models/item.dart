class Item {
  final int? id;
  final String type; // book, movie, anime, game, other
  final String? subtype; // only used when type == other
  final String title;
  final String? creator;
  final int? year;
  final String? category;
  final String status; // wishlist, ongoing, done
  final int? rating; // 1-5
  final String? review;
  final String? imageUrl;

  Item({
    this.id,
    required this.type,
    this.subtype,
    required this.title,
    this.creator,
    this.year,
    this.category,
    required this.status,
    this.rating,
    this.review,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'subtype': subtype,
      'title': title,
      'creator': creator,
      'year': year,
      'category': category,
      'status': status,
      'rating': rating,
      'review': review,
      'image_url': imageUrl,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int?,
      type: map['type'] as String,
      subtype: map['subtype'] as String?,
      title: map['title'] as String,
      creator: map['creator'] as String?,
      year: map['year'] as int?,
      category: map['category'] as String?,
      status: map['status'] as String,
      rating: map['rating'] as int?,
      review: map['review'] as String?,
      imageUrl: map['image_url'] as String?,
    );
  }
}
