module addr::my_module {
  public entry fun do_nothing() { }
  
  struct A { b: B }
  struct B { c : u64 }
  fun f(a: &A): &u64 {
    &a.b.c
  }
}