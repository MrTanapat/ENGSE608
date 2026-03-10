import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/problem_provider.dart';
import '../models/problem.dart';
import 'add_problem_screen.dart';
import 'problem_detail_screen.dart';
import 'statistics_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายงานปัญหาชุมชน'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
            tooltip: 'สถิติ',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'กรอง',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาปัญหา...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ProblemProvider>().setSearchQuery('');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                context.read<ProblemProvider>().setSearchQuery(value);
              },
            ),
          ),

          // Filter Chips
          _buildFilterChips(),

          // Problems List
          Expanded(
            child: Consumer<ProblemProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.problems.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () => provider.loadProblems(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: provider.problems.length,
                    itemBuilder: (context, index) {
                      final problem = provider.problems[index];
                      return _buildProblemCard(problem);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProblemScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('รายงานปัญหา'),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Consumer<ProblemProvider>(
      builder: (context, provider, child) {
        final hasFilters = provider.filterCategory != 'ทั้งหมด' ||
            provider.filterStatus != 'ทั้งหมด';

        if (!hasFilters) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (provider.filterCategory != 'ทั้งหมด') ...[
                Chip(
                  label: Text(provider.filterCategory),
                  onDeleted: () => provider.setFilterCategory('ทั้งหมด'),
                  deleteIcon: const Icon(Icons.close, size: 18),
                ),
                const SizedBox(width: 8),
              ],
              if (provider.filterStatus != 'ทั้งหมด') ...[
                Chip(
                  label: Text(_getStatusText(provider.filterStatus)),
                  onDeleted: () => provider.setFilterStatus('ทั้งหมด'),
                  deleteIcon: const Icon(Icons.close, size: 18),
                ),
                const SizedBox(width: 8),
              ],
              TextButton(
                onPressed: () => provider.resetFilters(),
                child: const Text('ล้างทั้งหมด'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProblemCard(Problem problem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProblemDetailScreen(problemId: problem.id!),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Category Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          _getCategoryColor(problem.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ProblemCategory.getIcon(problem.category),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title and Category
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          problem.category,
                          style: TextStyle(
                            fontSize: 14,
                            color: _getCategoryColor(problem.category),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  _buildStatusBadge(problem.status),
                ],
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                problem.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Footer
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      problem.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.access_time,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(problem.createdAt),
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'in_progress':
        color = Colors.blue;
        icon = Icons.refresh;
        break;
      case 'resolved':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            _getStatusText(status),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'ยังไม่มีรายงานปัญหา',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'กดปุ่มด้านล่างเพื่อรายงานปัญหา',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('กรองรายการ'),
        content: Consumer<ProblemProvider>(
          builder: (context, provider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Filter
                const Text(
                  'หมวดหมู่',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: provider.filterCategory,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: ['ทั้งหมด', ...ProblemCategory.categories]
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      provider.setFilterCategory(value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Status Filter
                const Text(
                  'สถานะ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: provider.filterStatus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ทั้งหมด', child: Text('ทั้งหมด')),
                    DropdownMenuItem(
                        value: 'pending', child: Text('รอดำเนินการ')),
                    DropdownMenuItem(
                        value: 'in_progress', child: Text('กำลังแก้ไข')),
                    DropdownMenuItem(
                        value: 'resolved', child: Text('เสร็จสิ้น')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      provider.setFilterStatus(value);
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ProblemProvider>().resetFilters();
              Navigator.pop(context);
            },
            child: const Text('ล้างทั้งหมด'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ปิด'),
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

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'รอดำเนินการ';
      case 'in_progress':
        return 'กำลังแก้ไข';
      case 'resolved':
        return 'เสร็จสิ้น';
      default:
        return 'ไม่ทราบสถานะ';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} นาทีที่แล้ว';
      }
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inDays == 1) {
      return 'เมื่อวาน';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} วันที่แล้ว';
    } else {
      return DateFormat('d MMM yyyy', 'th').format(date);
    }
  }
}
