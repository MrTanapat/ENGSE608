import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/event_model.dart';
import '../state/event_provider.dart';
import '../state/category_provider.dart';

class EventFormScreen extends StatefulWidget {
  final Map<String, dynamic>? editEvent;

  const EventFormScreen({super.key, this.editEvent});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  int? _selectedCategoryId;
  int _priority = 2;
  String _status = 'pending';
  int _reminderMinutes = 15;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.editEvent?['title'] ?? '',
    );
    _descController = TextEditingController(
      text: widget.editEvent?['description'] ?? '',
    );

    if (widget.editEvent != null) {
      _selectedDate = DateTime.parse(widget.editEvent!['event_date']);
      _selectedCategoryId = widget.editEvent!['category_id'];
      _priority = widget.editEvent!['priority'] ?? 2;
      _status = widget.editEvent!['status'] ?? 'pending';
      _reminderMinutes = widget.editEvent!['reminder_minutes'] ?? 15;

      final startParts = widget.editEvent!['start_time'].split(':');
      final endParts = widget.editEvent!['end_time'].split(':');
      _startTime = TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      );
      _endTime = TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      );
    }

    Future.microtask(() => context.read<CategoryProvider>().fetchCategories());
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart)
          _startTime = picked;
        else
          _endTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  void _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("กรุณาเลือกหมวดหมู่")));
      return;
    }

    final eventData = {
      'id': widget.editEvent?['id'],
      'title': _titleController.text,
      'description': _descController.text,
      'category_id': _selectedCategoryId,
      'event_date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'start_time': _formatTime(_startTime),
      'end_time': _formatTime(_endTime),
      'status': _status,
      'priority': _priority,
      'reminder_minutes': _reminderMinutes,
    };

    final error = await context.read<EventProvider>().addEvent(eventData);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editEvent == null ? "เพิ่มกิจกรรม" : "แก้ไขกิจกรรม"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "ชื่อกิจกรรม *",
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? "กรุณากรอกชื่อกิจกรรม" : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: "หมวดหมู่",
                border: OutlineInputBorder(),
              ),
              hint: Text(
                categories.isEmpty ? "กรุณาเพิ่มหมวดหมู่ก่อน" : "เลือกหมวดหมู่",
              ),
              items: categories
                  .map(
                    (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategoryId = v),
            ),
            const SizedBox(height: 16),

            // --- ส่วนสถานะ (ที่หายไป เอากลับมาแล้วครับ) ---
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: "สถานะกิจกรรม",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('Pending (รอดำเนินการ)'),
                ),
                DropdownMenuItem(
                  value: 'in_progress',
                  child: Text('In Progress (กำลังทำ)'),
                ),
                DropdownMenuItem(
                  value: 'completed',
                  child: Text('Completed (เสร็จสิ้น)'),
                ),
                DropdownMenuItem(
                  value: 'cancelled',
                  child: Text('Cancelled (ยกเลิก)'),
                ),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("วันที่"),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate),
                    ),
                    onTap: _pickDate,
                    trailing: const Icon(Icons.calendar_month),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("เริ่ม"),
                    subtitle: Text(_formatTime(_startTime)),
                    onTap: () => _pickTime(true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("สิ้นสุด"),
                    subtitle: Text(_formatTime(_endTime)),
                    onTap: () => _pickTime(false),
                  ),
                ),
              ],
            ),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.notifications_active,
                color: Colors.orange,
              ),
              title: const Text("แจ้งเตือนล่วงหน้า"),
              trailing: DropdownButton<int>(
                value: _reminderMinutes,
                underline: Container(),
                items: [0, 5, 15, 30, 60].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value == 0 ? 'ไม่แจ้งเตือน' : '$value นาที'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _reminderMinutes = val!),
              ),
            ),
            const Divider(),

            const SizedBox(height: 8),
            const Text("ระดับความสำคัญ"),
            Slider(
              value: _priority.toDouble(),
              min: 1,
              max: 3,
              divisions: 2,
              label: _priority == 1
                  ? "ต่ำ"
                  : _priority == 2
                  ? "ปกติ"
                  : "สูง",
              onChanged: (v) => setState(() => _priority = v.toInt()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("บันทึกข้อมูล", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
