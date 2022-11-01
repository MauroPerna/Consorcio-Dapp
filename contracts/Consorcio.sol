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
    Employee private employeeContractInstance;

    ServiceStruct[] private serviceList;

    receive() external payable {}
    fallback() external payable {}

    constructor(address payable _employeeAddress) {
        serviceContractInstance = new Service();
        employeeContractInstance = Employee(_employeeAddress);
    }


    modifier paid() {
        _;
        emit PaymentSucessfully(msg.sender, msg.value);
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

    function getSalaries() public view returns(uint salaries){
        return employeeContractInstance.getTotalAmountForSalaries();
    }


    function paySalaries() public payable onlyOwner paid{
        uint totalAmount = employeeContractInstance.getTotalAmountForSalaries();
        require(address(this).balance >=  totalAmount, "The balance of the contract is insufficient");
        (bool success,) = address(employeeContractInstance).call{value: totalAmount}("");
        require(success, "Transfer failed.");
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