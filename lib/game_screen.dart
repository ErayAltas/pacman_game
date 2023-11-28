// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman_game/widgets/pacman.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = numberInRow * 14 + 1;
  int ghost = numberInRow * 2 - 2;
  int ghost2 = numberInRow * 9 - 1;
  int ghost3 = numberInRow * 11 - 2;
  bool mouthClosed = false;
  Timer? pacmanTimer;
  Timer? ghostTimer;
  int score = 0;
  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    166,
    167,
    168,
    169,
    170,
    171,
    172,
    173,
    174,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    78,
    79,
    80,
    100,
    101,
    102,
    84,
    85,
    86,
    106,
    107,
    108,
    24,
    35,
    46,
    57,
    30,
    41,
    52,
    63,
    81,
    70,
    59,
    61,
    72,
    83,
    26,
    28,
    37,
    38,
    39,
    123,
    134,
    145,
    129,
    140,
    151,
    103,
    114,
    125,
    105,
    116,
    127,
    147,
    148,
    149
  ];
  List<int> food = [];
  String direction = "right";
  String ghostLast = "left";
  String ghostLast2 = "left";
  String ghostLast3 = "down";

  @override
  void initState() {
    super.initState();
    addFoods();
  }

  void startGame() {
    player = numberInRow * 14 + 1;
    ghost = numberInRow * 2 - 2;
    ghost2 = numberInRow * 9 - 1;
    ghost3 = numberInRow * 11 - 2;
    mouthClosed = false;
    score = 0;
    direction = "right";
    food.clear();
    addFoods();
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (player == ghost || player == ghost2 || player == ghost3) {
        setState(() {
          player = -1;
        });
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Center(child: Text("Game Over!")),
                content: Text("Your Score : $score"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      timer.cancel();
                      ghostTimer?.cancel();
                      pacmanTimer?.cancel();
                      Navigator.pop(context);
                      startGame();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Restart'),
                  )
                ],
              );
            });
      }
    });
    ghostTimer?.cancel();
    pacmanTimer?.cancel();
    ghostTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      moveGhost();
      moveGhost2();
      moveGhost3();
    });
    pacmanTimer = Timer.periodic(const Duration(milliseconds: 280), (timer) {
      pacmanMove();
    });
  }

  void pacmanMove() {
    setState(() {
      mouthClosed = !mouthClosed;
    });
    if (food.contains(player)) {
      setState(() {
        score++;
        food.remove(player);
      });
    }
    switch (direction) {
      case "left":
        if (!barriers.contains(player - 1)) {
          setState(() {
            player--;
          });
        }
        break;
      case "right":
        if (!barriers.contains(player + 1)) {
          setState(() {
            player++;
          });
        }
        break;
      case "up":
        if (!barriers.contains(player - numberInRow)) {
          setState(() {
            player -= numberInRow;
          });
        }
        break;
      case "down":
        if (!barriers.contains(player + numberInRow)) {
          setState(() {
            player += numberInRow;
          });
        }
        break;
    }
  }

  void addFoods() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveGhost() {
    switch (ghostLast) {
      case "left":
        if (!barriers.contains(ghost - 1)) {
          setState(() {
            ghost--;
          });
        } else {
          if (!barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          } else if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost + 1)) {
          setState(() {
            ghost++;
          });
        } else {
          if (!barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          } else if (!barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          } else if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost - numberInRow)) {
          setState(() {
            ghost -= numberInRow;
            ghostLast = "up";
          });
        } else {
          if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          } else if (!barriers.contains(ghost + numberInRow)) {
            setState(() {
              ghost += numberInRow;
              ghostLast = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost + numberInRow)) {
          setState(() {
            ghost += numberInRow;
            ghostLast = "down";
          });
        } else {
          if (!barriers.contains(ghost - 1)) {
            setState(() {
              ghost--;
              ghostLast = "left";
            });
          } else if (!barriers.contains(ghost + 1)) {
            setState(() {
              ghost++;
              ghostLast = "right";
            });
          } else if (!barriers.contains(ghost - numberInRow)) {
            setState(() {
              ghost -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost2() {
    switch (ghostLast2) {
      case "left":
        if (!barriers.contains(ghost2 - 1)) {
          setState(() {
            ghost2--;
          });
        } else {
          if (!barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost2 + 1)) {
          setState(() {
            ghost2++;
          });
        } else {
          if (!barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          } else if (!barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost2 - numberInRow)) {
          setState(() {
            ghost2 -= numberInRow;
            ghostLast2 = "up";
          });
        } else {
          if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost2 + numberInRow)) {
          setState(() {
            ghost2 += numberInRow;
            ghostLast2 = "down";
          });
        } else {
          if (!barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost3() {
    switch (ghostLast) {
      case "left":
        if (!barriers.contains(ghost3 - 1)) {
          setState(() {
            ghost3--;
          });
        } else {
          if (!barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          } else if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
      case "right":
        if (!barriers.contains(ghost3 + 1)) {
          setState(() {
            ghost3++;
          });
        } else {
          if (!barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          } else if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "up":
        if (!barriers.contains(ghost3 - numberInRow)) {
          setState(() {
            ghost3 -= numberInRow;
            ghostLast3 = "up";
          });
        } else {
          if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "down":
        if (!barriers.contains(ghost3 + numberInRow)) {
          setState(() {
            ghost3 += numberInRow;
            ghostLast3 = "down";
          });
        } else {
          if (!barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) {
                      direction = "down";
                    } else if (details.delta.dy < 0) {
                      direction = "up";
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0) {
                      direction = "right";
                    } else if (details.delta.dx < 0) {
                      direction = "left";
                    }
                  },
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: numberInRow),
                    itemBuilder: (BuildContext context, int index) {
                      if (mouthClosed && player == index) {
                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(decoration: BoxDecoration(color: Colors.yellow.shade600, shape: BoxShape.circle)),
                        );
                      } else if (player == index) {
                        switch (direction) {
                          case "left":
                            return Transform.rotate(angle: pi, child: const Pacman());
                          case "right":
                            return const Pacman();
                          case "up":
                            return Transform.rotate(angle: 3 * pi / 2, child: const Pacman());
                          case "down":
                            return Transform.rotate(angle: pi / 2, child: const Pacman());
                          default:
                            return const Pacman();
                        }
                      } else if (ghost == index) {
                        return const Ghost(ghostType: 1);
                      } else if (ghost2 == index) {
                        return const Ghost(ghostType: 2);
                      } else if (ghost3 == index) {
                        return const Ghost(ghostType: 3);
                      } else if (barriers.contains(index)) {
                        return MyPixel(innerColor: Colors.blue[900], outerColor: Colors.blue[800]);
                      } else if (food.contains(index)) {
                        return const MyPath(innerColor: Colors.yellow, outerColor: Colors.black);
                      } else {
                        return const MyPath(innerColor: Colors.black, outerColor: Colors.black);
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Score: $score", style: const TextStyle(color: Colors.white, fontSize: 25)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => startGame(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Start", style: TextStyle(color: Colors.white, fontSize: 25)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
