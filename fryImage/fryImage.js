const jimp = require("jimp");

function blur(filepath, filename) {
    jimp.read(filepath + filename)
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
                .contrast(0.5)
                .brightness(0)
                .contrast(1)
                .write(`${filepath}fried_${filename}`);
        })
        .catch(err => {
            console.log("An error occurred while processing the image:");
            console.log(err);
        });
}

blur(process.argv[2], process.argv[3]);