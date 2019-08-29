const fs = require("fs");

/**
 *
 * @param {function} nextFn The function to be run after this function
 * @param {array} nextParams The parameters to be passed to nextFn
 * @returns undefined
 */
function complete(rl, options, nextFn, nextParams, index) {
    console.log();

    try {
        let todo = JSON.parse(fs.readFileSync(options.path));

        if (!index) {
            console.log("Please input an index to delete");
            console.log("For example, to delete item 3, input 'd3'");
            console.log("Or 'd*' to delete every item");
        } else if (index === "*") {
            console.log(`Deleted ${todo.items.length} items!`);
            todo.items = [];
        } else {
            index = parseInt(index);

            if (index > todo.items.length - 1) {
                console.log("That item does not exist!");
            } else {
                console.log(`Deleted item: "${todo.items[index].item}"`);
                todo.items.pop(index);
            }
        }

        try {
            fs.writeFileSync(options.path, JSON.stringify(todo));
        } catch (err) {
            console.log(
                `An error occurred while trying to write to file '${
                    options.path
                }'`
            );
            nextFn(...nextParams);
        }
        nextFn(...nextParams);
    } catch (err) {
        console.log(
            `An error occurred while trying to read file '${options.path}'`
        );
        nextFn(...nextParams);
    }
}

module.exports = complete;
