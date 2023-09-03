module 0x42::SisterCompany {
  friend 0x42::Company; 
  // Company will be friend of sister company

  // Any friend module of this module can call this friend function
  public(friend) fun get_company_name(): vector<u8>  {
    return b"Sister company"
  }
}