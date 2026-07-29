import 'package:flutter/material.dart';

void main() {
  runApp(const LevelUpStudyApp());
}

class LevelUpStudyApp extends StatelessWidget {
  const LevelUpStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LevelUp Study',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF0EA5E9),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: const MainHomeScreen(),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int totalXP = 120;
  int currentLevel = 2;
  int streakDays = 5;
  bool isProUser = false;

  final Map<String, List<Question>> subjectQuestions = {
    'Physics': [
      Question(
        questionText: 'What is the SI unit of Force?',
        options: ['Joule', 'Newton', 'Watt', 'Pascal'],
        correctAnswerIndex: 1,
        explanation: 'Force is measured in Newtons (N), named after Isaac Newton.',
      ),
      Question(
        questionText: 'Which law states that action and reaction are equal and opposite?',
        options: ['Newton\'s 1st Law', 'Newton\'s 2nd Law', 'Newton\'s 3rd Law', 'Hooke\'s Law'],
        correctAnswerIndex: 2,
        explanation: 'Newton\'s 3rd Law states every action has an equal and opposite reaction.',
      ),
    ],
    'Math': [
      Question(
        questionText: 'Solve for x: 2x + 6 = 14',
        options: ['x = 2', 'x = 4', 'x = 6', 'x = 8'],
        correctAnswerIndex: 1,
        explanation: '2x = 14 - 6 => 2x = 8 => x = 4.',
      ),
      Question(
        questionText: 'What is the square root of 144?',
        options: ['10', '11', '12', '14'],
        correctAnswerIndex: 2,
        explanation: '12 multiplied by 12 equals 144.',
      ),
    ],
    'Chemistry': [
      Question(
        questionText: 'What is the chemical symbol for Gold?',
        options: ['Ag', 'Au', 'Fe', 'Hg'],
        correctAnswerIndex: 1,
        explanation: 'Au comes from the Latin word for gold, Aurum.',
      ),
      Question(
        questionText: 'What is the pH level of pure water?',
        options: ['5', '7', '9', '14'],
        correctAnswerIndex: 1,
        explanation: 'Pure water is neutral with a pH of 7.',
      ),
    ],
    'English': [
      Question(
        questionText: 'Identify the verb in: "The swift runner won the race effortlessly."',
        options: ['swift', 'runner', 'won', 'effortlessly'],
        correctAnswerIndex: 2,
        explanation: '"Won" is the action verb performed by the subject.',
      ),
    ],
  };

  void addXP(int xp) {
    setState(() {
      totalXP += xp;
      if (totalXP >= currentLevel * 150) {
        currentLevel++;
      }
    });
  }

