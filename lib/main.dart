import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:ui';

void main() {
  runApp(ClockApp());
}

class ClockApp extends StatefulWidget {
  @override
  _ClockAppState createState() => _ClockAppState();
}

class _ClockAppState extends State<ClockApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock App',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF8F8F2),
        appBarTheme: AppBarTheme(
          color: Color(0xFFF8F8F2), // Light mode AppBar color
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF282A36),
        appBarTheme: AppBarTheme(
          color: Color(0xFF44475A), // Dark mode AppBar color
        ),
      ),
      themeMode: _themeMode,
      home: ClockHomePage(
        themeMode: _themeMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }
}

class ClockHomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  ClockHomePage({required this.themeMode, required this.toggleTheme});

  @override
  _ClockHomePageState createState() => _ClockHomePageState();
}

class _ClockHomePageState extends State<ClockHomePage> {
  late String _timeString;
  late String _dateString;
  late Timer _timer;
  bool _is24HourFormat = true;

  @override
  void initState() {
    super.initState();
    _updateTimeStrings();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTimeStrings());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimeStrings() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = _formatTime(now);
      _dateString = _formatDate(now);
    });
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat(_is24HourFormat ? 'HH:mm:ss' : 'hh:mm:ss a').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, MMMM d, y').format(dateTime);
  }

  void _toggleTimeFormat() {
    setState(() {
      _is24HourFormat = !_is24HourFormat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.themeMode == ThemeMode.dark ? Color(0xFFF8F8F2) : Color(0xFF44475A);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Clock App',
          style: TextStyle(color: widget.themeMode == ThemeMode.dark ? Colors.white : Colors.black),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        backgroundColor: widget.themeMode == ThemeMode.light ? Color(0xFFF8F8F2) : Color(0xFF44475A),
        iconTheme: IconThemeData(color: widget.themeMode == ThemeMode.light ? Colors.black : Colors.white),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '12h',
                        style: TextStyle(
                          color: _is24HourFormat ? Colors.white : Color(0xFFFF79C6),
                        ),
                      ),
                      Switch(
                        value: _is24HourFormat,
                        onChanged: (bool value) {
                          setState(() {
                            _is24HourFormat = value;
                          });
                        },
                      ),
                      Text(
                        '24h',
                        style: TextStyle(
                          color: _is24HourFormat ? Color(0xFFFF79C6) : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Theme',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: widget.themeMode == ThemeMode.dark,
                        onChanged: (bool value) {
                          widget.toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _timeString,
                style: TextStyle(
                  fontSize: screenSize.width * 0.1,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Text(
                _dateString,
                style: TextStyle(
                  fontSize: screenSize.width * 0.05,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
