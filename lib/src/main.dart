import 'dart:io';

List<String> savedTasks = ['Task 1', 'Task 2'];

void main() {
  displayTasks();
  String? userCommand = getInput(r"Enter command>   ").toLowerCase();

  switch (userCommand) {
    case 'add':
      clearConsole();
      addTask();
      break;
    case 'edit':
      clearConsole();
      editTask();
      break;
    case 'delete':
      clearConsole();
      deleteTask();
      break;
    case 'exit':
      clearConsole();
      exit(0);
    default:
      handleOutput("Error: Invalid command!", main);
      break;
  }
}


void addTask() {
  String addedTaskContent = getInput("Enter Task Content:  \n");
  checkExit(addedTaskContent);

  if (addedTaskContent.isEmpty) {
    handleOutput("Error: Task cannot be empty!", addTask);
  } else {
    savedTasks.add(addedTaskContent);
    handleOutput("Task added successfully!", main);
  }
}

void editTask() {
  String input = getInput("Enter task number to edit:   ");
  if(input.toLowerCase() == 'exit') {
    checkExit(input);
    return;
  }

  int? editedTaskIndex = int.tryParse(input);

  if (editedTaskIndex == null || editedTaskIndex < 1 || editedTaskIndex > savedTasks.length) {
    handleOutput("Error: Invalid task number!", editTask);
    return;
  }

  String editedTaskContent = getInput("Enter new task content:   ");
  checkExit(editedTaskContent);

  while (editedTaskContent.isEmpty) {
    clearConsole();
    print("Error: Task cannot be empty!");
    print("If you want to cancel editing, then type 'exit' now. \n");
    print("Enter task number to edit: $editedTaskIndex");
    editedTaskContent = getInput("Enter new task content:   ");
    checkExit(editedTaskContent);
  }

  savedTasks[editedTaskIndex - 1] = editedTaskContent; // `editedTaskIndex - 1` because dart counts list index from 0 instead of 1, so subtracting 1 is necessary
  handleOutput("Task edited successfully!", main);
}

void deleteTask() {
  String input = getInput("Enter task number to delete:   ");

  if(input.toLowerCase() == 'exit') {
    checkExit(input);
    return;
  }

  int? deletedTaskIndex = int.tryParse(input);

  if(deletedTaskIndex == null || deletedTaskIndex < 1 || deletedTaskIndex > savedTasks.length) {
    handleOutput("Error: Invalid task number!", deleteTask);
  }

  savedTasks.removeAt(deletedTaskIndex! - 1); // `deletedTaskIndex - 1` because dart counts list index from 0 instead of 1, so subtracting 1 is necessary
  handleOutput("Task deleted successfully!", main);
}

//This function actually helps the user when a user accidentally types another command instead of exit or changes his mind. It helps him to exit from other instances, such as `addTask()` or `deleteTask()`. 
void checkExit(String command) {
  if (command.toLowerCase() == "exit") {
    handleOutput("Exiting...", main); //It exits to `main()` function.
  }
}

//Just a simple ANSI code function. It will clear the console.
void clearConsole() => print('\x1B[2J\x1B[0;0H'); //An ANSI code which clears the console a.k.a terminal.

String getInput(String prompt) {
  stdout.write(prompt);
  String? input = stdin.readLineSync();
  return input ?? "Error: Invalid input! Perhaps you left it empty or typed something incorrect."; //It just returns the second value if it is null.
}

//This function is just to maintain DRY. I had to write this code block multiple times, so I have created a function.
void handleOutput(String output, Function forwardedFunction) {
  clearConsole();
  print(output);
  forwardedFunction();
}

void displayTasks() {
  for (String task in savedTasks) {
    int taskNumber = savedTasks.indexOf(task) + 1;
    print("$taskNumber. $task");
  }
}
