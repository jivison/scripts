const fs = require("fs");
const readline = require("readline");

/**
 *
 * @param {function} nextFn The function to be run after this function
 * @param {array} nextParams The parameters to be passed to nextFn
 * @returns undefined
 */
function newItem(rl, options, nextFn, nextParams) {
    console.log();

    try {
        let todo = JSON.parse(fs.readFileSync(options.path));
        rl.question("What task do you want to add?\n> ", answer => {
            try {
                todo.items.push({ item: answer, completed: false });
                fs.writeFileSync(options.path, JSON.stringify(todo));
                nextFn(...nextParams);
            } catch (err) {
                console.log(
                    `An error occurred while trying to write to file '${
                        options.path
                    }'`
                );
                nextFn(...nextParams);
            }
        });
    } catch (err) {
        console.log(
            `An error occurred while trying to read file '${options.path}'`
        );
        nextFn(...nextParams);
    }
}

module.exports = newItem;
