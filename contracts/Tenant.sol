// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./BaseUser.sol";
import "./Consorcio.sol";
import "./Employee.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tenant is BaseUser, Ownable {

    Consorcio private consorcioContractInstance;
    Employee private employeeContractInstance;
    uint private qTenant = 0;

    event ExpensesPaid(uint pricePaid);
    event EtherReceived(uint amount);

    mapping(address => TenantStruct) tenantMapping;

    struct TenantStruct {
        string name;
        address tenantAddress;
        uint rentalCost;
        string residence;
        Consorcio consorcioContractAddress;
    }

    modifier onlyPayers() {
        require(address(msg.sender) == tenantMapping[msg.sender].tenantAddress, "You aren't valid payer");
        _;
        
    }

    receive() external override payable {}
    fallback() external override payable {}

    constructor (address payable _consorcioContractInstance, address payable _employeeContractInstance) payable BaseUser ("", 0x0000000000000000000000000000000000000000)  {
        consorcioContractInstance = Consorcio(_consorcioContractInstance);
        employeeContractInstance = Employee(_employeeContractInstance);
    }

    function deposit() public payable onlyPayers{
        uint rentalCost = tenantMapping[msg.sender].rentalCost;
        require(msg.value >= rentalCost, "The funds sent are insufficient");
        emit EtherReceived(msg.value);
    }


    function getTotalCostForPayers() public view returns(uint totalCostForPayers, uint totalCost) {
        uint totalAmount = consorcioContractInstance.getTotalAmountForService() + employeeContractInstance.getTotalAmountForSalaries();
        return (totalAmount / qTenant, totalAmount);
    }


    function addNewTenant(string memory _name, address _tenantAddress, uint _rentalCost, string memory _residence) public onlyOwner {
        tenantMapping[_tenantAddress] = TenantStruct(_name, _tenantAddress, _rentalCost, _residence, consorcioContractInstance);
        qTenant++;
    }


    function getTenant(address _tenantAddress) public view returns(string memory name, address tenantAddress, uint rentalCost, string memory residence, address consorcioContractAddress){
        return (
            tenantMapping[_tenantAddress].name,
            tenantMapping[_tenantAddress].tenantAddress,
            tenantMapping[_tenantAddress].rentalCost,
            tenantMapping[_tenantAddress].residence,
            address(tenantMapping[_tenantAddress].consorcioContractAddress)
        );
    }

    function setRentalCost(address _tenantAddress, uint _newRentalCost) public onlyOwner {
        tenantMapping[_tenantAddress].rentalCost = _newRentalCost;
    }

    function payExpenses() public payable onlyPayers{
        (uint rentalCost,) = getTotalCostForPayers();
        require(msg.value >= rentalCost, "The funds sent are insufficient");
        (bool sent,) = address(consorcioContractInstance).call {
            value: msg.value
        }("");
        require(sent == true, "Fallo la transferencia");
        emit ExpensesPaid(rentalCost);
    }

    function payExpensesOwner() public payable onlyOwner{
        (, uint totalCost) = getTotalCostForPayers();
        require(address(this).balance > totalCost, "The funds sent are insufficient");
        (bool sent,) = address(consorcioContractInstance).call {
            value: totalCost
        }("");
        require(sent == true, "Fallo la transferencia");
        emit ExpensesPaid(totalCost);
    }

}   