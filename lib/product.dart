class Product {
  //Properties
  final int? id;
  final String title;
  final String description;
// Constructor
  Product({this.id, required this.title, required this.description});

// Product Copy
  Product copy({int? id, String? title, String? description}) => Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description);

//get info in map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
    };
  }
}
