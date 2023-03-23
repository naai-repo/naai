class Artist {
  String? name;
  double? rating;
  String? imagePath;

  Artist({
    this.name,
    this.rating,
    this.imagePath,
  });

  factory Artist.fromFirestore(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      rating: json['rating'],
      imagePath: 'assets/images/artist_dummy_image.svg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'imagePath': imagePath,
    };
  }
}