# small-forth
# Forth interpreter in Pharo Smalltalk.

## Introduction

For more see https://chicoary.wordpress.com/smallforth/.

SmallForth was developed based on the commands shown in the [Starting Forth book](https://www.forth.com/starting-forth/1-forth-stacks-dictionary/). 

Forth words in upper case are accepted. 
For example:

```Forth
7 dup DUP SWAP drop
```

its valid. 

`SWAP` is the same as `swap` but `Swap` is not.

Strings are displayed in Pharo Smalltalk Transcript.

![SmallForth Hello World](https://chicoary.files.wordpress.com/2019/06/smallforth-hello-world.png)

There is still no [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) available.

## Examples

The following example shows how to run a program written in Forth in the Pharo environment:

```Smalltalk
ForthInterpreter new eval: '1 2 dup'
```

To get the top of the parameter stack use `top`:

```Smalltalk
(ForthInterpreter new eval: '1 2 dup';top) >>> 2
```

To obtain the contents of the parameter stack use `stack`:

```Smalltalk
(ForthInterpreter new eval: '1 2 dup';stack) asArray >>> #(2 2 1)
```

Here is a more complex example (See [4. Decisions, Decisions…](https://www.forth.com/starting-forth/4-conditional-if-then-statements/) in Starting Forth):


```Smalltalk
example
   | expr | 
   expr := ': egg-size
   dup 18 < if  ." reject "      else
   dup 21 < if  ." small "       else
   dup 24 < if  ." medium "      else
   dup 27 < if  ." large "       else
   dup 30 < if  ." extra large " else
      ."  error "
   then then then then then drop ;

	{1} dup . egg-size'.

	Transcript openIfNone.
	Transcript clear. 
	ForthInterpreter new eval: (expr format: {  
		UIManager default request: 'Egg size?'
	})
```

