import 'dart:io';

void getCalculator(String calculatorType) {
  stdout.write("Enter the first number: ");
  num? firstNumber = num.tryParse(stdin.readLineSync()!);
  stdout.write("Enter the second number: ");
  num? secondNumber = num.tryParse(stdin.readLineSync()!);

  if(firstNumber == null || secondNumber == null) {
    print("Invalid input");
    return;
  }

  if(calculatorType == "addition") {
    num sum = firstNumber + secondNumber;
    print("The sum of $firstNumber and $secondNumber is $sum");
  } else if(calculatorType == "subtraction") {
    num subtraction = firstNumber - secondNumber;
    print("The subtraction of $firstNumber and $secondNumber is $subtraction");
  } else if(calculatorType == "multiplication") {
    num multiplication = firstNumber * secondNumber;
    print("The multiplication of $firstNumber and $secondNumber is $multiplication");
  } else if (calculatorType == "division") {
    
    if(secondNumber == 0){
      print("Error: Division by zero is not allowed!");
      return;
    } else {
      num division = firstNumber / secondNumber;
      print("The division of $firstNumber and $secondNumber is $division");
    }
    
  } else {
    print("Error: Invalid calculator type! Fix bug!");
  }
}

void calculator() {
  print("Dart Calculator");

  print(" 1. Addition (+)\n 2. Subtraction (-)\n 3. Multiplication (*)\n 4. Division (/)");
  stdout.write("Enter the calculation method you want to use: ");
  int? userInput = int.tryParse(stdin.readLineSync()!);
  switch (userInput) {
    case 1:
      print("Addition calculator");
      getCalculator("addition");
      break;
    case 2:
      print("Subtraction Calculator");
      getCalculator("subtraction");
      break;
    case 3:
      print("Multiplication Calculator");
      getCalculator("multiplication");
      break;
    case 4:
      print("Division Calculator");
      getCalculator("division");
      break;
    default:
      print("Invalid choice");
      calculator();
  }
}

void main() => calculator();