const readline = require \readline
const Console = require "../lib/console"
process.stdin.set-encoding \utf8

const rl = readline.create-interface {
    input: process.stdin
    output: process.stdout
}

rl.set-prompt '==> '
rl.prompt!

cc = new Console!

rl.on \line, ->
    cc.exec-line it
    rl.prompt!

rl.on \close, ->
    console.log '' # needs a trailing newline, I think
    process.exit 0
