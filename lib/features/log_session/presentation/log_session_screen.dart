import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../data/session_model.dart';

class LogSessionScreen extends ConsumerStatefulWidget {
  const LogSessionScreen({super.key});

  @override
  ConsumerState<LogSessionScreen> createState() => _LogSessionScreenState();
}

class _LogSessionScreenState extends ConsumerState<LogSessionScreen> {
  DateTime _date = DateTime.now();
  SessionResult _result = SessionResult.win;
  final _scoreController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  bool _postToFeed = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _scoreController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter session duration')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            Icon(Icons.check_circle, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(_postToFeed ? 'Session logged & posted!' : 'Session logged!'),
          ]),
          backgroundColor: AppTheme.surface,
        ),
      );
      setState(() => _isSubmitting = false);
      _scoreController.clear();
      _durationController.clear();
      _notesController.clear();
      setState(() {
        _date = DateTime.now();
        _result = SessionResult.win;
        _postToFeed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text('Log Session')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            Text('Date', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: AppTheme.primary,
                        surface: AppTheme.surface,
                      ),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppTheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Text('${_date.day}/${_date.month}/${_date.year}',
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Result
            Text('Result', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(children: SessionResult.values.map((r) {
              final isSelected = _result == r;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _result = r),
                  child: Container(
                    margin: EdgeInsets.only(right: r != SessionResult.practice ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? _resultColor(r).withOpacity(0.15) : AppTheme.surfaceRaised,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? _resultColor(r) : AppTheme.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(child: Text(
                      r.name.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? _resultColor(r) : AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
              );
            }).toList()),
            const SizedBox(height: 24),

            // Score
            Text('Score (optional)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _scoreController,
              style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 18, letterSpacing: 2),
              decoration: const InputDecoration(
                hintText: 'e.g. 6-3, 4-6, 7-5',
              ),
            ),
            const SizedBox(height: 24),

            // Duration
            Text('Duration (minutes)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 60',
                prefixIcon: Icon(Icons.timer_outlined),
              ),
            ),
            const SizedBox(height: 24),

            // Notes
            Text('Notes (optional)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Great rally, new technique tried...',
              ),
            ),
            const SizedBox(height: 24),

            // Post to feed toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.public, color: AppTheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Post to Feed', style: Theme.of(context).textTheme.titleLarge),
                        Text('Let your club see this session',
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Switch(
                    value: _postToFeed,
                    onChanged: (v) => setState(() => _postToFeed = v),
                    activeColor: AppTheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(width: 24, height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.check), SizedBox(width: 8), Text('Log Session')],
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Color _resultColor(SessionResult r) {
    switch (r) {
      case SessionResult.win: return AppTheme.primary;
      case SessionResult.loss: return AppTheme.error;
      case SessionResult.practice: return AppTheme.textSecondary;
    }
  }
}
