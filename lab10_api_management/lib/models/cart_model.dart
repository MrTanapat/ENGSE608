import 'product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // คำนวณราคารวมของแต่ละรายการ (ราคา x จำนวน)
  double get totalItemPrice => product.price * quantity;
}
