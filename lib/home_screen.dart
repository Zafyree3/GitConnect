import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gitmatch/api/users.dart';
import 'package:gitmatch/widgets/profile_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gitmatch/api/profiles.dart';
import 'package:gitmatch/models/profile.dart';
import 'package:provider/provider.dart';
import './widgets/chips.dart';

var _pageController = PageController(initialPage: 0);
var _pc = PanelController();

var _screenController = PageController(initialPage: 1);

var reloadProfiles = false;

class PeopleMatchingPage extends StatefulWidget {
  const PeopleMatchingPage({Key? key}) : super(key: key);

  @override
  State<PeopleMatchingPage> createState() => _PeopleMatchingPageState();
}

class _PeopleMatchingPageState extends State<PeopleMatchingPage> {
  ProfilesAPI myPocketBase = ProfilesAPI();

  List<dynamic>? profiles;

  @override
  void initState() {
    super.initState();

    myPocketBase.getProfiles().then((value) {
      setState(() {
        profiles = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (profiles == null) {
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
            reloadProfiles = true;
          });
        }
      },
      children: [
        InterestedProfiles(),
        buildProfiles(),
      ],
    );
  }

  Widget buildProfiles() {
    final provider = Provider.of<ProfileProvider>(context);
    final profilesList = provider.profiles;

    return Stack(
      children: profilesList.map((profile) {
        if (profilesList.last == profile) {
          return FrontProfileCard(profile: profile);
        }
        return BackProfileCard(profile: profile);
      }).toList(),
    );
  }
}

class InterestedProfiles extends StatefulWidget {
  const InterestedProfiles({Key? key}) : super(key: key);

  @override
  State<InterestedProfiles> createState() => _InterestedProfilesState();
}

class _InterestedProfilesState extends State<InterestedProfiles> {
  UsersAPI usersAPI = UsersAPI();
  ProfilesAPI profilesAPI = ProfilesAPI();

  List<dynamic> profiles = [];

  @override
  Widget build(BuildContext context) {
    if (reloadProfiles) {
      getInterestedProfiles().then((value) {
        setState(() {
          profiles = value;
        });
        reloadProfiles = false;
      });
    }

    if (profiles.isEmpty || reloadProfiles) {
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

  getInterestedProfiles() async {
    var interestedProfiles =
        await usersAPI.getUserInterestedUsersProfile("a3pnnxpcnwgjnab");

    var profiles = [];
    for (var profileId in interestedProfiles) {
      var profile = await profilesAPI.getProfile(profileId);
      profiles.add(profile);
    }

    return profiles;
  }

  Widget interestedScreen() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        children: [
          Text(
            "Interested Profiles",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                return buildInterestedProfile(profiles[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInterestedProfile(Profile profile) {
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
                    image: Image.network(profile.icon).image,
                    fit: BoxFit.cover)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white)),
                Text(profile.role,
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

class FrontProfileCard extends StatefulWidget {
  const FrontProfileCard({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  State<FrontProfileCard> createState() => _FrontProfileCardState();
}

class _FrontProfileCardState extends State<FrontProfileCard> {
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
        if (activeImage >= widget.profile.pictures.length) {
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

        provider.startPosition(details);
      },
      onPanUpdate: (details) {
        final provider = Provider.of<ProfileProvider>(context, listen: false);

        provider.updatePosition(details);
      },
      onPanEnd: (details) {
        final provider = Provider.of<ProfileProvider>(context, listen: false);

        provider.endPosition();
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final provider = Provider.of<ProfileProvider>(context);
          final position = provider.position;
          final milliseconds = provider.isDragging ? 500 : 0;

          if (provider.resetPicture) {
            activeImage = 0;
            _pageController.jumpToPage(0);
          }

          final center = MediaQuery.of(context).size.center(Offset.zero);
          final angle = provider.angle * pi / 180;
          final rotatedMatrix = Matrix4.identity()
            ..translate(center.dx, center.dy)
            ..rotateZ(angle)
            ..translate(-center.dx, -center.dy);

          return AnimatedContainer(
            onEnd: () {
              ((provider.isDragging, "end"));
            },
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: rotatedMatrix..translate(position.dx, position.dy),
            child: ProfileCard(profile: widget.profile),
          );
        },
      ),
    );
  }
}

class BackProfileCard extends StatelessWidget {
  const BackProfileCard({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      PageView.builder(itemBuilder: (context, pagePosition) {
        return Image(
            image: Image.network(profile.pictures[0]).image, fit: BoxFit.cover);
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
      ProfileMiniInfo(activeProfile: profile),
    ]);
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
    required this.profile,
  });

  final Profile profile;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
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
        ImageCarousel(activeProfile: widget.profile),
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
        ProfileMiniInfo(activeProfile: widget.profile),
        SlidingUpPanel(
          controller: _pc,
          panel: ProfileInfo(activeProfile: widget.profile),
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.5,
          borderRadius: radius,
          color: const Color(0xFF212121),
        )
      ],
    );
  }
}

class ProfileMiniInfo extends StatelessWidget {
  final Profile activeProfile;

  const ProfileMiniInfo({
    super.key,
    required this.activeProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(activeProfile.name,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(activeProfile.role,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white)),
          const SizedBox(height: 5),
          Text(activeProfile.bio,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ))
        ],
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final Profile activeProfile;

  const ProfileInfo({
    super.key,
    required this.activeProfile,
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
          Text(activeProfile.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(activeProfile.role,
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
                Text(activeProfile.bio,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ))
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
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (var skill in activeProfile.skills)
                        SkillChip(
                          color: Color(
                              int.parse(skill.hex.substring(1, 7), radix: 16) +
                                  0xFF000000),
                          label: skill.name,
                        )
                    ],
                  ),
                ],
              )),
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
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    for (var interest in activeProfile.interests)
                      SkillChip(
                        color: Color(
                            int.parse(interest.hex.substring(1, 7), radix: 16) +
                                0xFF000000),
                        label: interest.name,
                      )
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

class ImageCarousel extends StatefulWidget {
  final Profile activeProfile;

  const ImageCarousel({super.key, required this.activeProfile});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  @override
  Widget build(BuildContext context) {
    var imageList = widget.activeProfile.pictures;

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
