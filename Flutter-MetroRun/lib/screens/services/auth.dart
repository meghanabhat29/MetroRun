import 'package:firebase_auth/firebase_auth.dart';
import 'package:metrorun/screens/models/user.dart';
import 'package:metrorun/screens/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var name;
  var username;
  var phoneNumber;

  AuthService({this.name, this.username, this.phoneNumber});

  //create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

//sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign in w email pass
  Future signInEmailPass(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//register w email pass
  Future regEmailPass(
      {String email,
      String confirmPassword,
      String name,
      String username,
      String phoneNum}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: confirmPassword);
      FirebaseUser user = result.user;
      print("createUserWithEmailAndPassword user is $user");

      await DatabaseService(uid: user.uid).updateUserData(
          name, username, phoneNum, email, confirmPassword, 1000, 0);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      print("error creating user");
      return null;
    }
  }

//sign out
  Future SignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
