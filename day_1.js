const fs = require("node:fs");

let input = `1abc2
pqr3stu8vwx
a2b2c3d4e0f
treb7uchet`;
input = fs.readFileSync("input_1_1.txt", "ascii");

/* extract the first and last digit of each line */
let s = input.replaceAll(/^[^\d]*(\d).*(\d)[^\d]*$|^[^\d]*((\d))[^\d]*$/gm, '$1$2$3$4');

/* convert the double digit number into a series of single digit numbers which
 * sum up to the original number. */
s = s
    .replaceAll(/9(\d)/gm, "89:01:0$1")
    .replaceAll(/8(\d)/gm, "79:01:0$1")
    .replaceAll(/7(\d)/gm, "69:01:0$1")
    .replaceAll(/6(\d)/gm, "59:01:0$1")
    .replaceAll(/5(\d)/gm, "49:01:0$1")
    .replaceAll(/4(\d)/gm, "39:01:0$1")
    .replaceAll(/3(\d)/gm, "29:01:0$1")
    .replaceAll(/2(\d)/gm, "19:01:0$1")
    .replaceAll(/1(\d)/gm, "09:01:0$1");

s = s.replaceAll(/[0:]/gm, "");

/* expand the number into a series of 1's. So '5' would become '11111'. */
s = s
    .replaceAll(/9:?/gm, "54")
    .replaceAll(/8:?/gm, "44")
    .replaceAll(/7:?/gm, "43")
    .replaceAll(/6:?/gm, "33")
    .replaceAll(/5:?/gm, "32")
    .replaceAll(/4:?/gm, "22")
    .replaceAll(/3:?/gm, "21")
    .replaceAll(/2:?/gm, "11");

/* put all the 1's onto one big line. */
s = s.replaceAll(/\n|\r\n/g, "");
s = s.replaceAll(/1/gm, "s1");

/* group the powers of 10 */
s = s.replaceAll(/(s1){10}:?/gm, "d1")
s = s.replaceAll(/(d1){10}:?/gm, "h1")
s = s.replaceAll(/(h1){10}:?/gm, "t1")
s = s.replaceAll(/(t1){10}:?/gm, "g1")

/* split the different powers of 10 into mulitple lines */
s = s.replaceAll(/^((?:g1)*)((?:t1)*)((?:h1)*)((?:d1)*)((?:s1)*)$/gm, "$1\n$2\n$3\n$4\n$5\n");
s = s.replaceAll(/\n\n/gm, "\n0\n");

/* sum up every line */
s = s.replaceAll(/[gthds]/g, "");
s = s
    .replaceAll(/111111111/gm, "9")
    .replaceAll(/11111111/gm, "8")
    .replaceAll(/1111111/gm, "7")
    .replaceAll(/111111/gm, "6")
    .replaceAll(/11111/gm, "5")
    .replaceAll(/1111/gm, "4")
    .replaceAll(/111/gm, "3")
    .replaceAll(/11/gm, "2")

/* put onto one line */
s = s.replaceAll(/\n/g, "");

console.log("the result is:", s);
