@0xf5d779179e64a219;

# A more complex type from https://zap-proto.io/docs/language

# compile this with: zapc -o ocaml shape.zap

struct Shape {
  colour @0 :Colour;

  enum Colour {
    red @0;
    green @1;
    blue @2;
  }

  union {
    circle :group {
      radius @1 :Float64;
    }
    rectangle :group {
      width @2 :Float64;
      height @3 :Float64;
    }
  }
}
