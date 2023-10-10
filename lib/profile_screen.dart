import 'package:flutter/material.dart';

var imageList = [
  'assets/profileImage1.jpg',
  'assets/profileImage2.jpg',
  'assets/profileImage3.jpg',
  'assets/profileImage4.jpg'
];

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Expanded(
        child: Container(
          color: const Color(0xFF212121),
          child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ProfileTitle(),
                  ),
                  Divider(
                    color: Colors.white.withOpacity(0.2),
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ProfileHeader(),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.white.withOpacity(0.2),
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ProfilePictures(),
                            SizedBox(height: 10),
                            ProfileSkills(),
                            SizedBox(height: 10),
                            ProfileInterests(),
                            SizedBox(height: 20)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
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
                height: 100,
                width: 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    image: const DecorationImage(
                      image: AssetImage("assets/profileIcon.jpg"),
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
                      "Irman Zafyree",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Flutter Developer",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
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
            child: Text("Bruh, how does this flutter thing work?",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
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
  const ProfilePictures({
    super.key,
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
              for (var image in imageList) ProfileImageWrapper(image: image)
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
              image: AssetImage(image),
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
  const ProfileSkills({
    super.key,
  });

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
              SkillChip(color: Colors.blue, label: "Flutter"),
              SkillChip(color: Colors.blue, label: "Flutter"),
              SkillChip(color: Colors.blue, label: "Flutter"),
              SkillChip(color: Colors.blue, label: "Flutter"),
            ],
          )
        ],
      ),
    );
  }
}

class ProfileInterests extends StatelessWidget {
  const ProfileInterests({
    super.key,
  });

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
              SkillChip(color: Colors.blue, label: "Flutter"),
              SkillChip(color: Colors.blue, label: "Flutter"),
              SkillChip(color: Colors.blue, label: "Flutter"),
              SkillChip(color: Colors.blue, label: "Flutter"),
            ],
          )
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
