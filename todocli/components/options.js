const fs = require("fs");

/**
 *
 * @param {function} nextFn The function to be run after this function
 * @param {array} nextParams The parameters to be passed to nextFn
 * @returns undefined
 */

function options(rl, options, nextFn, nextParams) {
    try {
        let todoOptions = JSON.parse(fs.readFileSync(options.optionsPath));
        console.log("The current options are:");
        console.log(todoOptions);
        rl.question(
            "\nWhich option would you like to change?\nEnter the key to change, or enter nothing to change nothing.\n> ",
            optionKey => {
                if (Object.keys(todoOptions).includes(optionKey)) {
                    rl.question(
                        "\nWhat would you like to change it to?\n> ",
                        optionValue => {
                            todoOptions[optionKey] = optionValue;

                            try {
                                fs.writeFileSync(
                                    options.optionsPath,
                                    JSON.stringify(todoOptions)
                                );
                                console.log(
                                    `Changed '${optionKey}' to '${optionValue}'!`
                                );
                            } catch (err) {
                                console.log(
                                    `An error occurred while trying to write to file '${
                                        options.optionsPath
                                    }'`
                                );
                            }

                            nextParams[0] = todoOptions;
                            nextFn(...nextParams);
                        }
                    );
                } else if (optionKey === "") {
                    nextParams[0] = todoOptions;
                    nextFn(...nextParams);
                } else {
                    console.log("That option does not exist!");
                    nextParams[0] = todoOptions;
                    nextFn(...nextParams);
                }
            }
        );
    } catch (err) {
        console.log(
            `An error occurred while trying to read file '${
                options.optionsPath
            }'`
        );
        nextFn(...nextParams)
    }
}

module.exports = options;
