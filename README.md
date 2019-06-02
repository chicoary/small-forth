# small-forth
# Forth interpreter in Pharo Smalltalk.

For more see https://chicoary.wordpress.com/smallforth/.

SmallForth was developed based on the commands shown in the [Starting Forth book](https://www.forth.com/starting-forth/1-forth-stacks-dictionary/). Strings are displayed in Pharo Smalltalk Transcript.

There is still no REPL available.

The following example shows how to run a program written in Forth in the Pharo environment:

```
ForthInterpreter new eval: '1 2 dup'
```

To get the top of the stack use:

```
ForthInterpreter new eval: '1 2 dup';top >>> 2
```

To obtain the contents of the stack use:

```
ForthInterpreter new eval: '1 2 dup';stackCopy asArray >>> #(2 2 1)
```

