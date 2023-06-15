class Order {
  final int id;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });
}
