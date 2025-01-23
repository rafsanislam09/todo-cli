import 'dart:io';

File savedTasksFile = File('savedTasks.txt');
List<String> savedTasks = [];

void main() {
  loadTasks();
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
      deleteTask();
      break;
    case 'exit':
      clearConsole();
      exit(0);
    default:
      forwardTo("Error: Invalid command!", main);
      break;
  }
}

void addTask() {
  String addedTaskContent = getInput("Enter Task Content:  \n");
  checkExit(addedTaskContent);

  if (addedTaskContent.isEmpty) {
    forwardTo("Error: Task cannot be empty!", addTask);
    return;
  } 
  
  try{
    //Writing to file
    if(savedTasksFile.lengthSync() == 0) {
      savedTasksFile.writeAsStringSync('$addedTaskContent', mode: FileMode.append);
    } else {
      savedTasksFile.writeAsStringSync('\n$addedTaskContent', mode: FileMode.append);
    }

    savedTasks.add(addedTaskContent); //Saving in the memory (RAM)
    forwardTo("Task added successfully", main);
    return;
  } catch(exception) {
    forwardTo("Error while saving added task to disk: $exception", main);
    return;
  }
}

void editTask() {
  String taskToEdit = getInput("Enter task number to edit:   ");
  if (taskToEdit.toLowerCase() == 'exit') {
    checkExit(taskToEdit);
    return;
  }

  int? editedTaskIndex = int.tryParse(taskToEdit);

  if (editedTaskIndex == null || editedTaskIndex < 1 || editedTaskIndex > savedTasks.length) {
    forwardTo("Error: Invalid task number!", editTask);
    return;
  }

  String editedTaskContent = getInput("Enter new task content:   ");
  checkExit(editedTaskContent);

  while (editedTaskContent.isEmpty) {
    clearConsole();
    print("Error: Task cannot be empty!");
    print("If you want to cancel editing, then type 'exit' now. \n");
    editedTaskContent = getInput("Enter new task content:   ");
    checkExit(editedTaskContent);
  }

  // `editedTaskIndex - 1` because dart counts list index from 0 instead of 1, so subtracting 1 is necessary
  savedTasks[editedTaskIndex - 1] = editedTaskContent;

  //Writing to file
  try{
    savedTasksFile.writeAsStringSync(savedTasks.join('\n'));
    forwardTo("Task edited successfully", main);
    return;
  } catch(exception) {
    forwardTo("Error while saving edit to disk: $exception", main);
    return;
  }
}

void deleteTask() {
  String tasksToDelete = getInput("Enter task number to delete:   ");
  checkExit(tasksToDelete);

  int? deletedTaskIndex = int.tryParse(tasksToDelete);

  if (deletedTaskIndex == null || deletedTaskIndex < 1 || deletedTaskIndex > savedTasks.length) {
    forwardTo("Error: Invalid task number!", deleteTask);
    return;
  }

  // `deletedTaskIndex - 1` because dart counts list index from 0 instead of 1, so subtracting 1 is necessary
  savedTasks.removeAt(deletedTaskIndex - 1);
  
  try {
    savedTasksFile.writeAsStringSync(savedTasks.join('\n'));
    forwardTo("Task deleted successfully!", main);
    return;
  } catch(exception) {
    forwardTo("Error while deleting task: $exception", main);
    return;
  }
}

//This function actually helps the user when a user accidentally types another command instead of exit or changes his mind. It helps him to exit from other instances, such as `addTask()` or `deleteTask()`.
void checkExit(String command) {
  if (command.toLowerCase() == "exit") {
    main(); //It exits to `main()` function.
    return;
  }
}

//Just a simple ANSI code function. It will clear the console.
void clearConsole() => print(
    '\x1B[2J\x1B[0;0H'); //An ANSI code which clears the console a.k.a terminal.

String getInput(String prompt) {
  stdout.write(prompt);
  String? input = stdin.readLineSync();
  return input ??
      "Error: Invalid input! Perhaps you left it empty or typed something incorrect."; //It just returns the second value if it is null.
}

//This function is just to maintain DRY. I had to write this code block multiple times, so I have created a function.
//This function prints a message(string), then execute or forward to the `forwardedFunction`.
void forwardTo(String output, Function forwardedFunction) {
  clearConsole();
  print(output);
  forwardedFunction();
}

void loadTasks() {
  try{
    if(savedTasksFile.existsSync()) {
      savedTasks = savedTasksFile.readAsLinesSync();
    } else {
      savedTasksFile.createSync();
      savedTasks = [];
    }
  } catch(exception) {
    forwardTo("Error: $exception", exit(1));
  }
}

//This function displays the saved tasks in the screen. Creating a new function for this case was not necessary, but I did it to make the code clean.
void displayTasks() {
  for (String task in savedTasks) {
    int taskNumber = savedTasks.indexOf(task) + 1;
    print("$taskNumber. $task");
  }
}
