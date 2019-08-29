const readline = require("readline");

module.exports = function(options, commands, rlInterface, startup = false) {
    if (startup) {
        console.log(`\nWelcome to Todo CLI!\n--------------------`);
    }
    menu(options, commands, rlInterface)
};

function menu(options, commands, rlInterface) {
    let help = [];
    for (let key in commands) {
        help.push(`(${key}) ${commands[key].command}`);
    }
    console.log();
    console.log(help.join(" • "));

    rlInterface.question("> ", answer => {
        let params = [rlInterface, options, menu, [options, commands, rlInterface]];

        if (
            ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].includes(
                answer.charAt(1)
            ) ||
            answer.charAt(1) === "*"
        ) {
            params.push(answer.charAt(1));
            answer = answer.charAt(0);
        }

        if (Object.keys(commands).includes(answer)) {
            commands[answer].commandFunction(...params);
        } else {
            console.log(`Command '${answer}' not found.`);
            menu(options, commands, rlInterface);
        }
    });
}
