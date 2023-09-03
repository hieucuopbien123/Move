// # Basic 
// move sandbox run ./sources/testscript.move --args 0x1
script {
  use std::debug;

  fun main(addr: address) {
    debug::print(&addr);
  }
}