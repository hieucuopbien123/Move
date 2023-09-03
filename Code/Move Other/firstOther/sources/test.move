// # Basic / Modules
// # Type and variables / Use constant
address 0x1 {
  module Math {
    const RECEIVER: address = @0x1;
    public fun get_receiver(): address {
      RECEIVER
    }
    
    public fun sum(a: u64, b: u64): (u64, u8) {
      (a + b, 1)
    }
    public fun sum2() {
      let (_x,_y) = sum(1,2);
    }

    // # Basic / Use struct
    struct Empty {}
    public fun empty(): Empty {
      Empty {}
    }
    struct Test has copy, drop{
      id: u8,
      test: u8
    }
    public fun test(test: Test): u8 {
      let Test {id, test: _} = test; // unused must have _
      id
    }
    public fun test_copy(test: Test) {
      let _ = copy test; // struct must have ability to copy to use
    }

    // # Type and variables / Ownership and references / Dereference
    struct TestType has drop, copy {
      a: u8
    }
    public fun test1(_t: &TestType): u8{
      *&_t.a
    }
    public fun test2() {
      let t: TestType = TestType {
        a: 9
      };
      test1(&t);
    }
  }
}
