# zap-proto/ocaml

> **Docs:** [ZAP OCaml SDK](https://zap-proto.dev/docs/sdks/ocaml) · part of the [ZAP Protocol](https://zap-proto.io)

OCaml code generator and runtime for ZAP (Zero-copy App Proto). Produces idiomatic OCaml modules from `.zap` schemas; pairs with `zap-proto/ocaml-rpc` for the RPC layer.

## Install

```bash
opam install zap-proto
```

## Generate code

```bash
zap compile -o ./gen --ocaml schema/*.zap
```

## Encode / decode

```ocaml
open Zap_proto

let () =
  let msg = Gen.Message.make ~id:42 ~name:"hello" () in
  let bytes = Gen.Message.to_bytes msg in
  let decoded = Gen.Message.of_bytes bytes in
  Printf.printf "%d %s\n" decoded.id decoded.name
```

## License

MIT
