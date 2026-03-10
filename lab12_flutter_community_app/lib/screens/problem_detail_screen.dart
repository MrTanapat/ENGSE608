import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/problem_provider.dart';
import '../models/problem.dart';

class ProblemDetailScreen extends StatelessWidget {
  final int problemId;

  const ProblemDetailScreen({super.key, required this.problemId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProblemProvider>(
      builder: (context, provider, child) {
        final problem = provider.getProblemById(problemId);

        if (problem == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('ไม่พบข้อมูล')),
            body: const Center(
              child: Text('ไม่พบรายงานปัญหานี้'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('รายละเอียดปัญหา'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteDialog(context, provider, problem),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(problem.category)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ProblemCategory.getIcon(problem.category),
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.category,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(problem.category),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'รหัส: #${problem.id}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'หัวข้อ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                problem.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'รายละเอียด',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  problem.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoCard(
                icon: Icons.location_on,
                title: 'สถานที่',
                content: problem.location,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              _buildStatusCard(context, provider, problem),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.access_time,
                title: 'รายงานเมื่อ',
                content: _formatDateTime(problem.createdAt),
                color: Colors.blue,
              ),
              if (problem.updatedAt != null) ...[
                const SizedBox(height: 16),
                _buildInfoCard(
                  icon: Icons.update,
                  title: 'อัพเดทล่าสุด',
                  content: _formatDateTime(problem.updatedAt!),
                  color: Colors.orange,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
      BuildContext context, ProblemProvider provider, Problem problem) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getStatusColor(problem.status).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(problem.status).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getStatusIcon(problem.status),
                color: _getStatusColor(problem.status),
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  problem.statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(problem.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, ProblemProvider provider, Problem problem) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบ "${problem.title}" หรือไม่'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () async {
              await provider.deleteProblem(problem.id!);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ลบ'),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'in_progress':
        return Icons.refresh;
      case 'resolved':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    try {
      return DateFormat('d MMMM yyyy, HH:mm น.', 'th').format(dateTime);
    } catch (_) {
      return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    }
  }
}
