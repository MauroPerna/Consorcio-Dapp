// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./BaseUser.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Employee is BaseUser, Ownable {

    struct EmployeeStruct {
        string name;
        address employeeAddress;
        string profession;
        uint salary;
    }

    EmployeeStruct[] private employeeList;

    receive() external override payable {}
    fallback() external override payable {}

    constructor() BaseUser("", 0x0000000000000000000000000000000000000000) {}

    function addNewEmployee(string memory _name, address _employeeAddress, string memory _profession, uint _salary) public onlyOwner{
        employeeList.push(EmployeeStruct(_name, _employeeAddress, _profession, _salary));
    }

    function getSalary(address _employeeAddress) public view returns(uint salary) {
        for(uint i = 0; i < employeeList.length; i++) {
            if(employeeList[i].employeeAddress == _employeeAddress) {
                return employeeList[i].salary;
            }
        }
        return 0;
    }

    function getTotalAmountForSalaries() public view returns(uint){
        uint amount = 0;
        for(uint i = 0; i < employeeList.length; i++) {
            amount += employeeList[i].salary;
        }
        return amount;
    }

    function withdrawal() public {
        uint salary = getSalary(msg.sender);
        require(salary > 0, "something went wrong");
        require(address(this).balance >= salary, "The balance of contract is insufficient");
        (bool success,) = withdrawAddress.call{value: salary}("");
        require(success == true, "Fallo la transferencia");
        emit WithdrawalSuccessful(address(this).balance);
    }

}