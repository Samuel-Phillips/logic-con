# logic-con

Console where you can enter boolean logic expressions and have it check to see
if they are equivalent to other expressions, or just print out a truth table.

See [`man logic-con`][1] for details on usage.

    ==> tab a && (b || c)
    a │ b │ c │ a && (b || c)
    T │ T │ T │ T
    T │ T │ F │ T
    T │ F │ T │ T
    T │ F │ F │ F
    F │ T │ T │ F
    F │ T │ F │ F
    F │ F │ T │ F
    F │ F │ F │ F


[1]: mansrc/logic-con.md
