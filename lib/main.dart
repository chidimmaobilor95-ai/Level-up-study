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
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Exam Prep & AI Learning Engine',
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

class MainNavigationHub extends StatefulWidget {
  final String userEmail;
  const MainNavigationHub({super.key, required this.userEmail});

  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      StudyDashboardScreen(userEmail: widget.userEmail),
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

class StudyDashboardScreen extends StatelessWidget {
  final String userEmail;

  const StudyDashboardScreen({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        title: const Text('LevelUp Study 🚀'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Card(
            color: Color(0xFF1E1B4B),
            child: ListTile(
              leading: Icon(Icons.calculate, color: Color(0xFF0EA5E9)),
              title: Text('Mathematics'),
              subtitle: Text('Algebra, Calculus, Trigonometry'),
            ),
          ),
          Card(
            color: Color(0xFF1E1B4B),
            child: ListTile(
              leading: Icon(Icons.science, color: Color(0xFF8B5CF6)),
              title: Text('Physics'),
              subtitle: Text('Motion, Magnetism, Thermochemistry'),
            ),
          ),
        ],
      ),
    );
  }
}

class AITutorScreen extends StatelessWidget {
  const AITutorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Solver'),
        backgroundColor: const Color(0xFF1E1B4B),
      ),
      body: const Center(
        child: Text('AI Learning Module Ready', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
