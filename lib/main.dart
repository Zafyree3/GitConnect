import 'package:flutter/material.dart';

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
                            ? color.onPrimary
                            : color.inversePrimary,
                      ),
                      label: "Account"),
                  NavigationDestination(
                      icon: Icon(
                        Icons.person,
                        color: selectedIndex == 1
                            ? color.onPrimary
                            : color.inversePrimary,
                      ),
                      label: "test"),
                  NavigationDestination(
                      icon: Icon(
                        Icons.groups_3,
                        color: selectedIndex == 2
                            ? color.onPrimary
                            : color.inversePrimary,
                      ),
                      label: "test"),
                  NavigationDestination(
                      icon: Icon(
                        Icons.numbers,
                        color: selectedIndex == 3
                            ? color.onPrimary
                            : color.inversePrimary,
                      ),
                      label: "test")
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                backgroundColor: Colors.white,
                indicatorColor: Theme.of(context).colorScheme.inversePrimary,
              ),
            ],
          ),
        ));
  }
}

class PeopleMatchingPage extends StatelessWidget {
  const PeopleMatchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        activeImage++;
        if (activeImage == imageList.length) {
          activeImage = 0;
        }

        _pageController.animateToPage(activeImage,
            duration: Duration(milliseconds: activeImage == 0 ? 600 : 300),
            curve: Curves.easeInOut);
      },
      child: Stack(
        children: [
          ImageCarousel(),
          // Container(
          //   decoration: const BoxDecoration(
          //       color: Colors.transparent,
          //       image: DecorationImage(
          //           image: AssetImage("assets/profileImage1.jpg"),
          //           fit: BoxFit.fitHeight)),
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          // ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.0),
                      Colors.black,
                    ],
                    stops: const <double>[
                      0.0,
                      0.3,
                      1.0
                    ])),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Irman Zafyree',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("Flutter Developer",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white)),
                Text("Bruh, how does this flutter thing work?",
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Colors.white,
                        ))
              ],
            ),
          )
        ],
      ),
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
