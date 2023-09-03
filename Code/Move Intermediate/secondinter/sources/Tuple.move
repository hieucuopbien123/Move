// # Basic / Use tuples 

module 0x42::Tuples {
  use std::debug;

  fun lots_of_things()
  : (u8, vector<u8>, bool) {
    let x = 0;
    let name = b"Richard";
    let truthy = true;
    (x, name, truthy) // Can return tuple like this
  }

  fun must_be_odd(num: u8): bool {
    assert!(num % 2 == 1, 88); // If even, throw error code 88
    return true
  }

  fun must_be_even(num: u8): bool {
    if(num % 2 != 0) abort 9;
    return true
  }

  #[test]
  fun test_lots_of_things() {
    let (x, name, truthy) = lots_of_things();
    debug::print(&x);
    debug::print(&name);
    debug::print(&truthy);
  }

  #[test]
  fun test_must_be_off() {
    let x = must_be_odd(1);
    assert!(x == true, 0);
  }

  #[test]
  fun test_must_be_even() {
    let x = must_be_even(0);
    assert!(x == true, 0);
  }
}