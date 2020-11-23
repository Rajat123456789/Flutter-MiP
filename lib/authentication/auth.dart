// class Auth {
//   signUp(String email, String password) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   signIn(String email, String password) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }

//   signOut() async {
//     try {
//       return await FirebaseAuth.instance.signOut();
//     } on FirebaseAuthException catch (e) {
//       print(e.toString());
//       return null;
//     }
//   }
// }
