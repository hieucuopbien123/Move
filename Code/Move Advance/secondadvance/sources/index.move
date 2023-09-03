// # Basic / Use operator as
// # Type and variables

script {
  fun main(_a: address) {
    // # Use library
    use std::debug as Debug;

    let a = 10;
    let _ = 0x1; // int in hexa
    let a2 = 10u128; // Value is 10, type is u128
    if(a2 < 8u128) {};

    if (a != (a2 as u8)) abort 11; // we can only compare same size integers

    let _a1: address = @0x1; // shorthand for 0x00000000000000000000000000000001
    let _a2: address = @0x42; // shorthand for 0x00000000000000000000000000000042
    let _a3: address = @0xDEADBEEF; // shorthand for 0x000000000000000000000000DEADBEEF
    let _a4: address = @0x0000000000000000000000000000000A;
    let _a5: address = @std; // Assigns `a5` the value of the named address `std`
    let _a6: address = @66;

    
    // # Expression and scope
    (); // # Empty expression

    true != false; 3;

    // Block expression
    { { }; }; 

    let _a = {
      let c = 10;
      c*100
    }; // a got value of 1000 because no semicolon at c*100

    // Use loop
    let testLoop = 0;
    loop {
      testLoop = testLoop + 1;
      if (testLoop == 2) {
        break
      }
    };
    Debug::print<u8>(&testLoop);
    Debug::print(&0); // Always use &
  }
}