  void showRewardAdDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('📺 Watch Video Ad', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Watch a short sponsored video to claim +50 Extra XP instantly!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            onPressed: () {
              Navigator.pop(context);
              addXP(50);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Ad Completed! You earned +50 XP!'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            child: const Text('Watch Ad (+50 XP)'),
          ),
        ],
      ),
    );
  }

  void showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('👑 Upgrade to Pro', style: TextStyle(color: Colors.amber)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• 🚫 Remove all Banner & Video Ads', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Text('• 🔓 Unlock All Premium Quiz Banks', style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Text('• ⚡ 2x XP Booster on every completed quiz', style: TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                isProUser = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('👑 Welcome to LevelUp Pro! Ads Removed!'),
                  backgroundColor: Colors.amber,
                ),
              );
            },
            child: const Text('Upgrade - $2.99/mo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        title: const Text(
          'LevelUp Study 🚀',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.workspace_premium, color: isProUser ? Colors.amber : Colors.white54),
            onPressed: showUpgradeDialog,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Header Stats Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level $currentLevel Scholar 🎓',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.local_fire_department, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '$streakDays Days',
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: (totalXP % 150) / 150,
                          backgroundColor: Colors.white24,
                          color: const Color(0xFF10B981),
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Total XP: $totalXP',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Rewarded Ad Bonus Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.5)),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.play_circle_fill, color: Colors.amber, size: 30),
                      title: const Text('Free Bonus XP!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: const Text('Watch a short video ad to claim +50 XP', style: TextStyle(fontSize: 12, color: Colors.white54)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                        onPressed: showRewardAdDialog,
                        child: const Text('+50 XP', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Select a Subject to Practice:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Subject Selection List
                  ...subjectQuestions.keys.map((subject) {
                    return Card(
                      color: const Color(0xFF1E293B),
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF0EA5E9).withOpacity(0.2),
                          child: Icon(
                            subject == 'Physics'
                                ? Icons.science
                                : subject == 'Math'
                                    ? Icons.calculate
                                    : subject == 'Chemistry'
                                        ? Icons.biotech
                                        : Icons.menu_book,
                            color: const Color(0xFF0EA5E9),
                          ),
                        ),
                        title: Text(
                          subject,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        subtitle: Text(
                          '${subjectQuestions[subject]!.length} Quizzes Available',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                subject: subject,
                                questions: subjectQuestions[subject]!,
                                onComplete: (earnedXP) => addXP(earnedXP),
                                isProUser: isProUser,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Banner Ad Widget (Hidden if Pro)
          if (!isProUser)
            Container(
              width: double.infinity,
              height: 55,
              color: const Color(0xFF0284C7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('AD', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Sponsored: Get 50% Off Top Study Guides!',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final String subject;
  final List<Question> questions;
  final Function(int) onComplete;
  final bool isProUser;

  const QuizScreen({
    super.key,
    required this.subject,
    required this.questions,
    required this.onComplete,
    required this.isProUser,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  int? selectedOption;
  bool isSubmitted = false;
  int score = 0;

  void submitAnswer() {
    setState(() {
      isSubmitted = true;
      if (selectedOption == widget.questions[currentIndex].correctAnswerIndex) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
        isSubmitted = false;
      });
    } else {
      int earnedXP = score * 20;
      if (widget.isProUser) earnedXP *= 2; // 2x XP for Pro users
      widget.onComplete(earnedXP);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text('Quiz Completed! 🎉', style: TextStyle(color: Colors.white)),
          content: Text(
            'You scored $score / ${widget.questions.length}.\nYou earned +$earnedXP XP! ${widget.isProUser ? "(2x Pro Bonus Applied!)" : ""}',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0EA5E9)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Back to Dashboard'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = widget.questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject} Quiz'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${currentIndex + 1} of ${widget.questions.length}',
                    style: const TextStyle(color: Color(0xFF0EA5E9), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentQ.questionText,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Options list
                  ...List.generate(currentQ.options.length, (index) {
                    Color buttonColor = const Color(0xFF1E293B);
                    if (selectedOption == index) {
                      buttonColor = const Color(0xFF0EA5E9);
                    }
                    if (isSubmitted) {
                      if (index == currentQ.correctAnswerIndex) {
                        buttonColor = const Color(0xFF10B981);
                      } else if (selectedOption == index) {
                        buttonColor = Colors.redAccent;
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.all(16),
                          alignment: Alignment.centerLeft,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: isSubmitted
                            ? null
                            : () {
                                setState(() {
                                  selectedOption = index;
                                });
                              },
                        child: Text(
                          currentQ.options[index],
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    );
                  }),

                  const Spacer(),

                  if (isSubmitted)
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Explanation: ${currentQ.explanation}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: selectedOption == null
                          ? null
                          : (isSubmitted ? nextQuestion : submitAnswer),
                      child: Text(
                        isSubmitted ? 'Next Question' : 'Submit Answer',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Ad Banner inside quiz
          if (!widget.isProUser)
            Container(
              width: double.infinity,
              height: 50,
              color: const Color(0xFF1E293B),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('AD', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  const Text('LevelUp Pro: Remove Ads for $2.99/mo', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
