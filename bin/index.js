#! /usr/bin/env node

var spawn=require("child_process").spawn;
spawn("sh", [__dirname + "/gitish.sh"], {stdio: "inherit"});
