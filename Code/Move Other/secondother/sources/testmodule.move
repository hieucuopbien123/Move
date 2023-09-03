// # Basic / Use generic
module 0x42::Storage {
  struct Box<T: copy + drop> has drop, copy{
    value: T
  }
  // Box can be drop and value in box must be type of copy and drop too
  // Attribute of any field inside struct must cover all attribute of that struct, except attribute "key"

  public fun create_box<T: copy + drop>(value: T): Box<T> {
    Box<T>{ value }
  }
  public fun value<T: copy + drop>(box: &Box<T>): T {
    *&box.value
  }

  struct Shelf<T1: copy + drop, T2: copy + drop> has copy{
    box_1: Box<T1>,
    box_2: Box<T2>
  }
  public fun create_shelf<Type1: copy + drop, Type2: copy + drop>(
    box_1: Box<Type1>,
    box_2: Box<Type2>
  ): Shelf<Type1, Type2> {
    Shelf {
      box_1,
      box_2
    }
  }

  // # Type and variables / Type signer
  use 0x1::signer;
  fun testSigner(account: signer) {
    let _ = account;
  }
  // let's proxy Signer::address_of
  public fun get_address(account: signer): address {
    signer::address_of(&account)
  }
  
}