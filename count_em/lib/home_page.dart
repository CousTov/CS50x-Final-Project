import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

List<PlayingCard> deck = standardFiftyTwoCardDeck();
int i = 0;
int runningCount = 0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    PlayingCard card = deck[i];
    return Scaffold(
      backgroundColor: Colors.teal,
      body: GestureDetector(
        onTap: () {
          setState(
            () {
              if (i < 51) {
                i++;
                runningCount += calculateRunningCount(deck[i - 1]);
              } else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => const AlertDialog(
                    title: Text('Ran out of cards'),
                    content: Text("Tap outside to reset"),
                  ),
                );
                i = 0;
                setState(() {
                  shuffle(deck);
                  card = deck[i];
                });
              }
            },
          );
        },
        onLongPress: () {
          setState(
            () {
              showCount(context);
            },
          );
        },
        child: Center(
          child: PlayingCardView(
            card: card,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            shuffle(deck);
            card = deck[i];
          });
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.shuffle),
      ),
    );
  }

  Future<String?> showCount(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Count'),
        content: Text("Running Count: ${runningCount.toString()}"),
      ),
    );
  }
}

void shuffle(List<PlayingCard> deck) {
  deck.shuffle();
  runningCount = 0;
  i = 0;
}

int calculateRunningCount(PlayingCard card) {
  CardValue cardValue = card.value;
  String cardName = cardValue.name;
  switch (cardName) {
    case 'ace' || 'king' || 'queen' || 'jack' || 'ten':
      return -1;
    case 'two' || 'three' || 'four' || 'five' || 'six':
      return 1;
    default:
      return 0;
  }
}
