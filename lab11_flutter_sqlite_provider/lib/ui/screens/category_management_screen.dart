import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/category_provider.dart';
import '../../data/models/category_model.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final _nameController = TextEditingController();
  String _selectedColor = "#2196F3"; // สีเริ่มต้น (Blue)

  final List<String> _colorOptions = [
    "#F44336",
    "#E91E63",
    "#9C27B0",
    "#673AB7",
    "#3F51B5",
    "#2196F3",
    "#00BCD4",
    "#4CAF50",
    "#FFEB3B",
    "#FF9800",
    "#795548",
    "#9E9E9E",
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CategoryProvider>().fetchCategories());
  }

  // ฟังก์ชันเพิ่มข้อมูลจำลอง 5 รายการ (Quick Add)
  void _addDummyCategories() async {
    final provider = context.read<CategoryProvider>();
    final dummies = [
      Category(name: "ประชุม (Work)", colorHex: "#F44336", iconKey: "work"),
      Category(
        name: "ส่วนตัว (Personal)",
        colorHex: "#4CAF50",
        iconKey: "person",
      ),
      Category(
        name: "งานด่วน (Urgent)",
        colorHex: "#E91E63",
        iconKey: "priority_high",
      ),
      Category(name: "การเรียน (Study)", colorHex: "#2196F3", iconKey: "book"),
      Category(
        name: "สุขภาพ (Health)",
        colorHex: "#9C27B0",
        iconKey: "favorite",
      ),
    ];

    for (var cat in dummies) {
      if (!provider.categories.any((element) => element.name == cat.name)) {
        await provider.addCategory(cat);
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("เพิ่มหมวดหมู่จำลอง 5 รายการเรียบร้อยแล้ว!"),
        ),
      );
    }
  }

  void _showCategoryForm({Category? category}) {
    if (category != null) {
      _nameController.text = category.name;
      _selectedColor = category.colorHex;
    } else {
      _nameController.clear();
      _selectedColor = "#2196F3";
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category == null ? "เพิ่มหมวดหมู่" : "แก้ไขหมวดหมู่",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "ชื่อหมวดหมู่"),
              ),
              const SizedBox(height: 20),
              const Text("เลือกสี:"),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colorOptions.length,
                  itemBuilder: (context, index) {
                    final colorStr = _colorOptions[index];
                    return GestureDetector(
                      onTap: () =>
                          setModalState(() => _selectedColor = colorStr),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 35,
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(colorStr.replaceFirst('#', '0xff')),
                          ),
                          shape: BoxShape.circle,
                          border: _selectedColor == colorStr
                              ? Border.all(width: 3, color: Colors.black)
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (_nameController.text.isEmpty) return;
                  final newCat = Category(
                    id: category?.id,
                    name: _nameController.text,
                    colorHex: _selectedColor,
                    iconKey: "folder",
                  );
                  if (category == null) {
                    await context.read<CategoryProvider>().addCategory(newCat);
                  } else {
                    await context.read<CategoryProvider>().editCategory(newCat);
                  }
                  Navigator.pop(context);
                },
                child: const Text("บันทึก"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("จัดการหมวดหมู่"),
        actions: [
          TextButton.icon(
            onPressed: _addDummyCategories,
            icon: const Icon(Icons.flash_on, color: Colors.orange),
            label: const Text(
              "เพิ่มตัวอย่าง",
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, child) {
          if (provider.categories.isEmpty) {
            return const Center(
              child: Text("ยังไม่มีหมวดหมู่ กด 'เพิ่มตัวอย่าง' หรือ '+' ดูสิ"),
            );
          }
          return ListView.builder(
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              final cat = provider.categories[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(
                    int.parse(cat.colorHex.replaceFirst('#', '0xff')),
                  ),
                  child: const Icon(Icons.folder, color: Colors.white),
                ),
                title: Text(cat.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showCategoryForm(category: cat),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final error = await provider.removeCategory(cat.id!);
                        if (error != null) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(error)));
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
