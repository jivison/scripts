const pathModule = require("path");
const fs = require("fs");

function readDirectory(path) {
    if (path === "/") {
        console.log("Couldn't find a .todo directory");
        process.exit();
    } else {
        fs.readdir(path, (err, items) => {
            if (err) {
                throw err;
            }

            if (items.includes(".todo")) {
                fs.writeFileSync("/home/john/.todorcPath", `${path}/.todo/options.todo.json`)
            } else {
                let splitPath = pathModule.dirname(path).split(pathModule.sep);

                readDirectory(splitPath.join(pathModule.sep));
            }
        });
    }
}
readDirectory(process.cwd());
