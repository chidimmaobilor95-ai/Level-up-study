import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const LevelUpStudyApp());
}

class LevelUpStudyApp extends StatelessWidget {
  const LevelUpStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        colorScheme: const ColorScheme.dark(
          primary: Colors.lightBlueAccent,
          secondary: Colors.amberAccent,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  int xp = 0;
  int level = 1;
  int streak = 4;
  int completedCount = 0;

  List<Map<String, dynamic>> tasks = [
    {'title': 'Read Physics: Linear Motion', 'subject': 'Physics', 'xp': 50, 'done': false},
    {'title': 'Solve 10 Math Questions', 'subject': 'Math', 'xp': 100, 'done': false},
    {'title': 'Complete Chemistry Quiz', 'subject': 'Chemistry', 'xp': 75, 'done': false},
    {'title': 'English Grammar: Tenses', 'subject': 'English', 'xp': 50, 'done': false},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      xp = prefs.getInt('xp') ?? 0;
      level = prefs.getInt('level') ?? 1;
      streak = prefs.getInt('streak') ?? 4;
      completedCount = prefs.getInt('completedCount') ?? 0;

      String? savedTasks = prefs.getString('tasks');
      if (savedTasks != null) {
        tasks = List<Map<String, dynamic>>.from(jsonDecode(savedTasks));
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', xp);
    await prefs.setInt('level', level);
    await prefs.setInt('streak', streak);
    await prefs.setInt('completedCount', completedCount);
    await prefs.setString('tasks', jsonEncode(tasks));
  }

  void addXp(int amount) {
    setState(() {
      xp += amount;
      if (xp >= level * 150) {
        level++;
      }
    });
    _saveData();
  }

  void toggleTask(int index) {
    setState(() {
      bool isDone = tasks[index]['done'];
      tasks[index]['done'] = !isDone;

      if (!isDone) {
        completedCount++;
        addXp(tasks[index]['xp'] as int);
      } else {
        completedCount--;
        xp -= (tasks[index]['xp'] as int);
        if (xp < 0) xp = 0;
      }
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      TargetsTab(
        xp: xp,
        level: level,
        streak: streak,
        tasks: tasks,
        onToggleTask: toggleTask,
        onAddTask: (title, subject) {
          setState(() {
            tasks.add({'title': title, 'subject': subject, 'xp': 50, 'done': false});
          });
          _saveData();
        },
      ),
      TimerTab(onTimerComplete: () => addXp(50)),
      BadgesTab(level: level, xp: xp, completedCount: completedCount),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E293B),
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Targets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Focus Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Rewards',
          ),
        ],
      ),
    );
  }
}

class TargetsTab extends StatefulWidget {
  final int xp;
  final int level;
  final int streak;
  final List<Map<String, dynamic>> tasks;
  final Function(int) onToggleTask;
  final Function(String, String) onAddTask;

  const TargetsTab({
    super.key,
    required this.xp,
    required this.level,
    required this.streak,
    required this.tasks,
    required this.onToggleTask,
    required this.onAddTask,
  });

  @override
  State<TargetsTab> createState() => _TargetsTabState();
}

class _TargetsTabState extends State<TargetsTab> {
  String selectedFilter = 'All';
  final List<String> subjects = ['All', 'Math', 'Physics', 'Chemistry', 'English'];

