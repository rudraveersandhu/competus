import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class MyDronaAuthUser {
  MyDronaAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<MyDronaAuthUser> myDronaAuthUserSubject =
    BehaviorSubject.seeded(MyDronaAuthUser(loggedIn: false));
Stream<MyDronaAuthUser> myDronaAuthUserStream() => myDronaAuthUserSubject
    .asBroadcastStream()
    .map((user) => currentUser = user);
