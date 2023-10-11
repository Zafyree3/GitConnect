import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gitmatch/api/profiles.dart';
import 'package:gitmatch/api/projects.dart';

import 'home_screen.dart';
import 'profile_screen.dart';
import 'project_screen.dart';
import 'widgets/profile_provider.dart';

void main() async {
  var profiles = await ProfilesAPI().getProfiles();
  var projects = await ProjectsAPI().getProjects();
  runApp(MyApp(profiles: profiles, projects: projects));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.profiles, required this.projects});

  final List<dynamic> profiles;
  final List<dynamic> projects;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(profiles, projects),
      child: MaterialApp(
          title: 'GitConnect',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            useMaterial3: true,
          ),
          home: const HomeScreen()),
    );
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
        page = const ProjectScreen(); //ProjectScreen();
        break;
      case 3:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(
                icon: Icon(
                  Icons.account_box,
                  color:
                      selectedIndex == 0 ? color.inversePrimary : Colors.white,
                ),
                label: "Account"),
            NavigationDestination(
                icon: Icon(
                  Icons.person,
                  color:
                      selectedIndex == 1 ? color.inversePrimary : Colors.white,
                ),
                label: "People"),
            NavigationDestination(
                icon: Icon(
                  Icons.groups_3,
                  color:
                      selectedIndex == 2 ? color.inversePrimary : Colors.white,
                ),
                label: "Projects"),
            NavigationDestination(
                icon: Icon(
                  Icons.chat_bubble,
                  color:
                      selectedIndex == 3 ? color.inversePrimary : Colors.white,
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
        ),
        backgroundColor: Color(0xFF212121),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              AppBar(
                backgroundColor: Color(0xFF212121),
                toolbarHeight: 0,
              ),
              Expanded(
                child: Container(
                  color: Color(0xFF212121),
                  child: page,
                ),
              ),
            ],
          ),
        ));
  }
}
