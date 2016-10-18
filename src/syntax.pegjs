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
    var xor = makeS('xor');
    var implies = makeS('implies');
    var dblimplies = makeS('dblimplies');
//  var lequiv = makeS('lequiv');
}

program = S a:expr S { return a; }

AND "^" = '&' / '&&' / '∧' / '*'
OR "∨" = '|' / '||' / '∨' / '+'
XOR "xor" = '^'

NAND = NOT AND / AND SUFFIX_NOT
NOR = NOT OR / OR SUFFIX_NOT
NXOR = NOT XOR / XOR SUFFIX_NOT

IMPLIES "→" = '->' / '→'
RIMPLIES "←" = '<-' / '←'
DBLIMPLIES "↔" = '<->' / '↔'
// LEQUIV = '<=>' / '⟺'
NOT "¬" = '!' / '¬'
SUFFIX_NOT "'" = "'"
WHITESPACE = [ \t\r\n\v\f]+
COMMENT = '[[' (!']]' .)* ']]'
S "whitespace" = (WHITESPACE / COMMENT)*

keyword = AND / OR / IMPLIES / RIMPLIES / DBLIMPLIES / NOT / SUFFIX_NOT

parens = a:(
    '(' S expr S ')' /
    '[' S expr S ']'
) { return a[2]; }

parameter = !keyword a:$([_a-zA-Z0-9]+) { return param(a); }

term = nots:(NOT S)* val:(parameter / parens) snots:(S SUFFIX_NOT)*
    { return (nots.length + snots.length)%2? not(val) : val; }

and = head:term tail:(S AND S a:term {return a;})+
    { return and.apply(this, [head].concat(tail)); }

or = head:subimp2 tail:(S OR S a:subimp2 {return a;})+
    { return or.apply(this, [head].concat(tail)); }

xor = head:term tail:(S XOR S a:term  {return a;})+
    { return xor.apply(this, [head].concat(tail)); }

nand = head:term tail:(S NAND S a:term {return a;})+
    { return not(and.apply(this, [head].concat(tail))); }

nor = head:subimp2 tail:(S NOR S a:subimp2 {return a;})+
    { return not(or.apply(this, [head].concat(tail))); }

nxor = head:term tail:(S XOR S a:term  {return a;})+
    { return not(xor.apply(this, [head].concat(tail))); }

subimp2 = and / nand / term
subimp = or / xor / nor / nxor / subimp2

implies = (a:subimp S IMPLIES S b:subimp { return implies(a, b); }) /
          (b:subimp S RIMPLIES S a:subimp { return implies(a, b); })

dblimplies = a:subimp S DBLIMPLIES S b:subimp { return dblimplies(a, b); }

superimp = implies / dblimplies / subimp
//
// equiv = a:superimp LEQUIV b:superimp { lequiv(a, b); }
//
expr = superimp
