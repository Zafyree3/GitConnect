import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gitmatch/api/projects.dart';
import 'package:gitmatch/models/project.dart';
import './widgets/chips.dart';

var _pageController = PageController(initialPage: 0);
var _pc = PanelController();

var activeImage = 0;

var _screenController = PageController(initialPage: 1);

var reloadProfiles = false;

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  OverlayEntry? entry;

  ProjectsAPI projectsProvider = ProjectsAPI();

  int selectedProject = 0;

  List<dynamic>? projects;

  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedProject = 0;
    });
    setState(() {
      activeImage = 0;
    });
    projectsProvider.getProjects().then((value) {
      setState(() {
        projects = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (projects == null) {
      return SafeArea(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              child: const CircularProgressIndicator()),
        ],
      )));
    }

    return GestureDetector(
      onTap: () {
        if (_pc.isPanelOpen) {
          _pc.close();
          return;
        }

        activeImage++;
        if (activeImage == projects![selectedProject].pictures.length) {
          activeImage = 0;
        }

        _pageController.animateToPage(activeImage,
            duration: Duration(milliseconds: activeImage == 0 ? 600 : 300),
            curve: Curves.easeInOut);
      },
      onDoubleTap: () {
        if (_pc.isPanelOpen) {
          _pc.close();
          return;
        }

        setState(() {
          selectedProject++;
          if (selectedProject == projects!.length) {
            selectedProject = 0;
          }

          _pageController.animateToPage(0,
              duration: Duration(milliseconds: 600), curve: Curves.easeInOut);

          activeImage = 0;
        });
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
          ImageCarousel(activeProject: projects![selectedProject]),
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
          ProjectMiniInfo(activeProject: projects![selectedProject]),
          SlidingUpPanel(
            controller: _pc,
            panel: ProjectInfo(activeProject: projects![selectedProject]),
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
  final Project activeProject;

  const ProjectMiniInfo({
    super.key,
    required this.activeProject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(activeProject.name,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(activeProject.type,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white)),
          const SizedBox(height: 5),
          Text(activeProject.tagline,
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
  final Project activeProject;

  const ProjectInfo({
    super.key,
    required this.activeProject,
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
          Text(activeProject.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(activeProject.type,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white)),
          const SizedBox(height: 3),
          Text(
            activeProject.tagline,
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
                          activeProject.description,
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
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            for (var tech in activeProject.tech)
                              SkillChip(
                                color: Color(int.parse(tech.hex.substring(1, 7),
                                        radix: 16) +
                                    0xFF000000),
                                label: tech.name,
                              )
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

class ImageCarousel extends StatefulWidget {
  final Project activeProject;

  const ImageCarousel({super.key, required this.activeProject});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  @override
  Widget build(BuildContext context) {
    var imageList = widget.activeProject.pictures;

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
              image: Image.network(imageList[pagePosition]).image,
              fit: BoxFit.cover);
        });
  }
}
