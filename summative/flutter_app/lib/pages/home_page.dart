import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/prediction_provider.dart';
import 'package:flutter_app/pages/result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    'gender': 'female',
    'raceEthnicity': 'group B',
    'parentalEducation': "bachelor's degree",
    'lunch': 'standard',
    'testPrep': 'none',
    'readingScore': '',
    'writingScore': '',
  };

  final List<Map<String, dynamic>> _dropdownFields = [
    {
      'label': 'Gender',
      'key': 'gender',
      'options': ['male', 'female'],
    },
    {
      'label': 'Race/Ethnicity',
      'key': 'raceEthnicity',
      'options': ['group A', 'group B', 'group C', 'group D', 'group E'],
    },
    {
      'label': 'Parental Education',
      'key': 'parentalEducation',
      'options': [
        'some high school',
        'high school',
        'some college',
        "associate's degree",
        "bachelor's degree",
        "master's degree"
      ],
    },
    {
      'label': 'Lunch',
      'key': 'lunch',
      'options': ['standard', 'free/reduced'],
    },
    {
      'label': 'Test Preparation',
      'key': 'testPrep',
      'options': ['none', 'completed'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Performance Predictor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dropdown fields
              ..._dropdownFields.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: _formData[field['key']],
                    decoration: InputDecoration(
                      labelText: field['label'],
                      border: const OutlineInputBorder(),
                    ),
                    items: (field['options'] as List<String>)
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _formData[field['key']] = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select ${field['label']}';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),

              // Reading Score
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Reading Score (0-100)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reading score';
                  }
                  final score = int.tryParse(value);
                  if (score == null || score < 0 || score > 100) {
                    return 'Please enter a valid score between 0-100';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData['readingScore'] = value!;
                },
              ),
              const SizedBox(height: 16),

              // Writing Score
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Writing Score (0-100)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter writing score';
                  }
                  final score = int.tryParse(value);
                  if (score == null || score < 0 || score > 100) {
                    return 'Please enter a valid score between 0-100';
                  }
                  return null;
                },
                onSaved: (value) {
                  _formData['writingScore'] = value!;
                },
              ),
              const SizedBox(height: 24),

              // Predict Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    
                    await Provider.of<PredictionProvider>(context, listen: false)
                        .predictPerformance(
                      gender: _formData['gender']!,
                      raceEthnicity: _formData['raceEthnicity']!,
                      parentalEducation: _formData['parentalEducation']!,
                      lunch: _formData['lunch']!,
                      testPrep: _formData['testPrep']!,
                      readingScore: _formData['readingScore']!,
                      writingScore: _formData['writingScore']!,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResultPage(),
                      ),
                    );
                  }
                },
                child: const Text('PREDICT MATH SCORE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}