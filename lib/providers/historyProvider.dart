import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/historyEntry.dart';

class HistoryProvider extends ChangeNotifier {
  static const String _key = 'calc_history';
  List<HistoryEntry> _entries = [];

  List<HistoryEntry> get entries => List.unmodifiable(_entries);

  HistoryProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    _entries = raw
      .map((e) => HistoryEntry.fromJson(jsonDecode(e) as Map<String, dynamic>))
      .toList();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      _entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> add(HistoryEntry entry) async {
    _entries.insert(0, entry);
    notifyListeners();
    await _save();
  }

  Future<void> remove(int index) async {
    _entries.removeAt(index);
    notifyListeners();
    await _save();
  }

  Future<void> clear() async {
    _entries.clear();
    notifyListeners();
    await _save();
  }
}
