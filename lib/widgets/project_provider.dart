// import 'package:flutter/material.dart';
// import 'package:gitmatch/api/users.dart';

// enum ProjectStatus { interest, uninterested, undecided }

// class ProjectProvider extends ChangeNotifier {
//   List<dynamic> _profiles = [];
//   bool _isDragging = false;
//   double _angle = 0;
//   Offset _position = Offset.zero;
//   Size _screenSize = Size.zero;
//   bool _resetPicture = false;

//   List<dynamic> get profiles => _profiles;
//   bool get isDragging => _isDragging;
//   Offset get position => _position;
//   double get angle => _angle;
//   bool get resetPicture => _resetPicture;

//   ProjectProvider(List<dynamic> profiles) {
//     setProfiles(profiles);
//   }

//   void setScreenSize(Size screenSize) {
//     _screenSize = screenSize;
//   }

//   void startPosition(DragStartDetails details) {
//     _isDragging = false;

//     notifyListeners();
//   }

//   void updatePosition(DragUpdateDetails details) {
//     _position += details.delta;

//     final x = _position.dx;
//     _angle = 45 * x / _screenSize.width;

//     notifyListeners();
//   }

//   void endPosition() {
//     final status = getStatus();

//     _isDragging = true;
//     notifyListeners();

//     switch (status) {
//       case ProjectStatus.interest:
//         interest();
//         break;
//       case ProjectStatus.uninterested:
//         uninterested();
//         break;
//       case ProjectStatus.undecided:
//         undecided();
//         break;
//       default:
//         resetPosition();
//     }
//   }

//   void resetPosition() {
//     _isDragging = false;
//     _position = Offset.zero;
//     _angle = 0;
//     _resetPicture = false;

//     notifyListeners();
//   }

//   void setProfiles(List<dynamic> profiles) {
//     _profiles = profiles.toList();
//     notifyListeners();
//   }

//   ProjectStatus? getStatus() {
//     final x = _position.dx;
//     final y = _position.dy;

//     final delta = 100;

//     if (x >= delta) {
//       return ProjectStatus.interest;
//     } else if (x <= -delta) {
//       return ProjectStatus.uninterested;
//     } else if (y <= -delta) {
//       return ProjectStatus.undecided;
//     } else if (y >= delta) {
//       return ProjectStatus.undecided;
//     }

//     return null;
//   }

//   void interest() {
//     _angle = 20;
//     _position += Offset(_screenSize.width * 2, 0);

//     _saveProfile();

//     _nextProfile();

//     notifyListeners();
//   }

//   void uninterested() {
//     _angle = -20;

//     _position += Offset(-_screenSize.width * 2, 0);
//     _nextProfile();

//     notifyListeners();
//   }

//   void undecided() {
//     _angle = 0;

//     final y = _position.dy;

//     if (y <= 0) {
//       _position += Offset(0, -_screenSize.height * 2);
//     } else {
//       _position += Offset(0, _screenSize.height * 2);
//     }

//     _nextProfile();

//     notifyListeners();
//   }

//   Future _nextProfile() async {
//     await Future.delayed(Duration(milliseconds: 500));

//     _resetPicture = true;
//     notifyListeners();

//     await Future.delayed(Duration(milliseconds: 100));

//     resetPosition();

//     var temp = _profiles[_profiles.length - 1];
//     _profiles.removeAt(_profiles.length - 1);
//     _profiles.insert(0, temp);
//   }

//   Future _saveProfile() async {
//     var profile = _profiles[_profiles.length - 1];

//     UsersAPI api = UsersAPI();

//     var user = await api.getUserFromProfileId(profile.id);

//     await api.patchUserWithInterestedProjects("a3pnnxpcnwgjnab", user.id);
//   }
// }
