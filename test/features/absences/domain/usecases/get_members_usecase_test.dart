import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/entities/member.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/repositories/absence_repository.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/usecases/get_members_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_constants.dart';
import 'get_members_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AbsenceRepository>()])
void main() {
  late GetMembersUseCase getMembersUseCase;
  late MockAbsenceRepository mockAbsenceRepository;

  setUp(() {
    mockAbsenceRepository = MockAbsenceRepository();
    getMembersUseCase = GetMembersUseCase(mockAbsenceRepository);
  });

  Future<List<Member>> prepareActForGetMembers() async =>
      await getMembersUseCase.execute();

  void verifyGetMembersUseCase() {
    verify(mockAbsenceRepository.getMembers()).called(1);
    verifyNoMoreInteractions(mockAbsenceRepository);
  }

  group('GetMembersUseCase', () {
    test('Should return list of Members from repository', () async {
      // arrange
      when(mockAbsenceRepository.getMembers())
          .thenAnswer((_) async => TestConstants.tMemberList);

      // act
      final result = await prepareActForGetMembers();

      // assert
      verifyGetMembersUseCase();
      expect(result, TestConstants.tMemberList);
      expect(result.length, TestConstants.tMemberList.length);
    });
  });
}

