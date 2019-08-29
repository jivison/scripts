const fs = require("fs");

/**
 *
 * @param {function} nextFn The function to be run after this function
 * @param {array} nextParams The parameters to be passed to nextFn
 * @returns undefined
 */
function complete(rl, options, nextFn, nextParams, index) {
    try {
        console.log();
        let todo = JSON.parse(fs.readFileSync(options.path));

        if (!index) {
            console.log("Please input an index to complete");
            console.log("For example, to complete item 3, input 'c3'");
            console.log("Or 'c*' to complete every item");
        } else if (index === "*") {
            for (let item_i = 0; item_i < todo.items.length; item_i++) {
                const item = todo.items[item_i];

                todo.items[item_i].completed = true;

                console.log(`Completed item '${item.item}'`);
            }
        } else {
            index = parseInt(index);

            if (index > todo.items.length - 1) {
                console.log("That item does not exist!");
            } else if (todo.items[index].completed) {
                console.log(
                    `The item "${
                        todo.items[index].item
                    }" has already been completed!`
                );
            } else {
                todo.items[index].completed = true;
                console.log(`Completed item: "${todo.items[index].item}"`);
            }
        }

        fs.writeFileSync(options.path, JSON.stringify(todo), () => {
            console.log("An error occured while writing to todo file!");
        });
        nextFn(...nextParams);
    } catch (err) {
        console.log(
            `An error occurred while trying to read file '${options.path}'`
        );
        nextFn(...nextParams);
    }
}

module.exports = complete;
