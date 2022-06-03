import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_omok/src/omok/bloc/omok_bloc.dart';
import 'package:flutter_omok/src/omok/view/omok_painter.dart';
import 'package:flutter_omok/src/repo/omok_repo.dart';

class OmokPage extends StatelessWidget {
  const OmokPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OmokBloc(context.read<OmokRepo>())..add(const InitEvent()),
      child: const OmokView(),
    );
  }
}

class OmokView extends StatelessWidget {
  const OmokView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OmokBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Using Bloc for Omok'),
        actions: [
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: () {
              context.read<OmokBloc>().add(const ResetEvent());
            },
          ),
        ],
      ),
      body: BlocListener<OmokBloc, OmokState>(
        listener: (context, state) async {
          if (state is! OmokResult) return;
          final res = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(state.winner.isWhite ? 'White won' : 'Black won'),
                actions: [
                  ElevatedButton(
                    child: const Text('Reset'),
                    onPressed: () {
                      Navigator.pop(context, 'reset');
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.pop(context, 'close');
                    },
                  ),
                ],
              );
            },
          );
          if (res == 'reset') {
            bloc.add(const ResetEvent());
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: const [
              GameStatus(),
              SizedBox(height: 12),
              Expanded(child: GameBoard()),
            ],
          ),
        ),
      ),
    );
  }
}

class GameStatus extends StatelessWidget {
  const GameStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OmokBloc, OmokState>(
      buildWhen: (previous, current) => current is OmokRender,
      builder: (context, state) {
        if (state is OmokRender) {
          return Row(
            children: [
              const Text('Next Ware:'),
              const SizedBox(width: 8),
              Container(
                width: 30,
                height: 30,
                decoration: ShapeDecoration(
                  color: state.nextWare == Ware.white
                      ? Colors.white
                      : Colors.black,
                  shape: const CircleBorder(
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              const Text('Count: '),
              const SizedBox(width: 8),
              Text('${state.count}'),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OmokBloc>();
    return BlocBuilder<OmokBloc, OmokState>(
      buildWhen: (previous, current) => current is OmokRender,
      builder: (context, state) {
        if (state is OmokRender) {
          return Container(
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return MouseRegion(
                    onHover: (event) {
                      bloc.add(HandleHoverMouseEvent(event, constraints));
                    },
                    child: GestureDetector(
                      onTapDown: (details) {
                        bloc.add(HandleDownMouseEvent(
                          details,
                          constraints,
                        ));
                      },
                      child: CustomPaint(
                        painter: OmokPainter(state),
                        size: constraints.biggest,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
