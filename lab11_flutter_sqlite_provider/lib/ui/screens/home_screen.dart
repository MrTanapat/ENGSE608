import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/event_provider.dart';
import 'event_form_screen.dart';
import 'category_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<EventProvider>().fetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CategoryManagementScreen(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- ส่วนที่เพิ่ม: แถบเลือกตัวกรอง (Filter Chips) ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(context, 'ทั้งหมด', 'all'),
                _buildFilterChip(context, 'วันนี้', 'today'),
                _buildFilterChip(context, 'รอดำเนินการ', 'pending'),
                _buildFilterChip(context, 'เสร็จสิ้น', 'completed'),
              ],
            ),
          ),

          // --- รายการกิจกรรม ---
          Expanded(
            child: provider.events.isEmpty
                ? const Center(child: Text('ไม่พบกิจกรรมในเงื่อนไขนี้'))
                : ListView.builder(
                    itemCount: provider.events.length,
                    itemBuilder: (context, index) {
                      final event = provider.events[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(
                              int.parse(
                                event['color_hex'].replaceFirst('#', '0xff'),
                              ),
                            ),
                            child: const Icon(Icons.event, color: Colors.white),
                          ),
                          title: Text(
                            event['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${event['event_date']}\n${event['start_time']} - ${event['end_time']}',
                          ),
                          isThreeLine: true,
                          trailing: Chip(
                            label: Text(
                              event['status'].toString().toUpperCase(),
                              style: const TextStyle(fontSize: 10),
                            ),
                            backgroundColor: _getStatusColor(event['status']),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventFormScreen(editEvent: event),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget ช่วยสร้างปุ่มเลือก Filter
  Widget _buildFilterChip(BuildContext context, String label, String value) {
    final provider = context.read<EventProvider>();
    final isSelected = provider.currentFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) provider.setFilter(value);
        },
        selectedColor: Colors.blue.shade200,
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green.shade100;
      case 'in_progress':
        return Colors.blue.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }
}
