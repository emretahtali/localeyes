class PlaceDetailCardDto {
  final String title;
  final String description;
  final String imageUrl;

  const PlaceDetailCardDto({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory PlaceDetailCardDto.fromJson(Map<String, dynamic> json) {
    return PlaceDetailCardDto(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
