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

  public fun destroy(account: &signer) acquires Collection {
    let collection = move_from<Collection>(Signer::address_of(account));
    // Account no longer has resource attached

    // Now we must use resource value - we'll destructure it
    // Look carefully - Items must have drop ability
    let Collection { items: _ } = collection;
    // We can also pass resouces to outside module but cannot do anything more because resouces is limited outside

    // Done. resource destroyed
  }
}