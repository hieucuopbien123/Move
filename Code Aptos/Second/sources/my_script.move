script {
  use std::signer;
  use aptos_framework::aptos_account;
  use aptos_framework::aptos_coin;
  use aptos_framework::coin;
  use addr::my_module;
  use std::vector;

  fun main(src: &signer, dest: address, desired_balance: u64) {
    let src_addr = signer::address_of(src);
    
    // my_module::do_nothing(); // Cannot use our own module in the script

    let balance = coin::balance<aptos_coin::AptosCoin>(src_addr);
    if (balance < desired_balance) {
      aptos_account::transfer(src, dest, desired_balance - balance);
    };

    // # Use library / vector
    let a = (vector[]: vector<bool>); // Cannot infer type so we must explicitly show the type
    // Must have paranthesis like this.
    let b = vector[0u8, 1u8, 2u8]; // Auto infer type vector<u8>

    assert!(*vector::borrow(&b, 0) == 5, 42);
  }
}