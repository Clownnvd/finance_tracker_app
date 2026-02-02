import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/feature/settings/data/datasources/settings_remote_data_source.dart';
import 'package:finance_tracker_app/feature/settings/data/repositories/settings_repository_impl.dart';
import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';

class MockSettingsRemoteDataSource extends Mock
    implements SettingsRemoteDataSource {}

class MockUserIdLocalDataSource extends Mock implements UserIdLocalDataSource {}

void main() {
  late MockSettingsRemoteDataSource mockRemote;
  late MockUserIdLocalDataSource mockUserIdLocal;
  late SettingsRepositoryImpl repo;

  const testUserId = 'user-123';

  const testSettings = AppSettings(
    reminderOn: true,
    budgetAlertOn: false,
    tipsOn: true,
  );

  Map<String, dynamic> settingsJson({
    bool reminderOn = false,
    bool budgetAlertOn = false,
    bool tipsOn = false,
  }) {
    return {
      'user_id': testUserId,
      'reminder_on': reminderOn,
      'budget_alert_on': budgetAlertOn,
      'tips_on': tipsOn,
    };
  }

  setUp(() {
    mockRemote = MockSettingsRemoteDataSource();
    mockUserIdLocal = MockUserIdLocalDataSource();
    repo = SettingsRepositoryImpl(
      remote: mockRemote,
      userIdLocal: mockUserIdLocal,
    );
  });

  group('SettingsRepositoryImpl', () {
    group('getMine', () {
      test('returns AppSettings when user has saved settings', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.getMine(uid: any(named: 'uid')))
            .thenAnswer((_) async => [
                  settingsJson(reminderOn: true, budgetAlertOn: false, tipsOn: true),
                ]);

        final result = await repo.getMine();

        expect(result, isNotNull);
        expect(result!.reminderOn, true);
        expect(result.budgetAlertOn, false);
        expect(result.tipsOn, true);
        verify(() => mockRemote.getMine(uid: testUserId)).called(1);
      });

      test('returns null when user has no saved settings', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.getMine(uid: any(named: 'uid')))
            .thenAnswer((_) async => []);

        final result = await repo.getMine();

        expect(result, isNull);
      });

      test('throws when userId is missing', () async {
        when(() => mockUserIdLocal.getUserId()).thenAnswer((_) async => null);

        expect(
          () => repo.getMine(),
          throwsA(isA<Exception>()),
        );
      });

      test('throws when userId is empty', () async {
        when(() => mockUserIdLocal.getUserId()).thenAnswer((_) async => '   ');

        expect(
          () => repo.getMine(),
          throwsA(isA<Exception>()),
        );
      });

      test('throws mapped exception on remote error', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.getMine(uid: any(named: 'uid')))
            .thenThrow(Exception('Network error'));

        expect(
          () => repo.getMine(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('upsert', () {
      test('returns updated AppSettings on success', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.upsert(any())).thenAnswer((_) async => [
              settingsJson(reminderOn: true, budgetAlertOn: false, tipsOn: true),
            ]);

        final result = await repo.upsert(testSettings);

        expect(result.reminderOn, true);
        expect(result.budgetAlertOn, false);
        expect(result.tipsOn, true);
      });

      test('passes correct JSON to remote', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.upsert(any())).thenAnswer((_) async => [
              settingsJson(reminderOn: true, budgetAlertOn: false, tipsOn: true),
            ]);

        await repo.upsert(testSettings);

        verify(() => mockRemote.upsert({
              'user_id': testUserId,
              'reminder_on': true,
              'budget_alert_on': false,
              'tips_on': true,
            })).called(1);
      });

      test('throws when userId is missing', () async {
        when(() => mockUserIdLocal.getUserId()).thenAnswer((_) async => null);

        expect(
          () => repo.upsert(testSettings),
          throwsA(isA<Exception>()),
        );
      });

      test('throws mapped exception on remote error', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.upsert(any())).thenThrow(Exception('Save failed'));

        expect(
          () => repo.upsert(testSettings),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('patch', () {
      test('returns updated AppSettings when patching reminderOn', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.patch(
              uid: any(named: 'uid'),
              body: any(named: 'body'),
            )).thenAnswer((_) async => [
              settingsJson(reminderOn: true, budgetAlertOn: false, tipsOn: false),
            ]);

        final result = await repo.patch(reminderOn: true);

        expect(result.reminderOn, true);
        verify(() => mockRemote.patch(
              uid: testUserId,
              body: {'reminder_on': true},
            )).called(1);
      });

      test('returns updated AppSettings when patching budgetAlertOn', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.patch(
              uid: any(named: 'uid'),
              body: any(named: 'body'),
            )).thenAnswer((_) async => [
              settingsJson(reminderOn: false, budgetAlertOn: true, tipsOn: false),
            ]);

        final result = await repo.patch(budgetAlertOn: true);

        expect(result.budgetAlertOn, true);
        verify(() => mockRemote.patch(
              uid: testUserId,
              body: {'budget_alert_on': true},
            )).called(1);
      });

      test('returns updated AppSettings when patching tipsOn', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.patch(
              uid: any(named: 'uid'),
              body: any(named: 'body'),
            )).thenAnswer((_) async => [
              settingsJson(reminderOn: false, budgetAlertOn: false, tipsOn: true),
            ]);

        final result = await repo.patch(tipsOn: true);

        expect(result.tipsOn, true);
        verify(() => mockRemote.patch(
              uid: testUserId,
              body: {'tips_on': true},
            )).called(1);
      });

      test('patches multiple fields at once', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.patch(
              uid: any(named: 'uid'),
              body: any(named: 'body'),
            )).thenAnswer((_) async => [
              settingsJson(reminderOn: true, budgetAlertOn: true, tipsOn: true),
            ]);

        final result = await repo.patch(
          reminderOn: true,
          budgetAlertOn: true,
          tipsOn: true,
        );

        expect(result.reminderOn, true);
        expect(result.budgetAlertOn, true);
        expect(result.tipsOn, true);
        verify(() => mockRemote.patch(
              uid: testUserId,
              body: {
                'reminder_on': true,
                'budget_alert_on': true,
                'tips_on': true,
              },
            )).called(1);
      });

      test('sends empty body when no fields specified', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.patch(
              uid: any(named: 'uid'),
              body: any(named: 'body'),
            )).thenAnswer((_) async => [
              settingsJson(),
            ]);

        await repo.patch();

        verify(() => mockRemote.patch(
              uid: testUserId,
              body: <String, dynamic>{},
            )).called(1);
      });

      test('throws when userId is missing', () async {
        when(() => mockUserIdLocal.getUserId()).thenAnswer((_) async => null);

        expect(
          () => repo.patch(reminderOn: true),
          throwsA(isA<Exception>()),
        );
      });

      test('throws mapped exception on remote error', () async {
        when(() => mockUserIdLocal.getUserId())
            .thenAnswer((_) async => testUserId);
        when(() => mockRemote.patch(
              uid: any(named: 'uid'),
              body: any(named: 'body'),
            )).thenThrow(Exception('Patch failed'));

        expect(
          () => repo.patch(reminderOn: true),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
