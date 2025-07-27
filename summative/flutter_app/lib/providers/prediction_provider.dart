import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionProvider with ChangeNotifier {
  String? _predictedScore;
  String? _error;
  bool _isLoading = false;

  String? get predictedScore => _predictedScore;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> predictPerformance({
    required String gender,
    required String raceEthnicity,
    required String parentalEducation,
    required String lunch,
    required String testPrep,
    required String readingScore,
    required String writingScore,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://ml-summative-fmbr.onrender.com/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'gender': gender,
          'race_ethnicity': raceEthnicity,
          'parental_level_of_education': parentalEducation,
          'lunch': lunch,
          'test_preparation_course': testPrep,
          'reading_score': int.parse(readingScore),
          'writing_score': int.parse(writingScore),
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _predictedScore = data['predicted_math_score'].toString();
      } else {
        _error = 'Failed to get prediction: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _predictedScore = null;
    _error = null;
    notifyListeners();
  }
}