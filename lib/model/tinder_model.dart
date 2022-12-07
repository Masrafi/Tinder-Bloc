class TinderModel {
  TinderModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
  });

  final id;
  final title;
  final price;
  final description;
  final category;
  final image;

  factory TinderModel.fromJson(Map<String, dynamic> json) => TinderModel(
        id: json["id"],
        title: json["title"],
        price: json["price"].toDouble(),
        description: json["description"],
        category: json["category"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": image,
      };
}
