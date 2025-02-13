import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meet_me/config/core/failure.dart';
import 'package:meet_me/config/helper/network_state.dart';
import 'package:meet_me/src/auth/data/datasource/auth_datasource.dart';
import 'package:meet_me/src/auth/domain/model/user_model.dart';

class SignInFirebaseDatasourceImplement extends AuthFirebaseDatasource {
  final FirebaseAuth _auth;
  final NetworkState _network;
  final FailureManage _failureManage;

  SignInFirebaseDatasourceImplement(
      this._auth, this._network, this._failureManage);

  @override
  Future<UserModel> signIn(
      {required String userName, required String password}) async {
    throwIfError(_network.status == ConnectivityResult.none,
        _failureManage.connectivity);
    try {
      await _auth.signInWithEmailAndPassword(
        email: userName,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _failureManage.server(e.message.toString());
    }
    User? user = _auth.currentUser;
    throwIfError(user == null, _failureManage.server("User not found"));
    UserModel userEntiti = UserModel(
        email: user!.email ?? "",
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
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      throw _failureManage.server(e.toString());
    }
  }

  @override
  Future<UserModel> signUp(
      {required String userName, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: userName,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _failureManage.server(e.message.toString());
    }
    return await signIn(password: password, userName: userName);
  }
}
