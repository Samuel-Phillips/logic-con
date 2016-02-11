{
    function makeS(name) { return function() {
        var a = Array.prototype.slice.call(arguments);
        a.type = name;
        a.loc = location();
        return a;
    }; }
    var param = makeS('param');
    var not = makeS('not');
    var and = makeS('and');
    var or = makeS('or');
    var implies = makeS('implies');
    var dblimplies = makeS('dblimplies');
//  var lequiv = makeS('lequiv');
}

program = S a:expr S { return a; }

AND "^" = '&&' / '∧'
OR "∨" = '||' / '∨'
IMPLIES "→" = '->' / '→'
RIMPLIES "←" = '<-' / '←'
DBLIMPLIES "↔" = '<->' / '↔'
// LEQUIV = '<=>' / '⟺'
NOT "¬" = '!' / '¬'
WHITESPACE = [ \t\r\n\v\f]+
COMMENT = '[[' (!']]' .)* ']]'
S "whitespace" = (WHITESPACE / COMMENT)*

keyword = AND / OR / IMPLIES / RIMPLIES / DBLIMPLIES / NOT

parens = a:(
    '(' S expr S ')' /
    '[' S expr S ']'
) { return a[2]; }

parameter = !keyword a:$([_a-zA-Z0-9]+) { return param(a); }

term = nots:(NOT S)* val:(parameter / parens)
    { return nots.length%2? not(val) : val; }

and = head:term tail:(S AND S a:term {return a;})+
    { return and.apply(this, [head].concat(tail)); }

or = head:term tail:(S OR S a:term {return a;})+
    { return or.apply(this, [head].concat(tail)); }

subimp = and / or / term

implies = (a:subimp S IMPLIES S b:subimp { return implies(a, b); }) /
          (b:subimp S RIMPLIES S a:subimp { return implies(a, b); })

dblimplies = a:subimp S DBLIMPLIES S b:subimp { return dblimplies(a, b); }

superimp = implies / dblimplies / subimp
//
// equiv = a:superimp LEQUIV b:superimp { lequiv(a, b); }
//
expr = superimp
