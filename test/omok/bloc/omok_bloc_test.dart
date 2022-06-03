// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_omok/src/omok/bloc/omok_bloc.dart';
import 'package:flutter_omok/src/repo/omok_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOmokRepo extends Mock implements OmokRepo {}

class FakeCoord extends Fake implements Coord {}

void main() {
  group('OmokBloc', () {
    late OmokRepo repo;
    late OmokBloc bloc;

    setUp(() {
      registerFallbackValue(FakeCoord());
      repo = MockOmokRepo();
      bloc = OmokBloc(repo);
    });

    blocTest<OmokBloc, OmokState>(
      'emits [OmokRender] when InitEvent is added.',
      build: () => bloc,
      setUp: () {
        when(() => repo.onWareChanged).thenAnswer((_) => Stream.value({}));
        when(() => repo.nextWare).thenReturn(Ware.white);
        when(() => repo.count).thenReturn(1);
      },
      act: (bloc) => bloc.add(InitEvent()),
      expect: () => [
        OmokRender(nextWare: Ware.white, count: 1),
      ],
    );

    blocTest<OmokBloc, OmokState>(
      'emits [MyState] when PutWareEvent is added and done is true.',
      build: () => bloc,
      setUp: () {
        when(() => repo.winner).thenReturn(Ware.black);
      },
      act: (bloc) => bloc.add(PutWareEvent(Coord.zero, Ware.black)),
      verify: (_) {
        verify(() => repo.reset()).called(1);
      },
    );

    blocTest<OmokBloc, OmokState>(
      'emits [OmokResult] when PutWareEvent is added for winner.',
      build: () => bloc,
      setUp: () {
        when(() => repo.putWare(any(), Ware.black)).thenAnswer((_) async => {});
        final list = [null, Ware.black];
        when(() => repo.winner).thenAnswer((invocation) {
          final value = list.first;
          list.removeAt(0);
          return value;
        });
      },
      seed: () => OmokRender(nextWare: Ware.black),
      act: (bloc) => bloc.add(PutWareEvent(Coord.zero, Ware.black)),
      expect: () => const [
        OmokResult(winner: Ware.black),
      ],
      verify: (_) {
        verify(() => repo.putWare(any(), Ware.black)).called(1);
        verify(() => repo.winner).called(2);
      },
    );
  });
}
