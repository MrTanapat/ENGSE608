import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'admin_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลสินค้าจาก API ทันทีเมื่อหน้าจอถูกสร้าง
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductProvider>().loadProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ดึงค่าจาก Providers ต่างๆ
    final auth = context.watch<AuthProvider>();
    final productProv = context.watch<ProductProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Products'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // 1. ตรวจสอบสิทธิ์ Admin (id=1 เท่านั้นถึงจะเห็นปุ่มนี้)
          if (auth.user?.isAdmin ?? false)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, color: Colors.red),
              tooltip: 'Admin Panel',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminScreen()),
              ),
            ),

          // 2. ปุ่มตระกร้าสินค้าพร้อมตัวเลขแจ้งเตือน (Badge)
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              if (cart.itemCount > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cart.itemCount}',
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),

          // 3. ปุ่ม Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: productProv.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            ) // แสดงวงกลมหมุนตอนโหลด
          : RefreshIndicator(
              onRefresh: () =>
                  productProv.loadProducts(), // ดึงข้อมูลใหม่เมื่อลากลง
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // แสดง 2 คอลัมน์
                  childAspectRatio: 0.7, // สัดส่วนการแสดงผล Card
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: productProv.products.length,
                itemBuilder: (ctx, i) {
                  final product = productProv.products[i];

                  // ใช้ InkWell เพื่อให้กดที่ Card แล้วนำทางไปหน้ารายละเอียด
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          // ส่วนรูปภาพสินค้า
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                product.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // ส่วนชื่อสินค้า
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              product.title,
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // ส่วนราคาสินค้า
                          Text(
                            '${product.price} USD',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // ปุ่มเพิ่มลงตระกร้า
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                cart.addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'เพิ่ม ${product.title} แล้ว',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: const Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
