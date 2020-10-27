import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  Future<FirebaseUser> signUp(
      {String email,
      String password,
      String name,
      String profilePicture,
      String gender,
      String phoneNumber,
      String token,
      DateTime birthDate}) async {
    FirebaseUser loggedUser;
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = name;
    updateInfo.photoUrl = profilePicture;

    await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((user) async {
      await user.user.updateProfile(updateInfo);
      await user.user.reload();
      FirebaseUser updatedUser = await _auth.currentUser();
      loggedUser = updatedUser;
      print(
          'Full Name: ${loggedUser.displayName}\n email: ${loggedUser.email}\n photoUrl: ${loggedUser.photoUrl}');
    });

    await _firestore.collection('Users').document(email).setData({
      'fullName': loggedUser.displayName,
      'email': loggedUser.email,
      'photoUrl': loggedUser.photoUrl,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
    });

    await _firestore
        .collection('Admin')
        .document('Store')
        .collection('Users')
        .document(email)
        .setData({
      'fullName': loggedUser.displayName,
      'email': loggedUser.email,
      'password': password,
      'photoUrl': loggedUser.photoUrl,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'createdDate': DateTime.now(),
      'token': token,
    });

    return loggedUser;
  }

  Future<AuthResult> signIn(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return authResult;
  }

  Future forgetPassword(String email) async {
    _auth.sendPasswordResetEmail(email: email);
  }

  updateUserProfile(
      {String name,
      String profilePicture,
      String phoneNumber,
      String token,
      DateTime birthDate}) async {
    final currentUser = await _auth.currentUser();

    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = name;
    updateInfo.photoUrl = profilePicture;

    await currentUser.updateProfile(updateInfo);
    await currentUser.reload();

    await Firestore.instance
        .collection('Users')
        .document(currentUser.email)
        .updateData({
      'fullName': name,
      'photoUrl': profilePicture,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
    });

    await Firestore.instance
        .collection('Admin')
        .document('Store')
        .collection('Users')
        .document(currentUser.email)
        .updateData({
      'fullName': name,
      'photoUrl': profilePicture,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'token': token,
    });
  }
}
