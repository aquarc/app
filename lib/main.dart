import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'sat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'aquarc',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'aquarc'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _pages = <Widget>[
    Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                'Welcome to aquarc!',
                // increase that size
                style: TextStyle(fontSize: 30),
            ),
            Text(
                'Send an email to contact@aquarc.org',
            ),
          ],
        ),
      ),

      SatPage(),
      Text('ECs', style: TextStyle(fontSize: 30),),
      Text('Forum', style: TextStyle(fontSize: 30),),
      Text('Settings', style: TextStyle(fontSize: 30),),

  ];


  @override
  Widget build(BuildContext context) {
    var ChooseBar = BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.quiz),
                label: 'SAT',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'ECs',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: 'Forum',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
            ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        currentIndex: _selectedIndex,
        onTap: _OnIconTapped,
    );

    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: ChooseBar,
    );
  }

  void _OnIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
