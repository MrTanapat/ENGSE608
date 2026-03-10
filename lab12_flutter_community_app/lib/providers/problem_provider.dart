import 'package:flutter/foundation.dart';
import '../models/problem.dart';
import '../database/database_helper.dart';

class ProblemProvider with ChangeNotifier {
  List<Problem> _problems = [];
  bool _isLoading = false;
  String _filterCategory = 'ทั้งหมด';
  String _filterStatus = 'ทั้งหมด';
  String _searchQuery = '';

  // Getters
  List<Problem> get problems => _filteredProblems;
  bool get isLoading => _isLoading;
  String get filterCategory => _filterCategory;
  String get filterStatus => _filterStatus;
  String get searchQuery => _searchQuery;

  // กรองและค้นหา
  List<Problem> get _filteredProblems {
    var filtered = List<Problem>.from(_problems);

    // กรองตาม category
    if (_filterCategory != 'ทั้งหมด') {
      filtered = filtered.where((p) => p.category == _filterCategory).toList();
    }

    // กรองตาม status
    if (_filterStatus != 'ทั้งหมด') {
      filtered = filtered.where((p) => p.status == _filterStatus).toList();
    }

    // ค้นหา
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              p.location.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  // สถิติ
  int get totalProblems => _problems.length;

  int get pendingCount => _problems.where((p) => p.status == 'pending').length;

  int get inProgressCount =>
      _problems.where((p) => p.status == 'in_progress').length;

  int get resolvedCount =>
      _problems.where((p) => p.status == 'resolved').length;

  Map<String, int> get categoryCounts {
    Map<String, int> counts = {};
    for (var problem in _problems) {
      counts[problem.category] = (counts[problem.category] ?? 0) + 1;
    }
    return counts;
  }

  // โหลดข้อมูลทั้งหมด
  Future<void> loadProblems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _problems = await DatabaseHelper.instance.readAllProblems();
    } catch (e) {
      debugPrint('Error loading problems: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // เพิ่มปัญหาใหม่
  Future<void> addProblem(Problem problem) async {
    try {
      final newProblem = await DatabaseHelper.instance.create(problem);
      _problems.insert(0, newProblem);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding problem: $e');
      rethrow;
    }
  }

  // อัพเดทปัญหา
  Future<void> updateProblem(Problem problem) async {
    try {
      await DatabaseHelper.instance.update(problem);
      final index = _problems.indexWhere((p) => p.id == problem.id);
      if (index != -1) {
        _problems[index] = problem;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating problem: $e');
      rethrow;
    }
  }

  // ลบปัญหา
  Future<void> deleteProblem(int id) async {
    try {
      await DatabaseHelper.instance.delete(id);
      _problems.removeWhere((p) => p.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting problem: $e');
      rethrow;
    }
  }

  // อัพเดทสถานะ
  Future<void> updateStatus(int id, String newStatus) async {
    try {
      final problem = _problems.firstWhere((p) => p.id == id);
      final updatedProblem = problem.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      await updateProblem(updatedProblem);
    } catch (e) {
      debugPrint('Error updating status: $e');
      rethrow;
    }
  }

  // ตั้งค่า filter
  void setFilterCategory(String category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // รีเซ็ต filter
  void resetFilters() {
    _filterCategory = 'ทั้งหมด';
    _filterStatus = 'ทั้งหมด';
    _searchQuery = '';
    notifyListeners();
  }

  // ดึงปัญหาตาม ID
  Problem? getProblemById(int id) {
    try {
      return _problems.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
