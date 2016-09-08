% logic-con(1) Samuel Phillips | February 2016

# NAME

logic-con - shell for messing with boolean logic

# SYNOPSIS

**logic-con**

# DESCRIPTION

So there I was, doing my math homework, when I though, "Hey, this would be a fun
thing to make a computer do! And it ended with the first real "language" I've
ever written.

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

**def**, **define**
:   Define a macro to be expanded for all future expressions.

**syn**, **syntax**
:   Dump the expression with Unicode operators and syntax highlighting.

**wha**, **whatis**
:   Takes a constraint number, then prints the constraint.

# SYNTAX

Most of the operators in **logic-con** have a Unicode variant, as can be seen in
this table:

AND: **&&**, **∧**, **\***

OR: **||**, **∨**, **+**

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
- There's not quit command.
- There's no way to delete a macro or constraint.
- History should be saved in a file to allow commands to be quickly recalled.
- Probably many others...
