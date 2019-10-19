import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cars/app/pages/login/user.dart';
import 'package:flutter_cars/data/services/api_response.dart';
import 'package:google_sign_in/google_sign_in.dart';


class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ApiResponse> signUp(final String name, final String email, final String password) async {
    try {
      // Log-in on Firebase
      final AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final FirebaseUser fuser = result.user;
      print("Firebase Name: ${fuser.displayName}");
      print("Firebase Email: ${fuser.email}");
      print("Firebase Photo: ${fuser.photoUrl}");

      final userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      userUpdateInfo.photoUrl = "";
      fuser.updateProfile(userUpdateInfo);

      // generic response
      return ApiResponse.success(result);
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error("Unable to sign up");
    }
  }

  Future<ApiResponse> login(final String email, final String password) async {
    try {
      // Log-in on Firebase
      final AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser fuser = result.user;
      print("Firebase Name: ${fuser.displayName}");
      print("Firebase Email: ${fuser.email}");
      print("Firebase Photo: ${fuser.photoUrl}");

      // generic response
      return ApiResponse.success(result);
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error("Unable to login");
    }
  }

  Future<ApiResponse> loginGoogle() async {
    try {
      // Login com o Google
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      print("Google User: ${googleUser.email}");

      // Credentials for firebase
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Log-in on Firebase
      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser fuser = result.user;
      print("Firebase Name: ${fuser.displayName}");
      print("Firebase Email: ${fuser.email}");
      print("Firebase Photo: ${fuser.photoUrl}");

      // Create user to app
      final user = User(
        name: fuser.displayName,
        username: fuser.email,
        email: fuser.email,
        photoUrl: fuser.photoUrl,
      );
      user.save();

      // generic response
      return ApiResponse.success(result);
    } catch (error) {
      print("Firebase error $error");
      return ApiResponse.error("Unable to login");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}