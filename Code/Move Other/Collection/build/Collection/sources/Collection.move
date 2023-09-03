// # Use Resources / Create my own Collection resouces

module 0x42::Collection {
  use 0x1::signer;
  use 0x1::vector;

  struct Item has store {}

  struct Collection has key {
    items: vector<Item>
  }

  public fun start_collection(account: &signer) {
    move_to<Collection>(account, Collection {
      items: vector::empty<Item>()
    })
  }

  public fun exists_at(at: address): bool {
    exists<Collection>(at)
  }

  public fun size(account: &signer): u64 acquires Collection {
    let owner = signer::address_of(account);
    let collection = borrow_global<Collection>(owner);
    vector::length(&collection.items)
  }

  public fun add_item(account: &signer) acquires Collection {
    let collection = borrow_global_mut<Collection>(signer::address_of(account));
    vector::push_back(&mut collection.items, Item {});
  }
}