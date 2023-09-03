/// This module defines a minimal and generic Coin and Balance.
module named_addr::basic_coin2 {
  use std::signer;

  /// Error codes
  const ENOT_MODULE_OWNER: u64 = 0;
  const EINSUFFICIENT_BALANCE: u64 = 1;
  const EALREADY_HAS_BALANCE: u64 = 2;

  struct Coin<phantom CoinType> has store {
    value: u64
  }

  struct Balance<phantom CoinType> has key {
    coin: Coin<CoinType>
  }

  /// Publish an empty balance resource under `account`'s address. This function must be called before
  /// minting or transferring to the account.
  public fun publish_balance<CoinType>(account: &signer) {
    let empty_coin = Coin<CoinType> { value: 0 };
    assert!(!exists<Balance<CoinType>>(signer::address_of(account)), EALREADY_HAS_BALANCE);
    move_to(account, Balance<CoinType> { coin:  empty_coin });
  }

  /// Mint `amount` tokens to `mint_addr`. This method requires a witness with `CoinType` so that the
  /// module that owns `CoinType` can decide the minting policy.
  public fun mint<CoinType: drop>(mint_addr: address, amount: u64, _witness: CoinType) acquires Balance {
    // Deposit `total_value` amount of tokens to mint_addr's balance
    deposit(mint_addr, Coin<CoinType> { value: amount });
  }

  public fun balance_of<CoinType>(owner: address): u64 acquires Balance {
    borrow_global<Balance<CoinType>>(owner).coin.value
  }

  /// Transfers `amount` of tokens from `from` to `to`. This method requires a witness with `CoinType` so that the
  /// module that owns `CoinType` can decide the transferring policy.
  public fun transfer<CoinType: drop>(from: &signer, to: address, amount: u64, _witness: CoinType) acquires Balance {
    let check = withdraw<CoinType>(signer::address_of(from), amount);
    deposit<CoinType>(to, check);
  }

  fun withdraw<CoinType>(addr: address, amount: u64) : Coin<CoinType> acquires Balance {
    let balance = balance_of<CoinType>(addr);
    assert!(balance >= amount, EINSUFFICIENT_BALANCE);
    let balance_ref = &mut borrow_global_mut<Balance<CoinType>>(addr).coin.value;
    *balance_ref = balance - amount;
    Coin<CoinType> { value: amount }
  }

  fun deposit<CoinType>(addr: address, check: Coin<CoinType>) acquires Balance{
    let balance = balance_of<CoinType>(addr);
    let balance_ref = &mut borrow_global_mut<Balance<CoinType>>(addr).coin.value;
    let Coin { value } = check;
    *balance_ref = balance + value;
  }
}


/// Module implementing an odd coin, where only odd number of coins can be
/// transferred each time.
module named_addr::my_odd_coin {
  use std::signer;
  use named_addr::basic_coin2;

  struct MyOddCoin has drop {}

  const ENOT_ODD: u64 = 0;

  public fun setup_and_mint(account: &signer, amount: u64) {
    basic_coin2::publish_balance<MyOddCoin>(account);
    basic_coin2::mint<MyOddCoin>(signer::address_of(account), amount, MyOddCoin {});
  }

  public fun transfer(from: &signer, to: address, amount: u64) {
    // amount must be odd.
    assert!(amount % 2 == 1, ENOT_ODD);
    basic_coin2::transfer<MyOddCoin>(from, to, amount, MyOddCoin {});
  }

  /*
      Unit tests
  */
  #[test(from = @0x42, to = @0x10)]
  fun test_odd_success(from: signer, to: signer) {
    setup_and_mint(&from, 42);
    setup_and_mint(&to, 10);

    // transfer an odd number of coins so this should succeed.
    transfer(&from, @0x10, 7);

    assert!(basic_coin2::balance_of<MyOddCoin>(@0x42) == 35, 0);
    assert!(basic_coin2::balance_of<MyOddCoin>(@0x10) == 17, 0);
  }

  #[test(from = @0x42, to = @0x10)]
  #[expected_failure]
  fun test_not_odd_failure(from: signer, to: signer) {
    setup_and_mint(&from, 42);
    setup_and_mint(&to, 10);

    // transfer an even number of coins so this should fail.
    transfer(&from, @0x10, 8);
  }
}
