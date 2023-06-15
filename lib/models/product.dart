class Product {
  final int id;
  final int storeId;
  final String name;
  final int price;
  final int stockQuantity;
  final int soldQuantity;
  final String imageLink;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.storeId,
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.soldQuantity,
    required this.imageLink,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      storeId: json['store_id'],
      name: json['name'],
      price: json['price'],
      stockQuantity: json['stock_quantity'],
      soldQuantity: json['sold_quantity'],
      imageLink: json['image_link'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'store_id': storeId,
        'name': name,
        'price': price,
        'stock_quantity': stockQuantity,
        'sold_quantity': soldQuantity,
        'image_link': imageLink,
        'description': description,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
