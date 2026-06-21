# Build the installable artifacts: the `zap` runtime library, the `zap.unix`
# library, and the `zapc-ocaml` code-generation plugin. None of these need the
# external `zap` schema compiler.
build:
	dune build @install

# Run the unit + conformance tests. These link code generated from the `.zap`
# schemas, so they require the `zap` schema compiler (from cpp-core) on PATH.
# Set ZAP_COMPILER to any non-empty value to enable the codegen + test stanzas.
test:
	ZAP_COMPILER=1 dune build @install @runtest @src/benchmark/benchmarks

clean:
	rm -rf _build

benchmark:
	ZAP_COMPILER=1 python src/benchmark/test.py

doc:
	dune build @doc