  @override
  Widget build(BuildContext context) {
    final taskController = TextEditingController();
    String newSubject = 'Math';

    void showAddTaskDialog() {
      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            title: const Text('Add Study Target 🎯'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Read Biology Ch. 3',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Subject: ', style: TextStyle(color: Colors.grey)),
                    DropdownButton<String>(
                      value: newSubject,
                      dropdownColor: const Color(0xFF1E293B),
                      items: ['Math', 'Physics', 'Chemistry', 'English', 'Other']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => newSubject = val);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (taskController.text.trim().isNotEmpty) {
                    widget.onAddTask(taskController.text.trim(), newSubject);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlueAccent),
                child: const Text('Add (+50 XP)', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      );
    }

    final filteredTasks = selectedFilter == 'All'
        ? widget.tasks
        : widget.tasks.where((t) => t['subject'] == selectedFilter).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('LevelUp Study 🚀', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddTaskDialog,
        backgroundColor: Colors.lightBlueAccent,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('New Target', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Card(
                color: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Level ${widget.level} Scholar 🎓', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('🔥 ${widget.streak} Day Streak', style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (widget.xp % 150) / 150,
                          minHeight: 8,
                          color: Colors.greenAccent,
                          backgroundColor: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('XP Progress: ${widget.xp % 150}/150', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          Text('Total XP: ${widget.xp}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: subjects.map((subj) {
                    final isSelected = selectedFilter == subj;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(subj),
                        selected: isSelected,
                        selectedColor: Colors.lightBlueAccent,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: const Color(0xFF1E293B),
                        onSelected: (_) => setState(() => selectedFilter = subj),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    final realIndex = widget.tasks.indexOf(task);
                    return Card(
                      color: const Color(0xFF1E293B),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          task['done'] ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: task['done'] ? Colors.greenAccent : Colors.grey,
                        ),
                        title: Text(
                          task['title'],
                          style: TextStyle(
                            decoration: task['done'] ? TextDecoration.lineThrough : TextDecoration.none,
                            color: task['done'] ? Colors.grey : Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          task['subject'] ?? 'General',
                          style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 11),
                        ),
                        trailing: Text('+${task['xp']} XP', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                        onTap: () => widget.onToggleTask(realIndex),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerTab extends StatefulWidget {
  final VoidCallback onTimerComplete;

  const TimerTab({super.key, required this.onTimerComplete});

  @override
  State<TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab> {
  static const int defaultTime = 25 * 60;
  int secondsLeft = defaultTime;
  Timer? timer;
  bool isRunning = false;

  void startTimer() {
    if (timer != null) timer!.cancel();
    setState(() => isRunning = true);

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft > 0) {
        setState(() => secondsLeft--);
      } else {
        t.cancel();
        setState(() => isRunning = false);
        widget.onTimerComplete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Session Done! +50 XP Earned!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void pauseTimer() {
    if (timer != null) timer!.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    pauseTimer();
    setState(() => secondsLeft = defaultTime);
  }

  String get formattedTime {
    int minutes = secondsLeft ~/ 60;
    int seconds = secondsLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Focus Timer ⏱️', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1E293B),
                border: Border.all(color: Colors.lightBlueAccent, width: 4),
              ),
              alignment: Alignment.center,
              child: Text(
                formattedTime,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? pauseTimer : startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRunning ? Colors.amberAccent : Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  ),
                  child: Text(
                    isRunning ? 'Pause' : 'Start Focus',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: resetTimer,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text('Reset', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BadgesTab extends StatelessWidget {
  final int level;
  final int xp;
  final int completedCount;

  const BadgesTab({
    super.key,
    required this.level,
    required this.xp,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> badges = [
      {
        'title': 'First Step 👟',
        'desc': 'Complete your 1st target',
        'unlocked': completedCount >= 1,
      },
      {
        'title': 'Century XP 💯',
        'desc': 'Reach 100 total XP',
        'unlocked': xp >= 100,
      },
      {
        'title': 'Level Up 🎓',
        'desc': 'Reach Level 2 Scholar',
        'unlocked': level >= 2,
      },
      {
        'title': 'Target Master 🎯',
        'desc': 'Complete 5 study targets',
        'unlocked': completedCount >= 5,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Achievements 🏆', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: badges.length,
          itemBuilder: (context, index) {
            final badge = badges[index];
            final unlocked = badge['unlocked'] as bool;

            return Card(
              color: const Color(0xFF1E293B),
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: unlocked ? Colors.amberAccent : Colors.grey[800],
                  child: Icon(
                    unlocked ? Icons.military_tech : Icons.lock,
                    color: unlocked ? Colors.black : Colors.grey[500],
                  ),
                ),
                title: Text(
                  badge['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: unlocked ? Colors.white : Colors.grey[500],
                  ),
                ),
                subtitle: Text(
                  badge['desc'],
                  style: TextStyle(color: unlocked ? Colors.grey[300] : Colors.grey[600]),
                ),
                trailing: Text(
                  unlocked ? 'UNLOCKED' : 'LOCKED',
                  style: TextStyle(
                    color: unlocked ? Colors.amberAccent : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
