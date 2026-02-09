import 'package:flutter_test/flutter_test.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/data/datasources/absences_local_file_data_source.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/data/models/absence_model.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/data/models/member_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AbsencesLocalFileDataSource', () {
    late AbsencesLocalFileDataSource dataSource;

    setUp(() {
      dataSource = AbsencesLocalFileDataSourceImpl();
    });

    group('getAbsences', () {
      test('Should return list of AbsenceModel from JSON file', () async {
        final result = await dataSource.getAbsences();

        expect(result, isA<List<AbsenceModel>>());
        expect(result.length, greaterThan(0));
        expect(result.first, isA<AbsenceModel>());
      });

      test('Should parse all absence fields correctly', () async {
        final result = await dataSource.getAbsences();

        final firstAbsence = result.first;
        expect(firstAbsence.id, isNotNull);
        expect(firstAbsence.userId, isNotNull);
        expect(firstAbsence.startDate, isNotNull);
        expect(firstAbsence.endDate, isNotNull);
      });
    });

    group('getMembers', () {
      test('Should return list of MemberModel from JSON file', () async {
        final result = await dataSource.getMembers();

        expect(result, isA<List<MemberModel>>());
        expect(result.length, greaterThan(0));
        expect(result.first, isA<MemberModel>());
      });

      test('Should parse all member fields correctly', () async {
        final result = await dataSource.getMembers();

        final firstMember = result.first;
        expect(firstMember.id, isNotNull);
        expect(firstMember.userId, isNotNull);
        expect(firstMember.name, isNotEmpty);
      });
    });
  });
}
