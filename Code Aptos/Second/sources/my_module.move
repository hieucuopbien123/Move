module addr::my_module {
  public entry fun do_nothing() { }
  
  struct A { b: B }
  struct B { c : u64 }
  fun f(a: &A): &u64 {
    &a.b.c
  }

  // # Basic / Use tuples
  fun returns_unit(): () { () } // Return an empty tuple

  // Tuple can be destructured
  fun returns_2_values(): (bool, bool) { (true, false) }
  fun returns_3_values(): (u64, bool, address) {
    (0, false, @0x42)
  }
  fun examples_with_function_calls() {
    let () = returns_unit();
    let (x, y, z): (u64, bool, address) = returns_3_values();
    (_, y) = returns_2_values();
  }

  fun test() {
    // We can cast with tuple because it have subtype. 
    let x: &u64 = &0;
    let y: &mut u64 = &mut 1;

    // VD: (&u64, &mut u64) is a subtype of (&u64, &u64) since &mut u64 is a subtype of &u64
    let (a, b): (&u64, &u64) = (x, y);
  }

  // # Basic / Equality operator
  struct S has drop, copy { f: u64, g: vector<u8> }
  fun always_true(): bool {
    // In move, we can compare user-defined type with each other. Equality operator only work with same type
    let s = S { f: 0, g: b"" };
    (copy s) == s
  }

  // # Expression and scope / Local Variables
  fun annotated() {
    let S { f, g: f2 }: S = S { f: 0, g: b"He" };
    // Destructuring struct to init value for localvar

    let a: u8 = return (); // return and abort can have any type
    let b: bool = abort 0; 
    let c: signer = loop (); // loop has type () if it has a break. If there is no break, it could have any type
  }

  // Destructuring struct more complex
  struct X has drop { f: u64 }
  struct Y has drop { x1: X, x2: X }
  fun new_x(): X {
    X { f: 1 }
  }
  fun example() {
    let Y { x1: X { f }, x2 } = Y { x1: new_x(), x2: new_x() };
    assert!(f + x2.f == 2, 42); // ok
    // Meaning that: let X { f } = e;  <==>  let X { f: f } = e;
  }
}