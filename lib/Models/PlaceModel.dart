class Place {
   String? id;
   String title;
   String content;
   String authorId; // Cambiado a String para coincidir con el ObjectId en MongoDB
   double rating;
   double latitude;
   double longitude;
   String photo;
   bool isBankito; // Cambiado a bool para coincidir con la estructura de tipo de lugar en el backend
   bool isPublic; // Cambiado a bool para coincidir con la estructura de tipo de lugar en el backend
   bool isCovered; // Cambiado a bool para coincidir con la estructura de tipo de lugar en el backend
   Map<String, String> schedule; // Cambiado a Map<String, String> para coincidir con la estructura de horario en el backend
   String address;
   bool placeDeactivated;
   DateTime creationDate;
   DateTime modifiedDate;

  Place({
    this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.photo,
    required this.isBankito,
    required this.isPublic,
    required this.isCovered,
    required this.schedule,
    required this.address,
    required this.placeDeactivated,
    required this.creationDate,
    required this.modifiedDate,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['_id'], // Manejar la ausencia de 'id' si no está presente en el JSON
      title: json['title'],
      content: json['content'],
      authorId: json['author'], // Asumiendo que 'author' es el ObjectId del autor en tu backend
      rating: json['rating'].toDouble(), // Convertir a double si es necesario
      latitude: json['coords']['latitude'].toDouble(), // Convertir a double si es necesario
      longitude: json['coords']['longitude'].toDouble(), // Convertir a double si es necesario
      photo: json['photo'],
      isBankito: json['typeOfPlace']['bankito'],
      isPublic: json['typeOfPlace']['public'],
      isCovered: json['typeOfPlace']['covered'],
      schedule: Map<String, String>.from(json['schedule'] ?? {}), // Convierte el horario a Map<String, String>
      address: json['address'],
      placeDeactivated: json['place_deactivated'],
      creationDate: json['creation_date'] != null ? DateTime.parse(json['creation_date']) : DateTime.now(), // Parsea la fecha a DateTime si está presente, de lo contrario usa la fecha actual
      modifiedDate: json['modified_date'] != null ? DateTime.parse(json['modified_date']) : DateTime.now(), // Parsea la fecha a DateTime si está presente, de lo contrario usa la fecha actual
    );
  }

   Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'title': title,
      'content': content,
      'author': authorId,
      'rating': rating,
      'coords': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'photo': photo,
      'typeOfPlace': {
        'bankito': isBankito,
        'public': isPublic,
        'covered': isCovered,
      },
      'schedule': schedule,
      'address': address,
      'place_deactivated': placeDeactivated,
      'creation_date': creationDate.toIso8601String(),
      'modified_date': modifiedDate.toIso8601String(),
    };

    if (id != null) {
      json['_id'] = id; // Incluir 'id' en el JSON solo si está presente
    }

    return json;
  }
}