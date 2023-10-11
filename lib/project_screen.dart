import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gitmatch/api/projects.dart';
import 'package:gitmatch/api/users.dart';
import 'package:gitmatch/widgets/profile_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gitmatch/api/profiles.dart';
import 'package:gitmatch/models/profile.dart';
import 'package:provider/provider.dart';
import './widgets/chips.dart';
import 'package:gitmatch/models/project.dart';

var _pageController = PageController(initialPage: 0);
var _pc = PanelController();

var _screenController = PageController(initialPage: 1);

var reloadProjects = false;

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  ProjectsAPI projectsAPI = ProjectsAPI();

  List<dynamic>? projects;

  @override
  void initState() {
    super.initState();

    projectsAPI.getProjects().then((value) {
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
    return PageView(
      controller: _screenController,
      allowImplicitScrolling: true,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (value) {
        if (value == 0) {
          setState(() {
            reloadProjects = true;
          });
        }
      },
      children: [
        InterestedProjects(),
        buildProjects(),
      ],
    );
  }

  Widget buildProjects() {
    final provider = Provider.of<ProfileProvider>(context);
    final projectList = provider.projects;

    return Stack(
      children: projectList.map((project) {
        if (projectList.last == project) {
          return FrontProjectCard(project: project);
        }
        return BackProjectCard(project: project);
      }).toList(),
    );
  }
}

class InterestedProjects extends StatefulWidget {
  const InterestedProjects({Key? key}) : super(key: key);

  @override
  State<InterestedProjects> createState() => _InterestedProjectsState();
}

class _InterestedProjectsState extends State<InterestedProjects> {
  UsersAPI usersAPI = UsersAPI();
  ProjectsAPI projectsAPI = ProjectsAPI();

  List<dynamic> projects = [];

  @override
  Widget build(BuildContext context) {
    if (reloadProjects) {
      getInterestedProjects().then((value) {
        setState(() {
          projects = value;
        });
        reloadProjects = false;
      });
    }

    if (projects.isEmpty || reloadProjects) {
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
        onDoubleTap: () {
          _screenController.animateToPage(
              _screenController.page!.toInt() == 0 ? 1 : 0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut);
        },
        child: interestedScreen());
  }

  getInterestedProjects() async {
    var projects =
        await usersAPI.getUserInterestedProjectsDetails("a3pnnxpcnwgjnab");

    return projects;
  }

  Widget interestedScreen() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          Text(
            "Interested Projects",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return buildInterestedProjects(projects[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInterestedProjects(Project project) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 75,
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                image: DecorationImage(
                    image: Image.network(project.icon).image,
                    fit: BoxFit.cover)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white)),
                Text(project.type,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FrontProjectCard extends StatefulWidget {
  const FrontProjectCard({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  State<FrontProjectCard> createState() => _FrontProjectCardState();
}

class _FrontProjectCardState extends State<FrontProjectCard> {
  var activeImage = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_pc.isPanelOpen) {
          _pc.close();
          return;
        }

        activeImage++;
        if (activeImage >= widget.project.pictures.length) {
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

        _screenController.animateToPage(
            _screenController.page!.toInt() == 0 ? 1 : 0,
            duration: Duration(milliseconds: 300),
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
      onPanStart: (details) {
        final provider = Provider.of<ProfileProvider>(context, listen: false);

        provider.startPositionproject(details);
      },
      onPanUpdate: (details) {
        final provider = Provider.of<ProfileProvider>(context, listen: false);

        provider.updatePositionproject(details);
      },
      onPanEnd: (details) {
        final provider = Provider.of<ProfileProvider>(context, listen: false);

        provider.endPositionproject();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final provider = Provider.of<ProfileProvider>(context);
          final position = provider.positionproject;
          final milliseconds = provider.isDraggingproject ? 500 : 0;

          if (provider.resetPictureproject) {
            activeImage = 0;
            _pageController.jumpToPage(0);
          }

          final center = MediaQuery.of(context).size.center(Offset.zero);
          final angle = provider.angleproject * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotatedMatrix..translate(position.dx, position.dy),
            child: ProjectCard(project: widget.project),
          );
        },
      ),
    );
  }
}

class BackProjectCard extends StatelessWidget {
  const BackProjectCard({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      PageView.builder(itemBuilder: (context, pagePosition) {
        return Image(
            image: Image.network(project.pictures[0]).image, fit: BoxFit.cover);
      }),
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
      ProjectMiniInfo(activeProject: project),
    ]);
  }
}

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.project,
  });

  final Project project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageCarousel(activeProject: widget.project),
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
        ProjectMiniInfo(activeProject: widget.project),
        SlidingUpPanel(
          controller: _pc,
          panel: ProjectInfo(activeProject: widget.project),
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          borderRadius: radius,
          color: const Color(0xFF212121),
        )
      ],
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
        onPageChanged: (page) {},
        itemBuilder: (context, pagePosition) {
          return Image(
              image: Image.network(imageList[pagePosition]).image,
              fit: BoxFit.cover);
        });
  }
}
