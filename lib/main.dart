import 'package:flutter/material.dart';
import 'package:tictactoe_app/board_tile.dart';
import 'package:tictactoe_app/tile_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  var _boardState = List.filled(9, TileState.EMPTY);

  var _currentTurn = TileState.CROSS;

  int _totalCrossWins = 0;
  int _totalCircleWins = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _showGameStats(),
            _showTurnInformation(),
            Center(
              child: Stack(children: [
                Image.asset('images/board.png'),
                _boardTiles(),
              ]),
            ),
            _restartGameButton()
          ],
        ),
      ),
    );
  }

  Widget _boardTiles() {
    return Builder(builder: (context) {
      final boardDimension = MediaQuery.of(context).size.width;
      final tileDimension = boardDimension / 3;

      return Container(
        width: boardDimension,
        height: boardDimension,
        child: Column(
          children: chunk(_boardState, 3).asMap().entries.map((entry) {
            final chunkIndex = entry.key;
            final tileStateChunk = entry.value;

            return Row(
              children: tileStateChunk.asMap().entries.map((innerEntry) {
                final innerIndex = innerEntry.key;
                final tileState = innerEntry.value;
                final tileIndex = (chunkIndex * 3) + innerIndex;

                return BoardTile(
                    tileState: tileState,
                    tileDimension: tileDimension,
                    onPressed: () => _updateTileStateForIndex(tileIndex));
              }).toList(),
            );
          }).toList(),
        ),
      );
    });
  }

  void _updateTileStateForIndex(int selectedIndex) {
    if (_boardState[selectedIndex] == TileState.EMPTY) {
      setState(() {
        _boardState[selectedIndex] = _currentTurn;
        _currentTurn = _currentTurn == TileState.CROSS
            ? TileState.CIRCLE
            : TileState.CROSS;
      });

      final winner = _findWinner();
      if (winner != TileState.EMPTY) {
        showWinnerDialog(winner);
      }
    }
  }

  TileState _findWinner() {
    // ignore: prefer_function_declarations_over_variables
    TileState Function(int, int, int) winnerForMatch = (a, b, c) {
      if (_boardState[a] != TileState.EMPTY) {
        if ((_boardState[a] == _boardState[b]) &&
            (_boardState[b] == _boardState[c])) {
          return _boardState[a];
        }
      }

      return TileState.EMPTY;
    };

    final checks = [
      winnerForMatch(0, 1, 2),
      winnerForMatch(3, 4, 5),
      winnerForMatch(6, 7, 8),
      winnerForMatch(0, 3, 6),
      winnerForMatch(1, 4, 7),
      winnerForMatch(2, 5, 8),
      winnerForMatch(0, 4, 8),
      winnerForMatch(2, 4, 6),
    ];

    TileState winner = TileState.EMPTY;
    for (int i = 0; i < checks.length; i++) {
      if (checks[i] != TileState.EMPTY) {
        winner = checks[i];
        break;
      }
    }

    return winner;
  }

  void showWinnerDialog(TileState tileState) {
    final context = navigatorKey.currentState!.overlay!.context;
    if (tileState == TileState.CROSS) {
      _totalCrossWins++;
    } else {
      _totalCircleWins++;
    }
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Winner'),
            content: Image.asset(
                tileState == TileState.CROSS ? 'images/x.png' : 'images/o.png'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    _resetGame();
                    Navigator.of(context).pop();
                  },
                  child: const Text('New Game'))
            ],
          );
        });
  }

  void _resetGame() {
    setState(() {
      _boardState = List.filled(9, TileState.EMPTY);
      _currentTurn = TileState.CROSS;
    });
  }

  Widget _restartGameButton() {
    return ElevatedButton(
      onPressed: () => _resetGame(),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple, foregroundColor: Colors.white),
      child: const Text('Restart Game'),
    );
  }

  Widget _showGameStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(children: [
          Image.asset(height: 40, width: 40, 'images/x.png'),
          Text(': $_totalCrossWins', style: TextStyle(fontSize: 38)),
        ]),
        Row(children: [
          Image.asset(height: 40, width: 40, 'images/o.png'),
          Text(': $_totalCircleWins', style: TextStyle(fontSize: 38)),
        ]),
      ],
    );
  }

  Widget _showTurnInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
            height: 30,
            width: 30,
            _currentTurn == TileState.CROSS ? 'images/x.png' : 'images/o.png'),
        const Text('\'s turn!', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
