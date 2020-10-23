# Bigstring [![Build Status](https://travis-ci.org/c-cube/ocaml-bigstring.svg?branch=master)](https://travis-ci.org/c-cube/ocaml-bigstring)

**NOTE**: I recommend using [bigstringaf](https://github.com/inhabitedtype/bigstringaf) now. It has fast operations written in C and is better maintained.

A set of utils for dealing with `bigarrays` of `char` as if they were proper
OCaml strings.

## Usage

```ocaml
#require "bigstring";;
#install_printer Bigstring.print;;
module B = Bigstring;;

# let s1 = B.of_string "  abcd ";;
val s1 : B.t = "  abcd "

# let s2 = B.trim s1;;
val s2 : B.t = "abcd"

# B.index ~c:'b' s2 ;;
- : int = 1

# let str = "__";;
val str : string = "__"

# B.blit_of_string str 0 s2 1 2;;
- : unit = ()

# s2;;
- : B.t = "a__d"
```

## Documentation

http://c-cube.github.io/ocaml-bigstring/

## License

This code is free, under the BSD license.
