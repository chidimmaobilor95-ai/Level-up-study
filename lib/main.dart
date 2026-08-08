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
// LOCAL AUTHENTICATION SCREEN
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
                'Duolingo-style learning for WAEC, JAMB & Beyond',
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
              const SizedBox(height: 12),
              const Text(
                '⚡ Offline Mode Active — Local Storage Enabled',
                style: TextStyle(color: Color(0xFF10B981), fontSize: 12),
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
  bool streakFrozen = false;
  bool isProMember = false;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      StudyDashboardScreen(
        userEmail: widget.userEmail,
        streakDays: streakDays,
        streakFrozen: streakFrozen,
        isProMember: isProMember,
        onWatchStreakAd: () {
          setState(() {
            streakDays++;
            streakFrozen = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('🔥 Ad Watched! Streak Protected (+1 Day)!'), backgroundColor: Color(0xFF10B981)),
          );
        },
      ),
      AITutorScreen(isPro: isProMember),
      ProSubscriptionScreen(
        isPro: isProMember,
        onUpgrade: () {
          setState(() {
            isProMember = true;
          });
        },
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Study Engine'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'AI Tutor'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Pro Pass'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// STUDY DASHBOARD & TOPIC SELECTOR
// -----------------------------------------------------------------------------
class StudyDashboardScreen extends StatelessWidget {
  final String userEmail;
  final int streakDays;
  final bool streakFrozen;
  final bool isProMember;
  final VoidCallback onWatchStreakAd;

  const StudyDashboardScreen({
    super.key,
    required this.userEmail,
    required this.streakDays,
    required this.streakFrozen,
    required this.isProMember,
    required this.onWatchStreakAd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        title: const Text('LevelUp Study 🚀', style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.amber, size: 28),
                          const SizedBox(width: 6),
                          Text(
                            '$streakDays Day Streak!',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: streakFrozen ? Colors.cyan : Colors.amber.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          streakFrozen ? '❄️ Streak Protected' : '🔥 Active',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Missed a day? Watch ad to revive', style: TextStyle(fontSize: 11, color: Colors.white70)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                        onPressed: onWatchStreakAd,
                        child: const Text('Watch Ad 📺', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Custom Topic & Subject Selection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SubjectTopicCard(
              subject: 'Mathematics',
              icon: Icons.calculate,
              color: const Color(0xFF0EA5E9),
              topics: const ['Linear Equations', 'Quadratic Expressions', 'Trigonometry', 'Calculus'],
              isPro: isProMember,
            ),
            SubjectTopicCard(
              subject: 'Physics',
              icon: Icons.science,
              color: const Color(0xFF8B5CF6),
              topics: const ['Linear Motion', 'Electromagnetism', 'Thermochemistry', 'Optics'],
              isPro: isProMember,
            ),
            SubjectTopicCard(
              subject: 'Chemistry',
              icon: Icons.biotech,
              color: const Color(0xFF10B981),
              topics: const ['Periodic Table', 'Stoichiometry', 'Organic Chemistry', 'Electrolysis'],
              isPro: isProMember,
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
  final bool isPro;

  const SubjectTopicCard({
    super.key,
    required this.subject,
    required this.icon,
    required this.color,
    required this.topics,
    required this.isPro,
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
        subtitle: const Text('50 Questions Per Level • Select Topic', style: TextStyle(fontSize: 12, color: Colors.white54)),
        children: topics.map((topic) {
          return ListTile(
            title: Text(topic, style: const TextStyle(fontSize: 14)),
            trailing: const Icon(Icons.play_arrow, color: Color(0xFF8B5CF6)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DuolingoQuizEngineScreen(
                    subject: subject,
                    topic: topic,
                    isPro: isPro,
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
// EDITABLE DUOLINGO-STYLE QUIZ ENGINE (FIXED SELECTION & CHANGEABLE OPTIONS)
// -----------------------------------------------------------------------------
class DuolingoQuizEngineScreen extends StatefulWidget {
  final String subject;
  final String topic;
  final bool isPro;

  const DuolingoQuizEngineScreen({
    super.key,
    required this.subject,
    required this.topic,
    required this.isPro,
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

  final List<Map<String, dynamic>> levelQuestions = List.generate(50, (index) {
    return {
      'questionText': 'Level 1 Question #${index + 1}: Solve for x in equation (${index + 1}x + 4 = 24)',
      'options': ['x = ${((20) / (index + 1)).toStringAsFixed(1)}', 'x = 2', 'x = 10', 'x = 0'],
      'correct': 0,
      'explanation': 'Subtract 4 from both sides (20), then divide 20 by ${index + 1}.',
    };
  });

  // Tapping an option updates the selection BEFORE checking answers
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
        content: const Text('Watch a 30-second ad to restore +2 extra lives and continue!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit Quiz', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                lives = 2;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('📺 Ad Watched! +2 Lives Restored!'), backgroundColor: Color(0xFF10B981)),
              );
            },
            child: const Text('Watch Ad to Revive (+2 ❤️)'),
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
          content: Text('Awesome job! You finished all 50 questions in ${widget.topic}.\nFinal Score: $score / 50'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Return to Home'),
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
        title: Text('${widget.topic}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  if (!isSubmitted && selectedOption != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(() => selectedOption = null),
                        child: const Text('Clear Choice 🔄', style: TextStyle(color: Colors.white54)),
                      ),
                    ),

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
          ),

          if (!widget.isPro)
            Container(
              width: double.infinity,
              height: 48,
              color: const Color(0xFF1E1B4B),
              child: const Center(
                child: Text('AD BANNER • Watch Ads or Upgrade to Pro ($9.99/mo)', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// INBUILT AI TUTOR (EDITABLE INPUT FIELD)
// -----------------------------------------------------------------------------
class AITutorScreen extends StatefulWidget {
  final bool isPro;
  const AITutorScreen({super.key, required this.isPro});

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

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
        aiResponse = "🧠 **LevelUp AI Step-by-Step Solution:**\n\n"
            "**Question:** ${promptController.text}\n\n"
            "1. **Breakdown:** Identify the primary variables.\n"
            "2. **Formula:** Apply standard exam calculation rules.\n"
            "3. **Result:** Verified step-by-step solution completed!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LevelUp AI Solver 🤖'),
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
                hintText: 'Type or edit your question here...',
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
                    : const Text('Solve Question with AI 🚀', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    aiResponse.isEmpty ? 'Your AI breakdown will appear here.' : aiResponse,
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

// -----------------------------------------------------------------------------
// PRO SUBSCRIPTION
// -----------------------------------------------------------------------------
class ProSubscriptionScreen extends StatelessWidget {
  final bool isPro;
  final VoidCallback onUpgrade;

  const ProSubscriptionScreen({super.key, required this.isPro, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LevelUp Pro Upgrade'),
        backgroundColor: const Color(0xFF1E1B4B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.workspace_premium, size: 80, color: Colors.amber),
            const SizedBox(height: 12),
            const Text(
              'LevelUp Pro Pass',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '\$9.99 / month',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✔ Unlimited AI Math & Chemistry Solver', style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  Text('✔ 100% Ad-Free Experience', style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  Text('✔ Infinite Hearts & Lives on 50-Question Levels', style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  Text('✔ Infinite Streak Freeze Protection', style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: isPro ? Colors.grey : Colors.amber),
                onPressed: isPro
                    ? null
                    : () {
                        onUpgrade();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🎉 Payment Approved! LevelUp Pro Activated!'),
                            backgroundColor: Colors.amber,
                          ),
                        );
                      },
                child: Text(
                  isPro ? 'Pro Subscription Active 🔥' : 'Subscribe Now (\$9.99/mo)',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Linked to Mom\'s Payment Account / Local Gateway',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
