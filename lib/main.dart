import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {
  runApp(const MyApp());
}

var activeImage = 0;
var imageList = [
  'assets/profileImage1.jpg',
  'assets/profileImage2.jpg',
  'assets/profileImage3.jpg',
  'assets/profileImage4.jpg'
];

var _pageController = PageController(initialPage: 0);
var _pc = PanelController();

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
        page = const Placeholder();
        break;
      case 1:
        page = const PeopleMatchingPage();
        break;
      case 2:
        page = const Placeholder();
        break;
      case 3:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
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
                      label: "test"),
                  NavigationDestination(
                      icon: Icon(
                        Icons.groups_3,
                        color: selectedIndex == 2
                            ? color.inversePrimary
                            : Colors.white,
                      ),
                      label: "test"),
                  NavigationDestination(
                      icon: Icon(
                        Icons.numbers,
                        color: selectedIndex == 3
                            ? color.inversePrimary
                            : Colors.white,
                      ),
                      label: "test")
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

class PeopleMatchingPage extends StatefulWidget {
  const PeopleMatchingPage({super.key});

  @override
  State<PeopleMatchingPage> createState() => _PeopleMatchingPageState();
}

class _PeopleMatchingPageState extends State<PeopleMatchingPage> {
  OverlayEntry? entry;

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_pc.isPanelOpen) {
          return;
        }

        activeImage++;
        if (activeImage == imageList.length) {
          activeImage = 0;
        }

        _pageController.animateToPage(activeImage,
            duration: Duration(milliseconds: activeImage == 0 ? 600 : 300),
            curve: Curves.easeInOut);
      },
      onDoubleTap: () {
        print("double tap");
      },
      onVerticalDragUpdate: (details) {
        var sensitivity = 8;
        if (details.delta.dy < -sensitivity) {
          _pc.open();
        }
        if (details.delta.dy > sensitivity) {
          _pc.close();
        }
      },
      child: Stack(
        children: [
          const ImageCarousel(),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0),
                      Colors.black,
                    ],
                    stops: const <double>[
                      0.0,
                      0.2,
                      1.0
                    ])),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          const ProfileMiniInfo(),
          SlidingUpPanel(
            controller: _pc,
            panel: const ProfileInfo(),
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            borderRadius: radius,
            color: Color(0xFF212121),
          )
        ],
      ),
    );
  }
}

class ProfileMiniInfo extends StatelessWidget {
  const ProfileMiniInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Irman Zafyree',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 2),
          Text("Flutter Developer",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white)),
          SizedBox(height: 5),
          Text("Bruh, how does this flutter thing work?",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                  ))
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Irman Zafyree",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("Flutter Developer",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bio",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: color.inversePrimary,
                        fontWeight: FontWeight.bold)),
                Text("Bruh, how does this flutter thing work?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Colors.white))
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Skills",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: color.inversePrimary,
                        fontWeight: FontWeight.bold)),
                const Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    SkillChip(color: Colors.blue, label: "Flutter"),
                    SkillChip(color: Colors.blue, label: "Flutter"),
                    SkillChip(color: Colors.blue, label: "Flutter"),
                    SkillChip(color: Colors.blue, label: "Flutter"),
                    SkillChip(color: Colors.blue, label: "Flutter"),
                    SkillChip(color: Colors.blue, label: "Flutter"),
                    SkillChip(color: Colors.blue, label: "Flutter"),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Interests",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: color.inversePrimary,
                        fontWeight: FontWeight.bold)),
                const Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    SkillChip(color: Colors.blue, label: "Flutter"),
                    SkillChip(color: Colors.blue, label: "Flutter"),
                    SkillChip(color: Colors.blue, label: "Flutter"),
                    SkillChip(color: Colors.blue, label: "Flutter"),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final Color color;

  final String label;

  const SkillChip({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white)),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        itemCount: imageList.length,
        pageSnapping: true,
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            activeImage = page;
          });
        },
        itemBuilder: (context, pagePosition) {
          return Image(
              image: AssetImage(imageList[pagePosition]), fit: BoxFit.cover);
        });
  }
}
