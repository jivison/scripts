//$ {"name": "fryImage", "language": "js", "description": "Fries an image (broken)"}

// const qrcode = require("qrcode");
const jimp = require("jimp");

// qrcode.toFile('hello.png', "I like firetrucks and monster trucks\nwalter", (err) => {
//     if(err) {
//         console.error("Error generating QR Code");
//     } else {
//         console.log("Wrote to file 'hello.png'");
//     }
// });

function blur(filepath, blurRadius) {
    jimp.read(filepath)
        .then(image => {
            image
                .contrast(0.7)
                .dither565()
                .posterize(10)
                .posterize(10)
                .posterize(10)
                .posterize(10)
                .pixelate(2)
                .resize(600, 500)
                // .brightness(0.5)
                .contrast(0.5)
                .brightness(0)
                .contrast(1)
                .write(`fried_${filepath}`);
            // image.blur(blurRadius).write(`blurry_${filepath}`);
        })
        .catch(err => {
            console.log("An error occurred while processing the image.");
        });
}

// blur(process.argv[2], parseInt(process.argv[3]))

blur("linus.jpg", 5);
