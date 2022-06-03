part of 'omok_bloc.dart';

abstract class OmokEvent extends Equatable {
  const OmokEvent();

  @override
  List<Object> get props => [];
}

class InitEvent extends OmokEvent {
  const InitEvent();
}

class ResetEvent extends OmokEvent {
  const ResetEvent();
}

class PutWareEvent extends OmokEvent {
  final Coord coord;
  final Ware ware;

  const PutWareEvent(this.coord, this.ware);

  @override
  List<Object> get props => [coord, ware];
}

class PutHoverEvent extends OmokEvent {
  final Coord coord;

  const PutHoverEvent(this.coord);

  @override
  List<Object> get props => [coord];
}

class HandleDownMouseEvent extends OmokEvent {
  final TapDownDetails details;
  final BoxConstraints constraints;

  const HandleDownMouseEvent(this.details, this.constraints);

  @override
  List<Object> get props => [details, constraints];
}

class HandleHoverMouseEvent extends OmokEvent {
  final PointerHoverEvent details;
  final BoxConstraints constraints;

  const HandleHoverMouseEvent(this.details, this.constraints);

  @override
  List<Object> get props => [details, constraints];
}
