// # Use script

// Write this script to test
script {
  use 0x42::Company;
  use std::debug::{
    print as PRINT
  };

  fun do_stuff() {
    let info = Company::get_info(); // Info must have has drop
    PRINT(&info);
  }
}
