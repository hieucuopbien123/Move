// # Basic

module 0x42::Company {
  // # Use library
  use std::vector::{
    Self,
    push_back
  };
  const CONTRACT:address = @0x42;
  struct Employees has drop{
    people: vector<Employee>
  }
  struct Employee has copy, drop {
    name: vector<u8>,
    age: u8,
    income: u64
  }

  struct Info has drop {
    company_name: vector<u8>,
    owns: vector<u8>
  }
  public fun get_info(): Info {
    // This module can call any public friend func of its friend with keyword "use"
    let sisterCompanyName = 0x42::SisterCompany::get_company_name();

    let info = Info {
      company_name: b"a new company",
      owns: sisterCompanyName
    };
    return info 
  }

  public fun create_employee(_employee: Employee, _employees: &mut Employees): Employee {
    let newEmployee = Employee {
      name: _employee.name,
      age: _employee.age,
      income: _employee.income
    };
    add_employee(newEmployee, _employees);
    return newEmployee
  }
  fun add_employee(_employee: Employee, _employees: &mut Employees) {
    vector::push_back(&mut _employees.people, _employee);
  }
  public fun increase_income(_employee: &mut Employee, bonus: u64): &mut Employee {
    _employee.income = _employee.income + bonus;
    return _employee
  }
  public fun decrease_income(_employee: &mut Employee, penalty: u64): &mut Employee {
    _employee.income = _employee.income - penalty;
    return _employee
  }
  public fun multiply_income(_employee: &mut Employee, factor: u64): &mut Employee {
    _employee.income = _employee.income * factor;
    return _employee
  }
  public fun divide_income(_employee: &mut Employee, divisor: u64): &mut Employee {
    _employee.income = _employee.income / divisor;
    return _employee
  }
  public fun is_employee_age_even(_employee: &Employee): bool {
    let isEven: bool;
    if(_employee.age % 2 == 0) {
      isEven = true;
    } else {
      isEven = false;
    }; 
    return isEven
  }


}