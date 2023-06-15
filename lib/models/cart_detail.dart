class CartDetail {
  final int id;
  final int userId;
  final int productId;
  int quantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartDetail({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
  });
}
