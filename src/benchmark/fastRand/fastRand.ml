
(* Double-secret undocumented API for direct calls to C functions which
   do not allocate from the OCaml heap *)
external next : unit -> int = "zap_bench_nextFastRand" "noalloc"
external int  : int  -> int = "zap_bench_fastRand"     "noalloc"

(* Double-secret undocumented API for direct calls to functions on doubles *)
external double : float -> float =
  "zap_bench_fastRandDouble" "zap_bench_unboxed_fastRandDouble" "float"

