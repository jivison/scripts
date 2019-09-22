//$ {"name": "todo", "language": "js", "description": "A command line todo client"}
// Project criteria:
// http://codecore.certified.in/learning_modules/todo-cli-week-3-8/submissions

const menu = require("./components/menu");
const view = require("./components/view");
const newItem = require("./components/newItem");
const complete = require("./components/complete");
const deleteItem = require("./components/deleteItem");
const options = require("./components/options");

const pathModule = require("path");
const readline = require("readline");
const fs = require("fs");

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

/*
Format: 
    "items" : [
        {
            "item" : <title>,
            "completed" : <true/false>
        }
    ]
*/

let optionsPath;

try {
    optionsPath = fs.readFileSync("/home/john/.todorcPath").toString();
} catch (err) {
    console.log("Couldn't find the options file.");
    process.exit();
}

const quit = () => {
    console.log("Goodbye!");
    process.exit();
};

let todoOptions = JSON.parse(fs.readFileSync(optionsPath));

const commands = {
    // 'shortcut' : {command : 'command', commandFunction : fn}
    v: { command: "View", commandFunction: view },
    n: { command: "New", commandFunction: newItem },
    c: { command: "Complete", commandFunction: complete },
    d: { command: "Delete", commandFunction: deleteItem },
    q: { command: "Quit", commandFunction: quit },
    o: { command: "Options", commandFunction: options }
};

menu(todoOptions, commands, rl, true);
