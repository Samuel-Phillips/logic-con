% logic-con(1) Samuel Phillips | February 2016

# NAME

logic-con - shell for messing with boolean logic

# SYNOPSIS

**logic-con**

# DESCRIPTION

This is a tool I wrote to evaluate boolean logic expressions. It can
pretty-print them, print truth tables, etc.

It's really useful for simplifying logical expressions: You can just add a
constraint for the original expression, then keep editing it until you get it to
a good level. If the results of your expression ever change (i.e. you make a
mistake), **logic-con** will alert you. Note that this only ensures your results
are correct, not your methods!

# COMMANDS

**con**, **constrain**, **constraint**
:   Adds a constraint. Note that it must be compatible with all previous
constraints.

**tab**, **table**
:   Prints a truth table for the expression.

**rtab**, **rtable**
:   Same as above but the table will be ordered differently

**def**, **define**
:   Define a macro to be expanded for all future expressions.

**syn**, **syntax**
:   Dump the expression with syntax highlighting.

**smode**
:   Defines which syntax to use with **syn**. Default is `c`. You can also
specify `m` for math-like Unicode operators, or `e` to use +, - and ' like in my
digital electronics class.

**wha**, **whatis**
:   Takes a constraint number, then prints the constraint.

# SYNTAX

Most of the operators in **logic-con** have a Unicode variant, as can be seen in
this table:

AND: **&**, **&&**, **∧**, **\***

OR: **|**, **||**, **∨**, **+**

XOR: **^**

IMPLIES: **->**, **→**

RIMPLIES: **<-**, **←**

DBLIMPLIES: **<->**, **↔**

NOT: **!**, **¬**, postfix **'**

As you can see, it's perfectly possible to type everything with a regular ASCII
keyboard. **logic-con** will always use the Unicode variants in it's output,
though. These symbols are accepted by the syntax, so you can copy and paste
things if you want.

The "and," "or," and "not" operators should be familiar to you, but there's also
the more exotic "implies" operators. They're not too complicated, though; a
quick web search should get you situated.

You can also add a prefix or postfix not onto an **and**, **or**, or **xor**
operator to make it into the corresponding not version (NAND, NOR, NXOR). The
not is placed around the entire expression, so `(a !& b !& c)` is the same as
`!(a & b & c)`. If you want to chain them in the traditional way, use
parenthesis.

You can add names to you expressions. These do not have any particular value,
instead, every possible true/false combination is run through. If a name has
been **define**d as a macro, it will be replaced by the appropriate expression.
Macro expansion is recursive. Also, these are not textual macros like in the C
preprocessor! You don't need to worry about parenthesis.

Commands should be at the start of the line. To feed an expression in and have
it be checked by the constraints, just type it in without a command. To quit,
use ^D.

# EXAMPLES

Prints a truth table for the expression "**p** ∨ (**q** ∧ **r**)."

    ==> syntax p || (q && r)

Adds a constraint and prints it out.

    ==> constraint p -> q
    ==> whatis 0

Adds a constraint and checks an expression against it.

    ==> constraint p -> q
    ==> !p || q

Defines macros for true and false.

    ==> define T 1
    ==> define F 0

# BUGS

- The tables don't print values for intermediate expressions.
- The tables don't change their column widths to accomodate variables more than
one letter long.
- There's no quit command.
- There's no way to delete a macro or constraint.
- History should be saved in a file to allow commands to be quickly recalled.
- Probably many others...

# COPYRIGHT

Copyright © 2016 Samuel Phillips.

**logic-con** is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version.

**logic-con** is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see http://www.gnu.org/licenses/.
