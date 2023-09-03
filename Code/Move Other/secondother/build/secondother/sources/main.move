script {
  use 0x42::Storage;
  use 0x1::debug;

  fun main() {
    let bool_box = Storage::create_box<bool>(true);
    let bool_val = Storage::value(&bool_box);

    assert(bool_val, 0); // deprecated, we should use assert!

    let u64_box = Storage::create_box<u64>(1000000);
    let _ = Storage::value(&u64_box);

    // Nested generic
    let u64_box_in_box = Storage::create_box<Storage::Box<u64>>(u64_box);

    // Accessing value of this nested box
    let value: u64 = Storage::value<u64>(
      &Storage::value<Storage::Box<u64>>( // Box<u64> type
        &u64_box_in_box // Box<Box<u64>> type
      )
    );
    
    debug::print<u64>(&value);
  }
}