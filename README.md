# zap-proto/ocaml

> **Docs:** [ZAP OCaml SDK](https://zap-proto.dev/docs/sdks/ocaml) · part of the [ZAP Protocol](https://zap-proto.io)

OCaml code generator and runtime for ZAP (Zero-copy App Proto). The compiler
plugin (`zapc-ocaml`) turns `.zap` schemas into idiomatic OCaml modules; the
`zap` runtime library provides the zero-copy reader/builder, codecs and packing.

The generated code uses the serialized wire format as its in-memory
representation, so there is no parse/decode step — accessors read straight out
of the buffer. As a consequence the generated types are *not* OCaml records:
each field is read with `<field>_get` and written with `<field>_set` (or
`<field>_set_exn` for bounded integers). See [`README.adoc`](README.adoc) for
the full type mapping and generated-module structure.

## Install

```bash
opam install zap
```

The plugin shells out to the `zap` schema compiler at build time; install it via
the `conf-zap` package (see [`conf-zap.opam`](conf-zap.opam)).

## Generate code

`zap compile` reads the schema and pipes a code-generation request to the
OCaml plugin. With dune, codegen is a rule:

```scheme
(rule
 (targets shape.ml shape.mli)
 (action (run zap compile -o %{bin:zapc-ocaml} %{dep:shape.zap})))
```

Or directly:

```bash
zap compile -o zapc-ocaml shape.zap
```

## Encode / decode

Given a `foo.zap` declaring `struct Foo { num @0 :Int32; }`, the plugin emits a
functor `Foo.Make` parameterised over the message backend (`bytes` or
`Bigarray`):

```ocaml
module Foo = Foo.Make(Zap.BytesMessage)

(* build a message and serialize it *)
let encode (n : int32) : string =
  let b = Foo.Builder.Foo.init_root () in
  Foo.Builder.Foo.num_set b n;
  Zap.Codecs.serialize ~compression:`None (Foo.Builder.Foo.to_message b)

(* read a field back, zero-copy, out of the wire bytes *)
let decode_exn (s : string) : int32 =
  let stream = Zap.Codecs.FramedStream.of_string ~compression:`None s in
  match Zap.Codecs.FramedStream.get_next_frame stream with
  | Ok message -> Foo.Reader.Foo.num_get (Foo.Reader.Foo.of_message message)
  | Error _ -> failwith "incomplete frame"

let () = Printf.printf "%ld\n" (decode_exn (encode 3l))
```

Runnable end-to-end examples live in [`src/examples/`](src/examples).

## License

BSD-2-Clause. See [`LICENSE.md`](LICENSE.md).
