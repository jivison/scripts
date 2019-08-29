const fs = require("fs");

/**
 *
 * @param {function} nextFn The function to be run after this function
 * @param {array} nextParams The parameters to be passed to nextFn
 * @returns undefined
 */

function view(rl, options, nextFn, nextParams) {
    console.log();
    try {
        let todo = JSON.parse(fs.readFileSync(options.path));

        if (todo.items.length === 0) {
            console.log("No items to show!");
        } else {
            console.log(
                todo.items
                    .reduce((acc, val, idx) => {
                        return (acc += `${idx}${" ".repeat(
                            todo.items.length.toString().length -
                                idx.toString().length
                        )} ${val.completed ? "[✓]" : "[ ]"} ${val.item}\n`);
                    }, "")
                    .trim()
            );
        }
    } catch (err) {
        console.log(
            `An error occurred while trying to view file '${options.path}'`
        );
    }

    nextFn(...nextParams);
}

module.exports = view;
