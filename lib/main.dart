import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'profile_screen.dart';
import 'project_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GitConnect',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TRY THIS: Try changing the color here to a specific color (to
    // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
    // change color while the other colors stay the same.

    var color = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const ProfileScreen();
        break;
      case 1:
        page = const PeopleMatchingPage();
        break;
      case 2:
        page = const ProjectScreen();
        break;
      case 3:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
        backgroundColor: Color(0xFF212121),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Color(0xFF212121),
                  child: page,
                ),
              ),
              NavigationBar(
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                destinations: [
                  NavigationDestination(
                      icon: Icon(
                        Icons.account_box,
                        color: selectedIndex == 0
                            ? color.inversePrimary
                            : Colors.white,
                      ),
                      label: "Account"),
                  NavigationDestination(
                      icon: Icon(
                        Icons.person,
                        color: selectedIndex == 1
                            ? color.inversePrimary
                            : Colors.white,
                      ),
                      label: "People"),
                  NavigationDestination(
                      icon: Icon(
                        Icons.groups_3,
                        color: selectedIndex == 2
                            ? color.inversePrimary
                            : Colors.white,
                      ),
                      label: "Projects"),
                  NavigationDestination(
                      icon: Icon(
                        Icons.chat_bubble,
                        color: selectedIndex == 3
                            ? color.inversePrimary
                            : Colors.white,
                      ),
                      label: "Chats")
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                backgroundColor: Color(0xFF000000),
                indicatorColor: Colors.transparent,
              )
            ],
          ),
        ));
  }
}
