import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  DatabaseReference _wellWaterReference = FirebaseDatabase.instance.ref("well");
  DatabaseReference _waterBoardReference =
      FirebaseDatabase.instance.ref("waterBoard");

  Future<void> loginSplashUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> updateWaterState(int wellWater, int waterBoard) async {
    if (wellWater == 1 && waterBoard == 0) {
      await _wellWaterReference.set(
        wellWater,
      );
      await _waterBoardReference.set(
        waterBoard,
      );
    } else {
      if (wellWater == 0 && waterBoard == 1) {
        await _waterBoardReference.set(
          waterBoard,
        );
        await _wellWaterReference.set(
          wellWater,
        );
      } else if (waterBoard == 0 && wellWater == 0) {
        await _wellWaterReference.set(
          wellWater,
        );
        await _waterBoardReference.set(
          waterBoard,
        );
      }
    }
  }
}
