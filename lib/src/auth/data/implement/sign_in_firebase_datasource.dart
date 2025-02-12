import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/config/helper/network_state.dart';
import 'package:meet_me/src/auth/data/datasource/sign_in_datasource.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';


class SignInFirebaseDatasourceImplement extends SingInFirebaseDatasource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSingIn;
  final NetworkState _network;
  final FailureManage _failureManage;

  SignInFirebaseDatasourceImplement(
      this._auth, this._googleSingIn, this._network, this._failureManage);

  @override
  Future<UserModel> signIn() async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSingIn.signIn();
    if (googleSignInAccount == null) {
      throw _failureManage.client("Retry again");
    }
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    // Getting users credential
    UserCredential result = await _auth.signInWithCredential(authCredential);
    if (result.user == null) {
      throw _failureManage.emptyField;
    }
    User user = result.user!;
    UserModel userEntiti = UserModel(
        email: user.email ?? "",
        id: user.uid,
        name: user.displayName ?? "N/A",
        profilePic: user.photoURL,
        isOnline: true);
    return userEntiti;
  }

  @override
  Future<bool> signOut() async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    bool result = await _googleSingIn.isSignedIn();
    if (result) {
      await _auth.signOut();
      await _googleSingIn.signOut();
    }
    return result;
  }
}
