import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_model.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final user = await ref.watch(authStateProvider.future);
  if (user == null) return null;
  final doc = await ref.watch(firestoreProvider).collection('users').doc(user.uid).get();
  if (!doc.exists) return null;
  return AppUser.fromMap(user.uid, doc.data()!);
});

final userProvider = FutureProvider.family<AppUser?, String>((ref, userId) async {
  final doc = await ref.watch(firestoreProvider).collection('users').doc(userId).get();
  if (!doc.exists) return null;
  return AppUser.fromMap(userId, doc.data()!);
});

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final FirebaseAuth _auth;

  AuthNotifier(this._auth) : super(const AsyncValue.data(null));

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _auth.signInAnonymously(); // swap for Google SSO once Firebase is wired
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(ref.watch(firebaseAuthProvider));
});
