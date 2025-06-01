

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DateProvider with ChangeNotifier {
  String? formattedDate;
  bool isLoading = true;
  String? error;

  Future<void> fetchCurrentDate() async {
    try {
      final response = await http.get(
        Uri.parse('https://timeapi.io/api/Time/current/zone?timeZone=Asia/Jakarta'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final datetime = DateTime.parse(data['dateTime']);
        formattedDate = _formatDate(datetime);
        isLoading = false;
        notifyListeners();
      } else {
        error = 'Gagal memuat tanggal';
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      error = 'Terjadi kesalahan: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
