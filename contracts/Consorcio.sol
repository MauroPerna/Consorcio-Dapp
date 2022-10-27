// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Employee.sol";
import "./Tenant.sol";
import "./Service.sol";

contract Consorcio is Ownable {

    event PaymentSucessfully(address from, uint256 amount);

    struct ServiceStruct {
        string name;
        uint price;
    }

    Service private serviceContractInstance;

    Employee[] private employeeList;
    // Tenant[] private tenantList;
    ServiceStruct[] private serviceList;

    receive() external payable {}
    fallback() external payable {}

    constructor() {
        serviceContractInstance = new Service();
    }


    modifier paid() {
        _;
        emit PaymentSucessfully(msg.sender, msg.value);
    }


    function getTotalAmountForSalaries() public view returns(uint){
        uint amount = 0;
        for(uint i = 0; i < employeeList.length; i++) {
            amount += employeeList[i].salary();
        }
        return amount;
    }


    function getTotalAmountForService() public view returns(uint){
        uint amount = 0;
        for(uint i = 0; i < serviceList.length; i++) {
            amount += serviceList[i].price;
        }
        return amount;
    }


    function CostForAnService(uint index) public view returns(uint){
        return serviceList[index].price;
    }


    function paySalaries() public payable onlyOwner paid{
        require(address(this).balance >= getTotalAmountForSalaries(), "The balance of the contract is insufficient");
        for(uint i = 0; i < employeeList.length; i++) {
            (bool success,) = address(employeeList[i].withdrawAddress()).call{value: employeeList[i].salary()}("");
            require(success, "Transfer failed.");
        }
    }

    function payAllServices() public payable onlyOwner paid{
        uint amount = getTotalAmountForService();
        require(address(this).balance >= amount, "The balance of the contract is insufficient");
        (bool success,) = address(serviceContractInstance).call{value: amount}("");
        require(success, "Transfer failed.");
    }

    function payService(uint index) public payable onlyOwner paid{
        uint amount = CostForAnService(index);
        require(address(this).balance >= amount, "The balance of the contract is insufficient");
        (bool success,) = address(serviceContractInstance).call{value: amount}("");
        require(success, "Transfer failed.");
    }

    // function addNewTenant(string memory _name, address _tenantAddress, uint _rentalCost, string memory _residence) public onlyOwner {
    //     tenantList.push(new Tenant(_name, _tenantAddress, _rentalCost, _residence, address(this)));
    // }

    function addNewEmployee(string memory _name, address _employeeAddress, string memory _profession, uint _salary) public onlyOwner {
        employeeList.push(new Employee(_name, _employeeAddress, _profession, _salary));
    }

    function addNewService(string memory _name, uint _price) public onlyOwner {
        serviceList.push(ServiceStruct(_name, _price));
    }
    
    function showContractAddress() public view returns(address) {
        return address(this);
    }

    function getContractBalance() public view returns(uint256 balance, uint256 serviceBalance) {
        return (address(this).balance, address(serviceContractInstance).balance);
    }
}