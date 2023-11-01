
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';

class BaseGame extends StatelessWidget{
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base Game'), // Page name in the app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outlined), // Info button
            onPressed: () {
             _showPdf(context);
              // Add your info button functionality here
            },
          ),
        ],
      ),
      body: const BaseBoard(), // Your zoomable content
      
    );
  }

  void _showPdf(BuildContext context)
  {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Base Game Rules'),
            ),
            body: InteractiveViewer(
        minScale:0.2,
        maxScale:10.0,
        child: Column(children: (){
          List<Widget> pages = [];
          
          return pages;
        }(),)
        )
          );
        },
      ),
    );
  }
}

class BaseBoard extends StatefulWidget {
  const BaseBoard({super.key});

  @override
  State<BaseBoard> createState() => _BaseBoardState();
}

class _BaseBoardState extends State<BaseBoard> {

    List<String> cards = [
      'wheat','wheat','wheat','wheat',
      'wood','wood','wood','wood',
      'sheep','sheep','sheep','sheep',
      'rock','rock','rock',
      'brick','brick','brick',
      'desert'
      ];


 @override
  Widget build(BuildContext context) {
    // Replace this with your generated board widget.
    // This is just a placeholder; you should implement your board widget here.
    return  Stack(
      children: [InteractiveViewer(
        minScale:0.2,
        maxScale:10.0,
        child:
        Stack(
          alignment: Alignment.center,
          children: generateBoard(context,[3,4,5,4,3])
        )
        ),
    Positioned(
      bottom: 20,
      right: 0,
      left: 0,
      child:  FloatingActionButton(onPressed:shuffleBoard,
      child: const Icon(Icons.refresh_outlined),),
      )
    
    ]);
  }

  void shuffleBoard(){
    setState(() {
    cards.shuffle();
    });
  }

  List<Widget> generateBoard(BuildContext context, List<int> layout){
        List<Widget> boardWidgets = [];

        double board_width = min(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height) - 50;
        double hexagon_card_width = min(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height) / 8;
        double board_height = sqrt(3) / 2 * board_width;

        // actual board
        boardWidgets.add(Positioned(
          top: (MediaQuery.of(context).size.height - board_height) /2,
          child: HexagonWidget.flat(
              width: board_width,
              color: Color.fromARGB(255, 13, 54, 126),
              elevation: 8,
          ),
        ));
        boardWidgets.add(
          Positioned(
                top: 30,
                left: MediaQuery.of(context).size.width /2-80,
                child: const Text('1/1' ,textAlign: TextAlign.left)
                ));

        int cardNumber = 0;
        for(int i = 0; i< layout.length; i++)
        {
          List<HexagonWidget> currentRow = [];

         for(int j = 0; j<layout[i]; j++)
                {
                  currentRow.add(HexagonWidget.pointy(
                width: hexagon_card_width,
                color: Colors.red,
                elevation: 8,
                padding: 1.0,
                child: AspectRatio(
                  aspectRatio: HexagonType.POINTY.ratio,
                  child: Image.asset('lib/resources/cards/${cards[cardNumber]}.png',fit: BoxFit.fitHeight,),
                  )
                ));
                cardNumber +=1;

                }
          boardWidgets.add(
            Positioned(
              top: (MediaQuery.of(context).size.height - board_height) /2 + (sqrt(3)/4 * board_width - 4*sqrt(3)/3 * hexagon_card_width) +  i*sqrt(3)/2* hexagon_card_width,
              left: (MediaQuery.of(context).size.width - (hexagon_card_width * layout.reduce(max)))/2 +(layout.reduce(max)-layout[i])/2*hexagon_card_width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: currentRow,
                ),
            ));
        }
        return boardWidgets;

  }
}

