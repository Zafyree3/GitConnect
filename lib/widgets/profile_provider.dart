import 'package:flutter/material.dart';
import 'package:gitmatch/api/users.dart';

enum ProfileStatus { interest, uninterested, undecided }

enum ProjectStatus { interest, uninterested, undecided }

class ProfileProvider extends ChangeNotifier {
  List<dynamic> _profiles = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  bool _resetPicture = false;

  List<dynamic> get profiles => _profiles;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;
  bool get resetPicture => _resetPicture;

  Size _screenSize = Size.zero;

  List<dynamic> _projects = [];
  bool _isDraggingproject = false;
  double _angleproject = 0;
  Offset _positionproject = Offset.zero;
  bool _resetPictureproject = false;

  List<dynamic> get projects => _projects;
  bool get isDraggingproject => _isDraggingproject;
  Offset get positionproject => _positionproject;
  double get angleproject => _angleproject;
  bool get resetPictureproject => _resetPictureproject;

  ProfileProvider(List<dynamic> profiles, List<dynamic> project) {
    setProfiles(profiles);
    setProjects(project);
  }

  void setScreenSize(Size screenSize) {
    _screenSize = screenSize;
  }

  void startPosition(DragStartDetails details) {
    _isDragging = false;

    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    final status = getStatus();

    _isDragging = true;
    notifyListeners();

    switch (status) {
      case ProfileStatus.interest:
        interest();
        break;
      case ProfileStatus.uninterested:
        uninterested();
        break;
      case ProfileStatus.undecided:
        undecided();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    _resetPicture = false;

    notifyListeners();
  }

  void startPositionproject(DragStartDetails details) {
    _isDraggingproject = false;

    notifyListeners();
  }

  void updatePositionproject(DragUpdateDetails details) {
    _positionproject += details.delta;

    final x = _positionproject.dx;
    _angleproject = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPositionproject() {
    final status = getStatusproject();

    _isDraggingproject = true;
    notifyListeners();

    switch (status) {
      case ProjectStatus.interest:
        interestproject();
        break;
      case ProjectStatus.uninterested:
        uninterestedproject();
        break;
      case ProjectStatus.undecided:
        undecidedproject();
        break;
      default:
        resetPositionproject();
    }
  }

  void resetPositionproject() {
    _isDraggingproject = false;
    _positionproject = Offset.zero;
    _angleproject = 0;
    _resetPictureproject = false;

    notifyListeners();
  }

  void setProfiles(List<dynamic> profiles) {
    _profiles = profiles.toList();
    notifyListeners();
  }

  void setProjects(List<dynamic> project) {
    _projects = project.toList();
    notifyListeners();
  }

  ProfileStatus? getStatus() {
    final x = _position.dx;
    final y = _position.dy;

    final delta = 100;

    if (x >= delta) {
      return ProfileStatus.interest;
    } else if (x <= -delta) {
      return ProfileStatus.uninterested;
    } else if (y <= -delta) {
      return ProfileStatus.undecided;
    } else if (y >= delta) {
      return ProfileStatus.undecided;
    }

    return null;
  }

  ProjectStatus? getStatusproject() {
    final x = _positionproject.dx;
    final y = _positionproject.dy;

    final delta = 100;

    if (x >= delta) {
      return ProjectStatus.interest;
    } else if (x <= -delta) {
      return ProjectStatus.uninterested;
    } else if (y <= -delta) {
      return ProjectStatus.undecided;
    } else if (y >= delta) {
      return ProjectStatus.undecided;
    }

    return null;
  }

  void interest() {
    _angle = 20;
    _position += Offset(_screenSize.width * 2, 0);

    _saveProfile();

    _nextProfile();

    notifyListeners();
  }

  void uninterested() {
    _angle = -20;

    _position += Offset(-_screenSize.width * 2, 0);
    _nextProfile();

    notifyListeners();
  }

  void undecided() {
    _angle = 0;

    final y = _position.dy;

    if (y <= 0) {
      _position += Offset(0, -_screenSize.height * 2);
    } else {
      _position += Offset(0, _screenSize.height * 2);
    }

    _nextProfile();

    notifyListeners();
  }

  Future _nextProfile() async {
    await Future.delayed(Duration(milliseconds: 500));

    _resetPicture = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 100));

    resetPosition();

    var temp = _profiles[_profiles.length - 1];
    _profiles.removeAt(_profiles.length - 1);
    _profiles.insert(0, temp);
  }

  Future _saveProfile() async {
    var profile = _profiles[_profiles.length - 1];

    UsersAPI api = UsersAPI();

    var user = await api.getUserFromProfileId(profile.id);

    await api.patchUserWithInterestedUser("a3pnnxpcnwgjnab", user.id);
  }

  void interestproject() {
    _angleproject = 20;
    _positionproject += Offset(_screenSize.width * 2, 0);

    _saveProject();

    _nextProject();

    notifyListeners();
  }

  void uninterestedproject() {
    _angleproject = -20;

    _positionproject += Offset(-_screenSize.width * 2, 0);
    _nextProject();

    notifyListeners();
  }

  void undecidedproject() {
    _angleproject = 0;

    final y = _positionproject.dy;

    if (y <= 0) {
      _positionproject += Offset(0, -_screenSize.height * 2);
    } else {
      _positionproject += Offset(0, _screenSize.height * 2);
    }

    _nextProject();

    notifyListeners();
  }

  Future _nextProject() async {
    await Future.delayed(Duration(milliseconds: 500));

    _resetPictureproject = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 100));

    resetPositionproject();

    var temp = _projects[_projects.length - 1];
    _projects.removeAt(_projects.length - 1);
    _projects.insert(0, temp);
  }

  Future _saveProject() async {
    var profile = _profiles[_profiles.length - 1];

    UsersAPI api = UsersAPI();

    var user = await api.getUserFromProfileId(profile.id);

    await api.patchUserWithInterestedProjects("a3pnnxpcnwgjnab", user.id);
  }
}
