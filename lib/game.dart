import 'dart:math';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int enemyHealth = 0;
  int startingNumber = 0;
  int currentLevel = 1; // Track the current level
  String userInput = "";
  String message = ""; // Message for errors or success
  Map<String, int> blockedButtons = {}; // Tracks blocked buttons and their remaining turns
  List<String> pressedButtons = []; // Track buttons pressed by the user

  @override
  void initState() {
    super.initState();
    generateEnemy();
  }

  void generateEnemy() {
    setState(() {
      Random random = Random();
      if (currentLevel % 5 == 0) {
        // Boss level
        enemyHealth = random.nextInt(30) + 20; // Boss health between 20 and 50
        showTemporaryMessage("Boss Level! Defeat the Boss!");
      } else {
        // Regular level
        enemyHealth = random.nextInt(20) + 5; // Enemy health between 5 and 25
        showTemporaryMessage("Defeat the enemy!");
      }
      startingNumber = random.nextInt(10) + 1; // Starting number between 1 and 10
      userInput = "$startingNumber";
      decrementBlockDurations(); // Decrease block durations at the start of each turn
    });
  }

  void buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        userInput = "$startingNumber";
        pressedButtons.clear(); // Clear pressed buttons on reset
      } else if (value == "DEL") {
        if (userInput.length > startingNumber.toString().length) {
          // Allow deletion only if userInput is longer than the starting number
          String lastChar = userInput[userInput.length - 1];
          userInput = userInput.substring(0, userInput.length - 1);
          pressedButtons.remove(lastChar); // Remove the last pressed button from memory
        }
      } else if (value == "=") {
        checkAnswer();
      } else if (value == "()") {
        int openCount = userInput.split('(').length - 1;
        int closeCount = userInput.split(')').length - 1;
        if (openCount > closeCount && userInput.isNotEmpty && RegExp(r'[0-9)]$').hasMatch(userInput)) {
          userInput += ")";
        } else {
          userInput += "(";
        }
      } else if (value == "%") {
        userInput += "%*"; // Display %* in the userInput
      } else {
        if (userInput.length < 9) { // Limit input to 6 characters
          userInput += value;
        }
      }

      // Track pressed buttons, excluding special cases like "=" and "DEL"
      if (value != "=" && value != "DEL" && value != "C" && userInput.length <= 9) {
        pressedButtons.add(value);
      }
    });
  }

  void showTemporaryMessage(String tempMessage) {
    setState(() {
      message = tempMessage;
    });
    Future.delayed(const Duration(seconds: 2), () { // Reduced delay to 1 second
      setState(() {
        message = ""; // Clear the message after 1 second
      });
    });
  }

  void checkAnswer() {
    try {
      String formattedInput = userInput
          .replaceAll("x", "*")
          .replaceAll("÷", "/")
          .replaceAll("%*", "/100*"); // Handle percentage as /100*
      Parser parser = Parser();
      Expression exp = parser.parse(formattedInput);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      if (result == enemyHealth) {
        setState(() {
          if (currentLevel == 15) {
            // Show results screen after completing all levels
            showResultsScreen();
          } else {
            currentLevel++; // Increment level
            showTemporaryMessage("You defeated the enemy!");
          }
          applyBlockingLogic(); // Block buttons after successful evaluation
          generateEnemy(); // Generate a new enemy after defeating the current one
        });
      } else {
        showTemporaryMessage("Wrong answer! Try again.");
      }
    } catch (e) {
      showTemporaryMessage("Invalid input!");
    }
  }

  void showResultsScreen() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text("You have completed all 15 levels!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                setState(() {
                  currentLevel = 1; // Reset the level
                  generateEnemy(); // Start a new game
                });
              },
              child: const Text("Play Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Exit to the main menu
              },
              child: const Text("Exit"),
            ),
          ],
        );
      },
    );
  }

  void applyBlockingLogic() {
    // Block unique buttons that were pressed during the current turn
    Set<String> uniquePressedButtons = pressedButtons.toSet(); // Ensure uniqueness
    for (String button in uniquePressedButtons) {
      blockedButtons[button] = getBlockDuration(button);
    }
    pressedButtons.clear(); // Clear pressed buttons after blocking
  }

  void decrementBlockDurations() {
    // Create a temporary map to store updated block durations
    Map<String, int> updatedBlockedButtons = {};
    blockedButtons.forEach((key, value) {
      if (value > 1) {
        updatedBlockedButtons[key] = value - 1;
      }
    });
    // Update the blockedButtons map with the new durations
    blockedButtons = updatedBlockedButtons;
  }

  int getBlockDuration(String button) {
    // Define block durations based on button type
    if (["+", "-", "*", "÷", "%", "x"].contains(button)) { // Ensure "x" is included
      return 2; // Operators block for 2 turns
    } else if (RegExp(r'^\d$').hasMatch(button)) {
      return 2; // Numbers block for 2 turns
    } else {
      return 1; // Default block duration
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        title: const Text("Game Mode"),
      ),
      body: Column(
        children: [
          // Enemy health and image section
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15), // Adjusted padding to fix layout issue
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Enemy image
                  Image.asset(
                    'assets/images/dusman.png', // Path to the enemy image
                    fit: BoxFit.contain,
                    height: 159,
                    width: 159,
                  ),
                  // Enemy health and starting number
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Enemy Health: $enemyHealth",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Starting Number: $startingNumber",
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          message.isNotEmpty ? message : userInput, // Show message or user input
                          style: TextStyle(
                            fontSize: message.contains("Boss Level") ? 14 : (message.isNotEmpty ? 16 : 36), // Adjust font size
                            color: message.isNotEmpty ? Colors.red : Colors.blue, // Red for message, blue for input
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Level progress bar
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              children: [
                const Text(
                  "Level Progress", // Add label above the progress bar
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
                const SizedBox(height: 5),
                Stack(
                  children: [
                    // Background of the progress bar
                    Container(
                      width: double.infinity,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[800], // Background color of the progress bar
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    // Current progress bar
                    Align(
                      alignment: Alignment.centerLeft, // Ensure the progress bar starts from the left
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8 * (currentLevel / 25).clamp(0.0, 1.0), // Ensure full bar at level 25
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.green, // Current progress color
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    // Text showing current level progress
                    Center(
                      child: Text(
                        "$currentLevel / 25", // Display current level and max level
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white),
          // Keyboard section
          Expanded(
            flex: 8,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: gameButtons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.18,
              ),
              itemBuilder: (context, index) {
                String button = gameButtons[index];
                bool isBlocked = blockedButtons.containsKey(button);
                return ElevatedButton(
                  onPressed: isBlocked ? null : () => buttonPressed(button),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBlocked
                        ? const Color.fromARGB(255, 100, 100, 100) // Gray for blocked buttons
                        : const Color.fromARGB(255, 49, 48, 48), // Default button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1), // Button shape
                    ),
                  ),
                  child: Text(
                    button,
                    style: TextStyle(
                      fontSize: 24,
                      color: isBlocked
                          ? const Color.fromARGB(255, 150, 150, 150) // Light gray for blocked text
                          : button == "="
                              ? Colors.white // White text for "=" button
                              : button == "C"
                                  ? Colors.red // Red text for "C" button
                                  : Colors.white, // Default text color
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const List<String> gameButtons = [
  "C", "DEL", "%", "÷",
  "7", "8", "9", "x",
  "4", "5", "6", "-",
  "1", "2", "3", "+",
  "()", "0", ".", "="
];