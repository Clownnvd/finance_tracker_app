import 'package:finance_tracker_app/core/network/session_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/feature/users/auth/data/models/auth_remote_data_source.dart';
import 'package:finance_tracker_app/feature/users/auth/data/repositories/auth_repository_impl.dart';

class MockRemote extends Mock implements AuthRemoteDataSource {}
class MockSession extends Mock implements SessionLocalDataSource {}

void main() {
  group('AuthRepositoryImpl', () {
    test('login saves token then fetches me', () async {
      final remote = MockRemote();
      final session = MockSession();

      when(() => remote.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => 'token123');

      when(() => session.saveAccessToken(any())).thenAnswer((_) async {});
      when(() => remote.getMe()).thenAnswer((_) async => {
            'id': '1',
            'email': 'a@b.com',
            'user_metadata': {'full_name': 'A'},
          });

      final repo = AuthRepositoryImpl(remote: remote, sessionLocal: session);

      final user = await repo.login(email: 'a@b.com', password: '12345678');

      expect(user.id, '1');
      expect(user.email, 'a@b.com');

      verify(() => session.saveAccessToken('token123')).called(1);
      verify(() => remote.getMe()).called(1);
    });
  });
}
