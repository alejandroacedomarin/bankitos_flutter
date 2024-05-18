class Review {
  String? id;
  String title;
  String content;
  double stars;
  String author; // Cambiado a String para coincidir con el ObjectId en MongoDB
  String? place_id;
  String? housing_id;
  bool review_deactivated;
  DateTime creationDate;
  DateTime modifiedDate;

  Review({
    this.id,
    required this.title,
    required this.content,
    required this.stars,
    required this.author,
    this.place_id,
    this.housing_id,
    required this.review_deactivated,
    required this.creationDate,
    required this.modifiedDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'], // Manejar la ausencia de 'id' si no está presente en el JSON
      title: json['title'],
      content: json['content'],
      stars: json['stars'].toDouble(), // Convertir a double si es necesario
      author: json['author'], // Asumiendo que 'author' es el ObjectId del autor en tu backend
      place_id: json['place_id'], // Asumiendo que 'place_id' es el ObjectId del place_id en tu backend
      housing_id: json['housing_id'], // Asumiendo que 'housing_id' es el ObjectId del housing_id en tu backend
      review_deactivated: json['review_deactivated'],
      creationDate: json['creation_date'] != null ? DateTime.parse(json['creation_date']) : DateTime.now(), // Parsea la fecha a DateTime si está presente, de lo contrario usa la fecha actual
      modifiedDate: json['modified_date'] != null ? DateTime.parse(json['modified_date']) : DateTime.now(), // Parsea la fecha a DateTime si está presente, de lo contrario usa la fecha actual
    );
  }

   Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'title': title,
      'content': content,
      'stars': stars,
      'author': author,
      'review_deactivated': review_deactivated,
      'place_id': place_id,
      'creation_date': creationDate.toIso8601String(),
      'modified_date': modifiedDate.toIso8601String(),
    };

    if (id != null) {
      json['_id'] = id; // Incluir 'id' en el JSON solo si está presente
    }

    return json;
  }
}