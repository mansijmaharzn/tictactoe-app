import 'package:flutter/material.dart';
import 'package:tictactoe_app/tile_state.dart';

class BoardTile extends StatelessWidget {
  final TileState tileState;
  final double tileDimension;
  final VoidCallback onPressed;

  const BoardTile(
      {super.key,
      required this.tileState,
      required this.tileDimension,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tileDimension,
      height: tileDimension,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: _widgetForTileState(),
      ),
    );
  }

  Widget _widgetForTileState() {
    Widget widget;

    switch (tileState) {
      case TileState.EMPTY:
        {
          widget = Container();
        }
        break;

      case TileState.CROSS:
        {
          widget = Image.asset('images/x.png');
        }
        break;

      case TileState.CIRCLE:
        {
          widget = Image.asset('images/o.png');
        }
        break;
    }

    return widget;
  }
}
