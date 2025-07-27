import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/providers/prediction_provider.dart';
import 'package:flutter_app/pages/home_page.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PredictionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            provider.reset();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (provider.isLoading)
                const CircularProgressIndicator()
              else if (provider.error != null)
                Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      provider.error!,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else if (provider.predictedScore != null)
                Column(
                  children: [
                    const Text(
                      'Predicted Math Score:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.predictedScore!,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Icon(Icons.school, size: 48, color: Colors.green),
                  ],
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  provider.reset();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: const Text('MAKE ANOTHER PREDICTION'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}