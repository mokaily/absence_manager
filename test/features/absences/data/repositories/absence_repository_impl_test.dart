import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/repositories/absence_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/data/datasources/absences_local_file_data_source.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/data/repositories/absence_repository_impl.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/entities/member.dart';

import '../../../../test_constants.dart';
import 'absence_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AbsencesLocalFileDataSource>()])
void main() {
  late MockAbsencesLocalFileDataSource mockDataSource;
  late AbsenceRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAbsencesLocalFileDataSource();
    repository = AbsenceRepositoryImpl(dataSource: mockDataSource);
  });

  // Helpers
  Future<List<Member>> prepareActForGetMembers() async => await repository.getMembers();

  Future<AbsencesRepositoryResult> prepareActForGetAbsences({
    int page = 1,
    int pageSize = 10,
    List<String>? types,
    List<String>? statuses,
    DateTime? startDate,
    DateTime? endDate,
  }) async => await repository.getAbsences(
    page: page,
    pageSize: pageSize,
    types: types,
    statuses: statuses,
    startDate: startDate,
    endDate: endDate,
  );

  void verifyGetMembers() => verify(mockDataSource.getMembers()).called(1);

  void verifyGetAbsences() => verify(mockDataSource.getAbsences()).called(1);

  group('getMembers', () {
    test('Should return list of Members from data source', () async {
      // arrange
      when(mockDataSource.getMembers()).thenAnswer((_) async => TestConstants.tMemberModels);

      // act
      final result = await prepareActForGetMembers();

      // assert
      verifyGetMembers();
      expect(result, isA<List<Member>>());
      expect(result, equals(TestConstants.tMemberModels));
    });

    test('Should throw if data source fails', () async {
      // arrange
      when(mockDataSource.getMembers()).thenThrow(Exception('Failed to load'));

      // act & assert
      expect(() async => await prepareActForGetMembers(), throwsA(isA<Exception>()));
      verifyGetMembers();
    });
  });

  group('getAbsences', () {
    test('Should return paginated Absences from data source', () async {
      // arrange
      when(mockDataSource.getAbsences()).thenAnswer((_) async => TestConstants.tAbsenceModels);

      // act
      final result = await prepareActForGetAbsences(page: 1, pageSize: 2);

      // assert
      verifyGetAbsences();
      expect(result, isA<AbsencesRepositoryResult>());
      expect(result.absences.length, 2);
      expect(result.totalCount, TestConstants.tAbsenceModels.length);
    });

    test('Should filter absences by type and status', () async {
      // arrange
      when(mockDataSource.getAbsences()).thenAnswer((_) async => TestConstants.tAbsenceModels);

      // act
      final result = await prepareActForGetAbsences(types: ['vacation'], statuses: ['requested']);

      // assert
      verifyGetAbsences();
      expect(result.absences.every((a) => a.type.toLowerCase() == 'vacation'), isTrue);
      expect(result.absences.every((a) => a.confirmedAt == null && a.rejectedAt == null), isTrue);
    });

    test('Should return empty list if page exceeds available items', () async {
      // arrange
      when(mockDataSource.getAbsences()).thenAnswer((_) async => TestConstants.tAbsenceModels);

      // act
      final result = await prepareActForGetAbsences(page: 100, pageSize: 10);

      // assert
      verifyGetAbsences();
      expect(result.absences, isEmpty);
    });

    test('Should throw if data source fails', () async {
      // arrange
      when(mockDataSource.getAbsences()).thenThrow(Exception('Failed to load'));

      // act & assert
      expect(() async => await prepareActForGetAbsences(), throwsA(isA<Exception>()));
      verifyGetAbsences();
    });
  });
}
