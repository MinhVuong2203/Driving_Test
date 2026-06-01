import 'dart:math';

import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';
import 'package:driving_test_prep/data/repository/user_progress_repository.dart';
import 'package:flutter/material.dart';

final wrongQuestionReminderOverlayKey =
    GlobalKey<WrongQuestionReminderOverlayState>();

class WrongQuestionReminderOverlay extends StatefulWidget {
  const WrongQuestionReminderOverlay({super.key});

  @override
  State<WrongQuestionReminderOverlay> createState() =>
      WrongQuestionReminderOverlayState();
}

class WrongQuestionReminderOverlayState
    extends State<WrongQuestionReminderOverlay> {
  late final UserProgressRepository _repo = UserProgressRepository(
    UserProgressDao(DBProvider().db),
  );

  final _random = Random();

  Question? _question;
  bool _visible = false;

  Future<void> showFromNotification() async {
    await Future.delayed(const Duration(milliseconds: 220));
    await _showRandomWrongQuestion();
  }

  Future<void> _showRandomWrongQuestion() async {
    final wrongQuestions = await _repo.getWrongQuestions();
    if (!mounted || wrongQuestions.isEmpty) return;

    setState(() {
      _question = wrongQuestions[_random.nextInt(wrongQuestions.length)];
      _visible = true;
    });
  }

  void _dismiss() {
    setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    final q = _question;

    return Positioned(
      left: 12,
      right: 12,
      top: MediaQuery.of(context).padding.top + 12,
      child: IgnorePointer(
        ignoring: !_visible,
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _visible ? Offset.zero : const Offset(0, -0.08),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            child: q == null
                ? const SizedBox.shrink()
                : Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Ôn lại câu sai',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _dismiss,
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          Text(q.question),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
