part of 'omok_bloc.dart';

abstract class OmokState extends Equatable {
  const OmokState();

  @override
  List<Object?> get props => [];
}

class OmokInitial extends OmokState {}

class OmokRender extends OmokState {
  final Map<Coord, Ware> wares;
  final int gridCount;
  final Coord? hover;
  final Ware nextWare;
  final int count;

  const OmokRender({
    this.wares = const {},
    this.gridCount = 15,
    this.hover,
    required this.nextWare,
    this.count = 0,
  });

  OmokRender copyWith({
    Map<Coord, Ware>? wares,
    int? gridCount,
    Coord? hover,
    Ware? nextWare,
    int? count,
  }) {
    return OmokRender(
      wares: wares ?? this.wares,
      gridCount: gridCount ?? this.gridCount,
      hover: hover ?? this.hover,
      nextWare: nextWare ?? this.nextWare,
      count: count ?? this.count,
    );
  }

  @override
  List<Object?> get props => [
        wares,
        gridCount,
        hover,
        nextWare,
        count,
      ];
}

class OmokResult extends OmokState {
  final Ware winner;

  const OmokResult({required this.winner});

  @override
  List<Object?> get props => [winner];
}
