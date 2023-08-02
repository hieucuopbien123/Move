// # Basic

module 0x42::Company {
  use std::vector;

  // # Type and variables
  const CONTRACT:address = @0x42;

  struct Employees has drop{
    people: vector<Employee>
  }

  struct Employee has copy, drop {
    name: vector<u8>,
    age: u8,
    income: u64
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

  // No need to be public fun
  fun add_employee(_employee: Employee, _employees: &mut Employees) {
    vector::push_back(&mut _employees.people, _employee);
  }

  // Notice the output is &mut Employee
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

    // After if else must have semicolon
    if(_employee.age % 2 == 0) {
      isEven = true;
    } else {
      isEven = false;
    }; 

    return isEven
  }

  #[test]
  fun test_create_employee() {
    let richard = Employee {
      name: b"Richard",
      age: 31,
      income: 100
    };
    let employees = Employees {
      people: (vector[richard])
    };

    let createdEmployee = create_employee(richard, &mut employees);
    assert!(createdEmployee.name == richard.name, 0)
  }

  #[test]
  fun test_increase_income(){
    let richard = Employee {
      name: b"Richard",
      age: 31,
      income: 100
    };
    let employees = Employees {
      people: (vector[richard])
    };

    let createdEmployee = create_employee(richard, &mut employees);
    let increasedEmployeeIncome = increase_income(&mut createdEmployee, 100);
    assert!(increasedEmployeeIncome.income == 200, 0)
  }

  #[test]
  fun test_divide_income(){
    let richard = Employee {
      name: b"Richard",
      age: 31,
      income: 100
    };
    let employees = Employees {
      people: (vector[richard])
    };

    let createdEmployee = create_employee(richard, &mut employees);
    let dividedEmployeeIncome = divide_income(&mut createdEmployee, 1);
    assert!(dividedEmployeeIncome.income == 100, 0)
  }

  #[test]
  fun test_isIncomeAge(){
    let richard = Employee {
      name: b"Richard",
      age: 31,
      income: 100
    };
    let employees = Employees {
      people: (vector[richard])
    };

    let createdEmployee = create_employee(richard, &mut employees);
    let isEvenAge = is_employee_age_even(&createdEmployee);
    assert!(isEvenAge == false, 0)
  }
}