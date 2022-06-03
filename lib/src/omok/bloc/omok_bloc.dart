import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_omok/src/repo/omok_repo.dart';

part 'omok_event.dart';
part 'omok_state.dart';

class OmokBloc extends Bloc<OmokEvent, OmokState> {
  final OmokRepo _repo;
  OmokBloc(this._repo) : super(OmokInitial()) {
    on<InitEvent>((event, emit) async {
      await emit.forEach(_repo.onWareChanged, onData: (Map<Coord, Ware> wares) {
        final state = this.state;
        if (state is OmokRender) {
          return state.copyWith(
            wares: wares,
            nextWare: _repo.nextWare,
            count: _repo.count,
          );
        } else {
          return OmokRender(
            wares: wares,
            nextWare: _repo.nextWare,
            count: _repo.count,
          );
        }
      });
    });

    on<HandleDownMouseEvent>((event, emit) async {
      final state = this.state;
      if (state is OmokRender) {
        final coord = _convert(
          state,
          event.details.localPosition,
          event.constraints.biggest,
        );
        final ware = _repo.nextWare;
        add(PutWareEvent(coord, ware));
      }
    });

    on<HandleHoverMouseEvent>((event, emit) {
      final state = this.state;
      if (state is OmokRender) {
        final coord = _convert(
          state,
          event.details.localPosition,
          event.constraints.biggest,
        );
        add(PutHoverEvent(coord));
      }
    });

    on<PutWareEvent>((event, emit) async {
      if (_repo.winner != null) {
        add(const ResetEvent());
        return;
      }
      final state = this.state;
      if (state is OmokRender) {
        await _repo.putWare(event.coord, event.ware);
        final winner = _repo.winner;
        if (winner != null) {
          emit(OmokResult(winner: winner));
        }
      }
    });

    on<PutHoverEvent>((event, emit) {
      final state = this.state;
      if (state is OmokRender) {
        emit(state.copyWith(hover: event.coord));
      }
    });

    on<ResetEvent>((event, emit) {
      _repo.reset();
    });
  }

  Coord _convert(OmokRender state, Offset localPosition, Size size) {
    final l = (size.aspectRatio < 1 ? size.width : size.height) /
        (state.gridCount + 1);
    final x = localPosition.dx ~/ l;
    final y = localPosition.dy ~/ l;
    return Coord(x, y);
  }
}
