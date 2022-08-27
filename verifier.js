"use strict";
const { exec } = require('child_process');
const glob = require("glob");

let contracts = ["0x75554f728d5909C61E20dE4f07e0e97249034b94"];

let network = "mumbai" //for testing

contracts.forEach(file => {
    var command = "npx hardhat verify " + file + " --network "+ network;
    // console.log(command);
    exec(command, (err, stdout, stderr) => {
        if (err) {
            throw err;
        } else if (stderr) {
            throw stderr;
        }
    });

});