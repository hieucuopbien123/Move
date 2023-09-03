// # Example module BasicCoin
module 0xCAFE::basic_coin1 {
  // Only included in compilation for testing. Similar to #[cfg(testing)]
  // in Rust. Imports the `Signer` module from the MoveStdlib package.
  #[test_only]
  use std::signer;

  struct Coin has key {
    value: u64,
  }

  public entry fun mint(account: &signer, value: u64) {
    move_to(account, Coin { value })
  }

  // Run: aptos move test 
  #[test(account = @0xC0FFEE)]
  fun test_mint_10(account: &signer) acquires Coin {
    let addr = signer::address_of(account);
    mint(account, 10);
    // Make sure there is a `Coin` resource under `addr` with a value of `10`.
    // We can access this resource and its value since we are in the same module that defined the `Coin` resource.
    assert!(borrow_global<Coin>(addr).value == 10, 0);
  }
}
