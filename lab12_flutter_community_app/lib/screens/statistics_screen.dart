import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/problem_provider.dart';
import '../models/problem.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สถิติรายงานปัญหา'),
      ),
      body: Consumer<ProblemProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Summary Cards
              _buildSummarySection(provider),
              const SizedBox(height: 24),

              // Status Distribution
              _buildSection(
                title: 'สถานะปัญหา',
                icon: Icons.pie_chart,
                color: Colors.blue,
                child: _buildStatusChart(provider),
              ),
              const SizedBox(height: 24),

              // Category Distribution
              _buildSection(
                title: 'หมวดหมู่ปัญหา',
                icon: Icons.bar_chart,
                color: Colors.green,
                child: _buildCategoryChart(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummarySection(ProblemProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'สรุปภาพรวม',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'ทั้งหมด',
                value: provider.totalProblems.toString(),
                icon: Icons.assignment,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'รอดำเนินการ',
                value: provider.pendingCount.toString(),
                icon: Icons.pending,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'กำลังแก้ไข',
                value: provider.inProgressCount.toString(),
                icon: Icons.refresh,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'เสร็จสิ้น',
                value: provider.resolvedCount.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildStatusChart(ProblemProvider provider) {
    final total = provider.totalProblems;
    if (total == 0) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildProgressBar(
          label: 'รอดำเนินการ',
          count: provider.pendingCount,
          total: total,
          color: Colors.orange,
        ),
        const SizedBox(height: 12),
        _buildProgressBar(
          label: 'กำลังแก้ไข',
          count: provider.inProgressCount,
          total: total,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildProgressBar(
          label: 'เสร็จสิ้น',
          count: provider.resolvedCount,
          total: total,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildCategoryChart(ProblemProvider provider) {
    final categoryCounts = provider.categoryCounts;
    if (categoryCounts.isEmpty) {
      return _buildEmptyState();
    }

    final total = provider.totalProblems;
    final sortedEntries = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sortedEntries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildCategoryBar(
            category: entry.key,
            count: entry.value,
            total: total,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgressBar({
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    final percentage = total > 0 ? (count / total * 100).toInt() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$count ($percentage%)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: count / total,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBar({
    required String category,
    required int count,
    required int total,
  }) {
    final percentage = total > 0 ? (count / total * 100).toInt() : 0;
    final color = _getCategoryColor(category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              ProblemCategory.getIcon(category),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '$count ($percentage%)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: count / total,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'ยังไม่มีข้อมูล',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ถนน':
        return Colors.brown;
      case 'ไฟฟ้า':
        return Colors.amber;
      case 'น้ำประปา':
        return Colors.blue;
      case 'ขยะ':
        return Colors.green;
      case 'สวนสาธารณะ':
        return Colors.teal;
      case 'ความปลอดภัย':
        return Colors.red;
      case 'เสียงรบกวน':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
