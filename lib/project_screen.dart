import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

var _pageController = PageController(initialPage: 0);
var _pc = PanelController();

var activeImage = 0;
var imageList = [
  'assets/projectImage1.png',
  'assets/projectImage2.png',
  'assets/projectImage3.png',
  'assets/projectImage4.png',
  'assets/projectImage5.png',
];

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
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
          _pc.close();
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
          const ProjectMiniInfo(),
          SlidingUpPanel(
            controller: _pc,
            panel: const ProjectInfo(),
            minHeight: 0,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            borderRadius: radius,
            color: const Color(0xFF212121),
          )
        ],
      ),
    );
  }
}

class ProjectMiniInfo extends StatelessWidget {
  const ProjectMiniInfo({
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
          Text('Study Buddy Pal',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text("Software Application",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white)),
          const SizedBox(height: 5),
          Text("The cute doggy companion app to help students",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ))
        ],
      ),
    );
  }
}

class ProjectInfo extends StatelessWidget {
  const ProjectInfo({
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
          Text("Study Buddy Pal",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("Software Application",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white)),
          const SizedBox(height: 3),
          Text(
            "The cute doggy companion app to help students",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: color.inversePrimary,
                                    fontWeight: FontWeight.bold)),
                        Text(
                          "Students struggle to focus when doing their homework or studying. They also face inconviences like having to open up an app to see bus timings. This app solves both problems in a cute and game-like way.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.fade,
                        ),
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
                        Text("Technolgy Used",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
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
                ],
              ),
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
