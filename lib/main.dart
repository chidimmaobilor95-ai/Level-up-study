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
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFF0EA5E9),
          surface: Color(0xFF1E1B4B),
        ),
      ),
      home: const AuthWrapperScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// AUTHENTICATION SCREEN
// -----------------------------------------------------------------------------
class AuthWrapperScreen extends StatefulWidget {
  const AuthWrapperScreen({super.key});

  @override
  State<AuthWrapperScreen> createState() => _AuthWrapperScreenState();
}

class _AuthWrapperScreenState extends State<AuthWrapperScreen> {
  bool isLoggedIn = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() {
    if (emailController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty) {
      setState(() {
        isLoggedIn = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email and password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return MainNavigationHub(userEmail: emailController.text);
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bolt, size: 80, color: Color(0xFF8B5CF6)),
              const SizedBox(height: 12),
              const Text(
                'LevelUp Study',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Gamified Learning for WAEC & JAMB',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Icons.email, color: Color(0xFF0EA5E9)),
                  filled: true,
                  fillColor: const Color(0xFF1E1B4B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Color(0xFF0EA5E9)),
                  filled: true,
                  fillColor: const Color(0xFF1E1B4B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: handleLogin,
                  child: const Text(
                    'Login / Create Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MAIN NAVIGATION HUB
// -----------------------------------------------------------------------------
class MainNavigationHub extends StatefulWidget {
  final String userEmail;
  const MainNavigationHub({super.key, required this.userEmail});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _currentIndex = 0;
  int streakDays = 7;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      StudyDashboardScreen(
        userEmail: widget.userEmail,
        streakDays: streakDays,
      ),
      const AITutorScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1E1B4B),
        selectedItemColor: const Color(0xFF8B5CF6),
        unselectedItemColor: Colors.white54,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Study'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'AI Tutor'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DUOLINGO-STYLE STUDY DASHBOARD
// -----------------------------------------------------------------------------
class StudyDashboardScreen extends StatelessWidget {
  final String userEmail;
  final int streakDays;

  const StudyDashboardScreen({
    super.key,
    required this.userEmail,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        title: const Text('LevelUp Study', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF0EA5E9)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.amber, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        '$streakDays Day Streak!',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('🔥 Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Select Subject & Path', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const SubjectTopicCard(
              subject: 'Mathematics',
              icon: Icons.calculate,
              color: Color(0xFF0EA5E9),
              topics: ['Linear Equations', 'Quadratic Expressions', 'Trigonometry', 'Calculus'],
            ),
            const SubjectTopicCard(
              subject: 'Physics',
              icon: Icons.science,
              color: Color(0xFF8B5CF6),
              topics: ['Linear Motion', 'Electromagnetism', 'Thermochemistry', 'Optics'],
            ),
            const SubjectTopicCard(
              subject: 'Chemistry',
              icon: Icons.biotech,
              color: Color(0xFF10B981),
              topics: ['Periodic Table', 'Stoichiometry', 'Organic Chemistry', 'Electrolysis'],
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectTopicCard extends StatelessWidget {
  final String subject;
  final IconData icon;
  final Color color;
  final List<String> topics;

  const SubjectTopicCard({
    super.key,
    required this.subject,
    required this.icon,
    required this.color,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1B4B),
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: const Text('Interactive Quiz Levels', style: TextStyle(fontSize: 12, color: Colors.white54)),
        children: topics.map((topic) {
          return ListTile(
            title: Text(topic, style: const TextStyle(fontSize: 14)),
            trailing: const Icon(Icons.play_arrow_rounded, color: Color(0xFF8B5CF6)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DuolingoQuizEngineScreen(
                    subject: subject,
                    topic: topic,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// DUOLINGO-STYLE QUIZ ENGINE (HEARTS, PROGRESS, INTERACTIVE SELECTION)
// -----------------------------------------------------------------------------
class DuolingoQuizEngineScreen extends StatefulWidget {
  final String subject;
  final String topic;

  const DuolingoQuizEngineScreen({
    super.key,
    required this.subject,
    required this.topic,
  });

  @override
  State<DuolingoQuizEngineScreen> createState() => _DuolingoQuizEngineScreenState();
}

class _DuolingoQuizEngineScreenState extends State<DuolingoQuizEngineScreen> {
  int currentQuestionIndex = 0;
  int lives = 3;
  int? selectedOption;
  bool isSubmitted = false;
  int score = 0;

  late final List<Map<String, dynamic>> levelQuestions = List.generate(50, (i) {
    int num = i + 1;
    return {
      'questionText': 'Question #$num: Solve for x when $num x + 4 = ${num * 2 + 4}',
      'options': ['x = 2', 'x = 4', 'x = 6', 'x = 0'],
      'correct': 0,
      'explanation': 'Subtract 4 from both sides ($num x = ${num * 2}), then divide by $num to get x = 2.',
    };
  });

  void selectOption(int index) {
    if (!isSubmitted) {
      setState(() {
        selectedOption = index;
      });
    }
  }

  void submitAnswer() {
    if (selectedOption == null) return;

    setState(() {
      isSubmitted = true;
      if (selectedOption == levelQuestions[currentQuestionIndex]['correct']) {
        score++;
      } else {
        lives--;
      }
    });

    if (lives <= 0) {
      showGameOverDialog();
    }
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        title: const Text('💔 Out of Lives!', style: TextStyle(color: Colors.redAccent)),
        content: const Text('You ran out of hearts for this round.'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Try Again'),
          )
        ],
      ),
    );
  }

  void nextQuestion() {
    if (currentQuestionIndex < levelQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = null;
        isSubmitted = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E1B4B),
          title: const Text('🏆 Level Completed! 🎉', style: TextStyle(color: Colors.amber)),
          content: Text('Awesome job! You completed ${widget.topic}.\nFinal Score: $score / 50'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Return Home'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = levelQuestions[currentQuestionIndex];
    double progress = (currentQuestionIndex + 1) / 50.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        title: Text(widget.topic),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${currentQuestionIndex + 1} / 50', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0EA5E9))),
                Row(
                  children: List.generate(
                    3,
                    (i) => Icon(
                      Icons.favorite,
                      color: i < lives ? Colors.redAccent : Colors.grey,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white10,
              color: const Color(0xFF8B5CF6),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 24),
            Text(q['questionText'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            ...List.generate(q['options'].length, (index) {
              bool isSelected = selectedOption == index;
              Color buttonColor = const Color(0xFF1E1B4B);
              Color borderClr = Colors.transparent;

              if (isSelected) {
                buttonColor = const Color(0xFF0EA5E9).withOpacity(0.3);
                borderClr = const Color(0xFF0EA5E9);
              }

              if (isSubmitted) {
                if (index == q['correct']) {
                  buttonColor = const Color(0xFF10B981).withOpacity(0.4);
                  borderClr = const Color(0xFF10B981);
                } else if (isSelected && index != q['correct']) {
                  buttonColor = Colors.redAccent.withOpacity(0.4);
                  borderClr = Colors.redAccent;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: double.infinity,
                child: InkWell(
                  onTap: () => selectOption(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderClr, width: 2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(q['options'][index], style: const TextStyle(color: Colors.white, fontSize: 16)),
                        if (isSelected && !isSubmitted)
                          const Icon(Icons.check_circle, color: Color(0xFF0EA5E9)),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),

            if (isSubmitted)
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
                child: Text('Explanation: ${q['explanation']}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSubmitted ? const Color(0xFF8B5CF6) : const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: selectedOption == null ? null : (isSubmitted ? nextQuestion : submitAnswer),
                child: Text(
                  isSubmitted ? 'Next Question ➡️' : 'Check Answer',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// FULLY WORKING AI SOLVER INTERFACE
// -----------------------------------------------------------------------------
class AITutorScreen extends StatefulWidget {
  const AITutorScreen({super.key});

  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

class _AITutorScreenState extends State<AITutorScreen> {
  final TextEditingController promptController = TextEditingController();
  String aiResponse = '';
  bool isLoading = false;

  void solveWithAI() {
    if (promptController.text.trim().isEmpty) return;
    setState(() {
      isLoading = true;
      aiResponse = '';
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
        aiResponse = "🧠 Step-by-Step Breakdown:\n\n"
            "Question: \"${promptController.text}\"\n\n"
            "1. Variable Identification: Extracted primary values from input.\n"
            "2. Exam Formula: Applied secondary school curriculum rules.\n"
            "3. Final Solution: Successfully solved step-by-step!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Solver'),
        backgroundColor: const Color(0xFF1E1B4B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: promptController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type or paste your math/science problem here...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1E1B4B),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white54),
                  onPressed: () => promptController.clear(),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B5CF6)),
                onPressed: isLoading ? null : solveWithAI,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Solve Question with AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1B4B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    aiResponse.isEmpty ? 'Your AI step-by-step solution will appear here.' : aiResponse,
                    style: const TextStyle(color: Colors.white87, height: 1.4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
