import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/problem_provider.dart';
import '../models/problem.dart';

class AddProblemScreen extends StatefulWidget {
  const AddProblemScreen({super.key});

  @override
  State<AddProblemScreen> createState() => _AddProblemScreenState();
}

class _AddProblemScreenState extends State<AddProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCategory = ProblemCategory.categories[0];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final problem = Problem(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        location: _locationController.text.trim(),
        status: 'pending',
      );

      await context.read<ProblemProvider>().addProblem(problem);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ รายงานปัญหาเรียบร้อยแล้ว'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายงานปัญหาใหม่'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'กรุณากรอกข้อมูลให้ครบถ้วน เพื่อให้เราสามารถดำเนินการแก้ไขปัญหาได้อย่างรวดเร็ว',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Title
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'หัวข้อปัญหา *',
                hintText: 'เช่น ถนนเป็นหลุมบ่อ',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอกหัวข้อปัญหา';
                }
                if (value.trim().length < 5) {
                  return 'หัวข้อต้องมีอย่างน้อย 5 ตัวอักษร';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
              maxLength: 100,
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'หมวดหมู่ *',
                prefixIcon: Icon(Icons.category),
              ),
              items: ProblemCategory.categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Text(
                        ProblemCategory.getIcon(category),
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Location
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'สถานที่ *',
                hintText: 'เช่น ถนนสุขุมวิท ซอย 21',
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอกสถานที่';
                }
                if (value.trim().length < 5) {
                  return 'สถานที่ต้องมีอย่างน้อย 5 ตัวอักษร';
                }
                return null;
              },
              textCapitalization: TextCapitalization.sentences,
              maxLength: 200,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'รายละเอียดปัญหา *',
                hintText: 'อธิบายปัญหาโดยละเอียด...',
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'กรุณากรอกรายละเอียดปัญหา';
                }
                if (value.trim().length < 10) {
                  return 'รายละเอียดต้องมีอย่างน้อย 10 ตัวอักษร';
                }
                return null;
              },
              maxLines: 5,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitForm,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(_isSubmitting ? 'กำลังส่ง...' : 'ส่งรายงาน'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
