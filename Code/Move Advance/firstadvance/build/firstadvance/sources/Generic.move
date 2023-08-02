// # Basic / Use generic

module 0x42::Generic {
  use std::debug;
  use std::vector;

  struct Flex<T1, T2> has drop{
    x: T1,
    y: vector<T2>
  }

  // Should make this function generic instead of create 2 functions like this
  fun new_flexi(_x: u8, _y: vector<bool>): Flex<u8, bool> {
    return Flex {
      x: _x,
      y: _y
    }
  }

  fun new_flexi2(_x: u8, _y: vector<u8>): Flex<u8, u8> {
    return Flex {
      x: _x,
      y: _y
    }
  }

  fun generic_func<HelloType>(t: HelloType): HelloType {
    return t
  }

  // Create a vector of any type
  fun new_vector<T>(arg: T): vector<T> {
    let vec = vector::empty<T>();
    vector::push_back(&mut vec, arg);
    vec
  }

  #[test]
  fun test_new_flex() {
    let y = vector<bool>[true, false, true, true];
    let flexi = new_flexi(8, y);
    debug::print(&flexi);
  }

  #[test]
  fun test_new_flex2() {
    let y = vector<u8>[1, 77, 88, 9];
    let flexi = new_flexi2(8, y);
    debug::print(&flexi);
  }

  #[test]
  fun test_generic_func() {
    let vec = vector<bool>[true, true, true, false];
    // We can pass any type to this generic function without specify the type
    let thing = generic_func(b"a byte string");
    let thing2 = generic_func(vec);
    debug::print(&thing);
    debug::print(&thing2);
  }
  
  #[test]
  fun test_new_vector() {
    let vec = new_vector(true);
    debug::print(&vec);
  }
}