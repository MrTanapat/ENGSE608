import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('ตระกร้าสินค้า')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (ctx, i) {
                final item = cart.cartItems[i];
                return ListTile(
                  leading: Image.network(item.product.image, width: 50),
                  title: Text(item.product.title),
                  subtitle: Text(
                    '${item.product.price} x ${item.quantity} = ${item.totalItemPrice.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => cart.removeOneItem(item.product.id),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => cart.addToCart(item.product),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ราคารวมทั้งหมด:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${cart.totalAmount.toStringAsFixed(2)} USD',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: cart.itemCount == 0
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('ชำระเงินสำเร็จ'),
                          content: const Text('ขอบคุณที่อุดหนุนสินค้าของเรา!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                cart.clearCart();
                                Navigator.pop(ctx);
                                Navigator.pop(context);
                              },
                              child: const Text('ตกลง'),
                            ),
                          ],
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('ยืนยันรายการสินค้า'),
            ),
          ),
        ],
      ),
    );
  }
}
