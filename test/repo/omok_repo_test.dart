// ignore_for_file: prefer_const_constructors

import 'package:flutter_omok/src/repo/omok_repo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OmokRepo', () {
    test('constructor', () {
      final repo = OmokRepo();
      expect(repo.count, 0);
      expect(repo.nextWare, Ware.black);
      expect(repo.winner, isNull);
      expect(repo.onWareChanged, emitsInOrder([{}]));
    });

    group('feature test', () {
      late OmokRepo repo;
      setUp(() {
        repo = OmokRepo();
      });

      test('should emit stream', () async {
        expect(
            repo.onWareChanged,
            emitsInOrder([
              {}..[Coord.zero] = Ware.black,
              {}
                ..[Coord.zero] = Ware.black
                ..[Coord(1, 0)] = Ware.black,
            ]));
        await repo.putWare(Coord.zero, Ware.black);
        await repo.putWare(Coord(1, 0), Ware.black);
      });

      test('should raise count after each putWare()', () async {
        await repo.putWare(Coord.zero, Ware.black);
        expect(repo.count, 1);
        await repo.putWare(Coord(0, 1), Ware.black);
        expect(repo.count, 2);
      });

      test('ignore putWare() if already exists at the coord', () async {
        await repo.putWare(Coord.zero, Ware.black);
        await repo.putWare(Coord.zero, Ware.black);
        expect(repo.count, 1);
      });

      test('should match x-line', () async {
        await repo.putWare(Coord(1, 0), Ware.black);
        await repo.putWare(Coord(2, 0), Ware.black);
        await repo.putWare(Coord(3, 0), Ware.black);
        await repo.putWare(Coord(4, 0), Ware.black);
        await repo.putWare(Coord(5, 0), Ware.black);
        expect(repo.winner, Ware.black);
      });

      test('should not match x-line with space', () async {
        await repo.putWare(Coord(0, 0), Ware.black);
        await repo.putWare(Coord(1, 0), Ware.black);
        await repo.putWare(Coord(3, 0), Ware.black);
        await repo.putWare(Coord(4, 0), Ware.black);
        await repo.putWare(Coord(5, 0), Ware.black);
        expect(repo.winner, isNull);
      });

      test('should match y-line', () async {
        await repo.putWare(Coord(0, 1), Ware.black);
        await repo.putWare(Coord(0, 2), Ware.black);
        await repo.putWare(Coord(0, 3), Ware.black);
        await repo.putWare(Coord(0, 4), Ware.black);
        await repo.putWare(Coord(0, 5), Ware.black);
        expect(repo.winner, Ware.black);
      });

      test('should not match y-line with space', () async {
        await repo.putWare(Coord(0, 0), Ware.black);
        await repo.putWare(Coord(0, 1), Ware.black);
        await repo.putWare(Coord(0, 3), Ware.black);
        await repo.putWare(Coord(0, 4), Ware.black);
        await repo.putWare(Coord(0, 5), Ware.black);
        expect(repo.winner, isNull);
      });

      test('reset after count is raised', () async {
        await repo.putWare(Coord(0, 0), Ware.black);
        repo.reset();
        expect(repo.count, 0);
      });

      test('reset after omok is done', () async {
        await repo.putWare(Coord(0, 0), Ware.black);
        await repo.putWare(Coord(0, 1), Ware.black);
        await repo.putWare(Coord(0, 3), Ware.black);
        await repo.putWare(Coord(0, 4), Ware.black);
        await repo.putWare(Coord(0, 5), Ware.black);
        repo.reset();
        expect(repo.winner, isNull);
      });
    });
  });
}
