import 'package:flutter/material.dart';
import 'package:gitmatch/api/profiles.dart';
import 'package:gitmatch/api/users.dart';
import 'package:gitmatch/models/profile.dart';
import "./widgets/chips.dart";

// TODO: Add the Interested Projects When the projects is done

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfilesAPI myPocketBase = ProfilesAPI();

  Profile? data;

  @override
  void initState() {
    super.initState();

    myPocketBase.getProfile("pzux8k2m8p7w9yb").then((value) {
      setState(() {
        data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
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

    return Container(
      color: const Color(0xFF212121),
      child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: ProfileTitle(),
              ),
              Divider(
                color: Colors.white.withOpacity(0.1),
                thickness: 1,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ProfileHeader(
                  profile: data,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: Colors.white.withOpacity(0.1),
                thickness: 1,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ProfilePictures(
                          profile: data,
                        ),
                        const SizedBox(height: 10),
                        ProfileSkills(profile: data),
                        const SizedBox(height: 10),
                        ProfileInterests(profile: data),
                        const SizedBox(height: 10),
                        InterestedUsers(profile: data),
                        const SizedBox(height: 10),
                        InterestedProjects(profile: data),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class InterestedUsers extends StatelessWidget {
  final Profile? profile;

  const InterestedUsers({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Interested Users",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ProfileInterestedUsers(profile: profile)
      ],
    );
  }
}

class InterestedProjects extends StatelessWidget {
  final Profile? profile;

  const InterestedProjects({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Interested Projects",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ProfileInterestedProjects(profile: profile)
      ],
    );
  }
}

class ProfileInterestedUsers extends StatefulWidget {
  final Profile? profile;

  const ProfileInterestedUsers({super.key, required this.profile});

  @override
  State<ProfileInterestedUsers> createState() => _ProfileInterestedUsersState();
}

class _ProfileInterestedUsersState extends State<ProfileInterestedUsers> {
  List<dynamic> interestedUsers = [];

  @override
  Widget build(BuildContext context) {
    if (interestedUsers.isEmpty) {
      getInterestedUsers().then((value) {
        setState(() {
          interestedUsers = value;
        });
      });
    }

    if (interestedUsers.isEmpty) {
      return SizedBox(
        height: 75,
        width: double.infinity,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return userProfileIcon("");
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 20),
            itemCount: 5),
      );
    }

    return SizedBox(
      height: 75,
      width: double.infinity,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return userProfileIcon(interestedUsers[index]);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(width: 20),
          itemCount: interestedUsers.length),
    );
  }

  getInterestedUsers() async {
    UsersAPI userAPI = UsersAPI();
    ProfilesAPI profileAPI = ProfilesAPI();

    var user = await userAPI.getUserFromProfileId(widget.profile!.id);

    var iUsers = await userAPI.getUserInterestedUsersProfile(user.id);

    List<dynamic> iUsersProfile = [];
    for (var iUser in iUsers) {
      var iUserUser = await profileAPI.getProfile(iUser);

      iUsersProfile.add(iUserUser);
    }

    return iUsersProfile;
  }

  Widget userProfileIcon(profile) {
    if (profile == "") {
      return SizedBox(
        height: 75,
        width: 75,
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      height: 75,
      width: 75,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(
            image: Image.network(profile.icon).image,
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class ProfileInterestedProjects extends StatefulWidget {
  final Profile? profile;

  const ProfileInterestedProjects({super.key, required this.profile});

  @override
  State<ProfileInterestedProjects> createState() =>
      _ProfileInterestedProjectsState();
}

class _ProfileInterestedProjectsState extends State<ProfileInterestedProjects> {
  List<dynamic> interestedProjects = [];

  @override
  Widget build(BuildContext context) {
    if (interestedProjects.isEmpty) {
      getInterestedProjects().then((value) {
        setState(() {
          interestedProjects = value;
        });
      });
    }

    if (interestedProjects.isEmpty) {
      return SizedBox(
        height: 75,
        width: double.infinity,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return projectLogo("");
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 20),
            itemCount: 5),
      );
    }

    return SizedBox(
      height: 75,
      width: double.infinity,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return projectLogo(interestedProjects[index]);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(width: 20),
          itemCount: interestedProjects.length),
    );
  }

  getInterestedProjects() async {
    UsersAPI userAPI = UsersAPI();

    var user = await userAPI.getUserFromProfileId(widget.profile!.id);

    var iProjects = await userAPI.getUserInterestedProjectsDetails(user.id);

    return iProjects;
  }

  Widget projectLogo(project) {
    if (project == "") {
      return SizedBox(
        height: 75,
        width: 75,
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      height: 75,
      width: 75,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          image: DecorationImage(
            image: Image.network(project.icon).image,
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final Profile? profile;

  const ProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 75,
                width: 75,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: Image.network(profile!.icon).image,
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile!.name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      profile!.role,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(profile!.bio,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                    )),
          )
        ],
      ),
    );
  }
}

class ProfileTitle extends StatelessWidget {
  const ProfileTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Profile",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        Expanded(child: Container()),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.white)),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white))
      ],
    );
  }
}

class ProfilePictures extends StatelessWidget {
  final Profile? profile;

  const ProfilePictures({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pictures",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (var pictureURL in profile!.pictures)
                ProfileImageWrapper(image: pictureURL)
            ]),
          )
        ],
      ),
    );
  }
}

class ProfileImageWrapper extends StatelessWidget {
  final String image;

  const ProfileImageWrapper({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 320,
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: Image.network(image).image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

class ProfileSkills extends StatelessWidget {
  final Profile? profile;

  const ProfileSkills({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Skills",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              for (var skill in profile!.skills)
                SkillChip(
                    color: Color(
                        int.parse(skill.hex.substring(1, 7), radix: 16) +
                            0xFF000000),
                    label: skill.name)
            ],
          )
        ],
      ),
    );
  }
}

class ProfileInterests extends StatelessWidget {
  final Profile? profile;

  const ProfileInterests({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Interests",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              for (var interest in profile!.interests)
                SkillChip(
                    color: Color(
                        int.parse(interest.hex.substring(1, 7), radix: 16) +
                            0xFF000000),
                    label: interest.name)
            ],
          )
        ],
      ),
    );
  }
}
