# Style guide:

## Variables / methods
Variables and method names are CamelCase (not snake_case), with varibles having a leading lowercase, and methods being capitalized.

## Indent
Not supper important, going to start to indent with tab indents, with my editor set to 4 chars per tab.
Don't mix, keep them clean, use spaces after the initial indent for alignment if needed.

## Line length
This is not a hard style.
Since most editors can handle longer lines, try to keep lines shorter than 160 chars.

## Spaces around (), and in parameters
Try to keep no space before or after the left bracket.
And no space before the right bracket.
Use a space after the comma(,) for parameter lists.

Keep the parameter list on a single line, and as short as possible.
A long list might indicate that the function does too much, or data should come in as a table.

## Logic
All if statements should do positive tests unless otherwise not possible.
IE.  `if boolean then` instead of `if not boolean then`

Try to avoid shortcut code and prefer indented code.
IE. don't do `if not boolean then return nil end`.   Do `if boolean then <code to do> end`.
