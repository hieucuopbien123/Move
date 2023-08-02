// # Use script

// Write this script to test. We don't need to use #[test] here
script {
  use 0x42::Company;
  use std::debug;

  fun do_stuff() {
    let info = Company::get_info(); // Info must have has drop
    debug::print(&info);
  }
}
