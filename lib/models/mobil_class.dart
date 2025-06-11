class MobilClass {
  String? id;
  String? createdAt;
  String brandName;
  String model;
  int year;
  String color;
  int price;
  String imageUrl;
  String detail;

  MobilClass(
      {this.id,
      this.createdAt,
      required this.brandName,
      required this.model,
      required this.year,
      required this.color,
      required this.price,
      required this.imageUrl,
      required this.detail});

  factory MobilClass.fromJson(Map<String, dynamic> json) {
    return MobilClass(
      id: json['id']?.toString(),
      createdAt: json['createdAt']?.toString(),
      brandName: json['brandName'],
      model: json['model'],
      year: json['year'] is String ? int.tryParse(json['year']) ?? 0 : json['year'] ?? 0,
      color: json['color'],
      price: json['price'] is String ? int.tryParse(json['price']) ?? 0 : json['price'] ?? 0,
      imageUrl: json['imageUrl'],
      detail: json['detail'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // ID and createdAt are usually handled by the server,
    // but if they exist (e.g., when updating), include them.
    if (id != null) data['id'] = id;
    if (createdAt != null) data['createdAt'] = createdAt;
    data['brandName'] = brandName;
    data['model'] = model;
    data['year'] = year;
    data['color'] = color;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['detail'] = detail;
    return data;
  }

  Map<String, dynamic> toJsonForCreation() {
    // Exclude id and createdAt for new entries, as the server should generate them.
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brandName'] = brandName;
    data['model'] = model;
    data['year'] = year;
    data['color'] = color;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['detail'] = detail;
    return data;
  }
} 