import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class OmokRepo {
  final _wares = BehaviorSubject.seeded(<Coord, Ware>{});
  Stream<Map<Coord, Ware>> get onWareChanged => _wares.stream;

  Ware _nextWare = Ware.black;
  Ware get nextWare => _nextWare;

  int _count = 0;
  int get count => _count;

  Ware? _winner;
  Ware? get winner => _winner;

  Future<void> putWare(Coord coord, Ware ware) async {
    final wares = await _wares.first;
    if (wares.containsKey(coord)) return;
    wares[coord] = ware;
    final copy = {...wares}..[coord] = ware;
    _nextWare = ware.toggle();
    _count++;
    if (_match(copy, coord)) {
      _winner = ware;
    }
    _wares.add(copy);
  }

  Future<void> removeWare(Coord coord) async {
    final wares = await _wares.first;
    if (!wares.containsKey(coord)) return;
    final copy = {...wares}..remove(coord);
    _wares.add(copy);
  }

  void reset() {
    _nextWare = Ware.black;
    _winner = null;
    _count = 0;
    _wares.add({});
  }

  Coord _top(Map<Coord, Ware> map, Coord coord, Coord d) {
    final ware = map[coord]!;
    Coord cur = coord;
    while (true) {
      final next = cur + d;
      final p = map[next];
      if (p == ware) {
        cur = next;
        continue;
      }
      return cur;
    }
  }

  bool _match(Map<Coord, Ware> map, Coord coord, [int n = 5]) {
    const ds = [Coord(1, 0), Coord(0, 1), Coord(1, 1), Coord(1, -1)];
    for (final d in ds) {
      if (_match2(map, coord, d, n)) return true;
    }
    return false;
  }

  bool _match2(Map<Coord, Ware> map, Coord coord, Coord d, int n) {
    final ware = map[coord]!;
    Coord cur = _top(map, coord, -d);
    for (int i = 0; i < n; i++) {
      final next = cur + d * i;
      if (ware != map[next]) return false;
    }
    return true;
  }
}

enum Ware {
  white,
  black,
  ;

  bool get isWhite => this == white;
  bool get isBlack => this == black;

  Ware toggle() => this == white ? black : white;
}

class Coord extends Equatable {
  final int x;
  final int y;
  const Coord(this.x, this.y);

  static const zero = Coord(0, 0);

  @override
  List<Object?> get props => [x, y];

  Offset toOffset() => Offset(x.toDouble(), y.toDouble());

  Coord operator -() {
    return Coord(-x, -y);
  }

  Coord operator +(Coord other) {
    return Coord(x + other.x, y + other.y);
  }

  Coord operator *(int scalar) {
    return Coord(x * scalar, y * scalar);
  }
}
