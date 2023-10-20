address 0x42 {
  module example {
    use std::vector;

    // # Expression and scope / Local Variables / Destructuring against reference
    struct T has drop { f1: u64, f2: u64 }
    fun test() {
      let t = T { f1: 1, f2: 2 };
      let T { f1: local1, f2: local2 } = &t; // Both local1 local2 are reference &u64. Must access via *local1
      let T { f1: local1, f2: local2 } = &mut t; // Both are &mut u64
    }

    // More complex
    struct X has drop { f: u64 }
    struct Y has drop { x1: X, x2: X }
    fun new_x(): X {
      X { f: 1 }
    }
    fun example() {
      let y = Y { x1: new_x(), x2: new_x() };

      let Y { x1: X { f }, x2 } = &y;
      assert!(*f + x2.f == 2, 42);

      let Y { x1: X { f: f1 }, x2: X { f: f2 } } = &mut y;
      *f1 = *f1 + 1;
      *f2 = *f2 + 1;
      assert!(*f1 + *f2 == 4, 42);
    }

    fun mutate_through_reference() {
      let x = 0;
      let y = 1;
      let r = if (true) &mut x else &mut y;
      *r = *r + 1; // Value of x will change
    }
    fun mutate_vector_throught_ref() {
      let v = vector::empty();
      vector::push_back(&mut v, 100);
      assert!(*vector::borrow(&v, 0) == 100, 42);
    }

    fun shaw_var() {
      let x = 0;
      assert!(x == 0, 42);

      let x = b"hello"; // x is shadowed
      assert!(x == b"hello", 42);
    }
  }
}