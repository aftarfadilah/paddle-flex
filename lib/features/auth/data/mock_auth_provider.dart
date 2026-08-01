import 'package:flutter_riverpod/flutter_riverpod.dart';

// Fake user for local development / web preview without Firebase
class MockUser {
  final String uid;
  final String displayName;
  final String email;

  MockUser({required this.uid, required this.displayName, required this.email});
}

class MockAuthNotifier extends StateNotifier<AsyncValue<MockUser?>> {
  MockAuthNotifier() : super(const AsyncValue.loading()) {
    // Auto-sign in after a short delay (simulates Firebase init)
    Future.delayed(const Duration(milliseconds: 1200), () {
      state = AsyncValue.data(MockUser(
        uid: 'mock-001',
        displayName: 'Aftar F.',
        email: 'aftar@example.com',
      ));
    });
  }

  Future<void> signInWithGoogle() async {
    // For preview: instant mock sign-in
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 600));
    state = AsyncValue.data(MockUser(
      uid: 'mock-001',
      displayName: 'Aftar F.',
      email: 'aftar@example.com',
    ));
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 300));
    state = const AsyncValue.data(null);
  }
}

final mockAuthProvider = StateNotifierProvider<MockAuthNotifier, AsyncValue<MockUser?>>((ref) {
  return MockAuthNotifier();
});

// Re-export a compatible interface so we can swap Firebase → Mock easily
typedef AppAuthUser = MockUser;
final appAuthProvider = mockAuthProvider;
