{parse: _parse} = require '../lib/syntax.js'

function pprint ex
    if ex.type
        if ex.type == 'param' then return "@#{ex[0]}"
        if ex.length == 0 then return "(#{ex.type})"
        return "(#{ex.type} #{ex.map(pprint).join ' '})"
    else if array.isarray ex
        return "(? #{ex.map(pprint).join ' '})"
    else if typeof ex == \string
        return "'#{ex}'";
    else
        return ex.to-string!

function unparse ex
    return _unparse(ex)[0]

function _unparse ex
    function parenize ex, prec
        return ex.map ->
            [sub, xprec] = _unparse it
            if xprec >= prec
                sub = "(#{sub})"
            sub
    function op s
        return " #{opns s} "
    function opns s
        return "\x1b[33m#{s}\x1b[0m"
    function name s
        return "\x1b[34m#{s}\x1b[0m"

    if ex.type
        switch ex.type
            case \param
                val = ex[0]
                return [name val, 0]
            case \not
                s = parenize ex, 2
                return ["#{opns "¬"}#{s.0}", 1]
            case \and
                s = parenize ex, 2
                return [s.join(op '∧'), 2]
            case \or
                s = parenize ex, 2
                return [s.join(op '∨'), 2]
            case \implies
                s = parenize ex, 3
                return [s.join(op '→'), 3]
            case \dblimplies
                s = parenize ex, 3
                return [s.join(op '↔'), 3]
            default
                throw new Error(
                    "Unknown .type in AST: #{pprint ex} This is a bug.")
    else
        throw new Error("Typeless node in AST: #{pprint ex} This is a bug.")

function lc-eval vars, ex
    if ex.type
        switch ex.type
            case \param
                val = ex[0]
                if val.match /^\d+$/
                    return 0 != parseInt val, 10
                else
                    return vars[val]
            case \not
                return not lc-eval vars, ex[0]
            case \and
                return ex.map(-> lc-eval vars, it).reduce((and))
            case \or
                return ex.map(-> lc-eval vars, it).reduce((or))
            case \implies
                [a, b] = ex.map(-> lc-eval vars, it)
                return (not a) or b
            case \dblimplies
                [a, b] = ex.map(-> lc-eval vars, it)
                return a == b
            default
                throw new Error(
                    "Unknown .type in AST: #{pprint ex} This is a bug.")
    else
        throw new Error("Typeless node in AST: #{pprint ex} This is a bug.")

function get-vars ex
    if Array.isArray ex
        if ex.type == 'param' then
            val = ex[0]
            if val.match /^\d+$/
                return []
            return [val]
        if ex.length == 0 then return []
        vars = ex.map(get-vars).reduce (a, b) -> a.concat b
# get only unique names
        a = {}
        for v in vars
            a[v] = 1
        return [k for k of a]
    else
        return []

function makettab vars
    function pfill rows, height, q
        h2 = height * 2
        for i til rows.length / h2
            for j til height
                rows[i * h2 + j][q] = true
                rows[i * h2 + height + j][q] = false

    total = Math.pow(2, vars.length)
    rs = [{} for til total]
    for v, i in vars
        pfill rs, total / Math.pow(2, i + 1), v
    return rs

function user-truth bool
    return if bool
        '\x1b[32mT\x1b[0m'
    else
        '\x1b[31mF\x1b[0m'

const SEP = ' │ '

class Console
    ->
        @constraints = []
        @last-ex = null
        @macros = {}

    check: (thing) ~>
        vars = []
        for con in @constraints.concat([thing])
            Array::push.apply vars, get-vars con

        nmatch = []
        for tt-row in makettab vars
            for con, i in @constraints
                res = lc-eval tt-row, con
                mres = lc-eval tt-row, thing
                if res != mres
                    if i not in nmatch
                        nmatch.push i
        return if nmatch.length > 0 then nmatch else null

    macro-filter: (ex) ~>
        if ex.type and ex.type == \param
            if @macros[ex[0]]?
                return @macro-filter @macros[ex[0]]
            else
                return ex
        else if Array.isArray ex
            n = ex.map @macro-filter
            n.type = ex.type
            return n
        else
            return ex

    parse: (str) ~>
        preast = _parse str
        return @macro-filter preast

    exec-line: (line) ~>
        try
            if m = line.match /^ast\s+(.+)$/
                ast = @parse m[1]
                console.log pprint ast
            else if m = line.match /^syn(?:tax)?\s+(.+)$/
                ast = @parse m[1]
                console.log unparse ast
            else if m = line.match /^con(?:straint?)?\s+(.+)$/
                ast = @parse m[1]
                if which = @check ast
                    console.log "Could not add constraint: violates #{
                        which.map(-> "\##{it}").join ', '}"
                else
                    @constraints.push ast
            else if m = line.match /^wha(?:tis)?\s+(\d+)\s*$/
                console.log unparse @constraints[parseInt m[1], 10]
            else if m = line.match /^tab(?:le)?\s+(.+)$/
                ast = @parse m[1]
                vars = get-vars ast
                vars.sort!
                tab = makettab vars
                vars |> (.concat [m[1]]) |> (.map -> "\x1b[33m#{it}\x1b[0m") |>
                    (.join SEP) |> console.log
                for row in tab 
                    res = lc-eval row, ast
                    vars |> (.map -> row[it]) |> (.concat [res]) |>
                        (.map user-truth) |> (.join SEP) |> console.log

            else if m = line.match /^javascript\s+(.+)$/
                console.log eval m[1]
            else if m = line.match /^def(?:ine)?\s+([_a-zA-Z0-9]+)\s+(.+)$/
                preast = _parse m[2]
                @macros[m[1]] = preast
            else
                ast = @parse line
                if which = @check ast
                    console.log "Violates #{which.map(-> "\##{it}").join ', '}"
        catch e
            if e.name == \SyntaxError
                console.log e.message
            else
                console.log "uncaught exception:"
                @last-ex := e
                console.log e
        return
module.exports = Console
