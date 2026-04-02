import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';

class InterestQuizScreen extends StatefulWidget {
  const InterestQuizScreen({super.key});

  @override
  State<InterestQuizScreen> createState() => _InterestQuizScreenState();
}

class _InterestQuizScreenState extends State<InterestQuizScreen> {
  final List<String> interests = [
    'IT',
    'Business',
    'Medicine',
    'Design',
    'Engineering',
    'Education',
  ];

  final Set<String> selected = {};

  void toggleInterest(String value) {
    setState(() {
      if (selected.contains(value)) {
        selected.remove(value);
      } else {
        selected.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.quizTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              loc.quizTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              loc.quizSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: interests.map((item) {
                  return ChoiceChip(
                    label: Text(item),
                    selected: selected.contains(item),
                    onSelected: (_) => toggleInterest(item),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/main');
                },
                child: Text(loc.continueText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}