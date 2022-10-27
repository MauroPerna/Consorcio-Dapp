// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./BaseUser.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tenant is BaseUser, Ownable {

    address private consorcioAddress;

    event ExpensesPaid(uint pricePaid);
    event EtherReceived(uint amount);

    mapping(address => TenantStruct) tenantMapping;

    struct TenantStruct {
        string name;
        address tenantAddress;
        uint rentalCost;
        string residence;
        address consorcioContractAddress;
    }

    modifier onlyPayers() {
        require(address(msg.sender) == tenantMapping[msg.sender].tenantAddress, "You aren't valid payer");
        _;
        
    }

    receive() external payable {}
    fallback() external payable {}

    constructor (address _consorcioAddress) payable BaseUser ("", 0x0000000000000000000000000000000000000000)  {
        consorcioAddress = _consorcioAddress;
    }

    function deposit() public payable onlyPayers{
        uint rentalCost = tenantMapping[msg.sender].rentalCost;
        require(msg.value >= rentalCost, "The funds sent are insufficient");
        emit EtherReceived(msg.value);
    }


    function addNewTenant(string memory _name, address _tenantAddress, uint _rentalCost, string memory _residence) public onlyOwner {
        tenantMapping[_tenantAddress] = TenantStruct(_name, _tenantAddress, _rentalCost, _residence, consorcioAddress);
    }


    function getTenant(address _tenantAddress) public view returns(string memory name, address tenantAddress, uint rentalCost, string memory residence, address consorcioContractAddress){
        return (
            tenantMapping[_tenantAddress].name,
            tenantMapping[_tenantAddress].tenantAddress,
            tenantMapping[_tenantAddress].rentalCost,
            tenantMapping[_tenantAddress].residence,
            tenantMapping[_tenantAddress].consorcioContractAddress
        );
    }

    function setRentalCost(address _tenantAddress, uint _newRentalCost) public onlyOwner {
        tenantMapping[_tenantAddress].rentalCost = _newRentalCost;
    }

    function payExpenses() public payable onlyPayers{
        uint rentalCost = tenantMapping[msg.sender].rentalCost;
        require(msg.value >= rentalCost, "The funds sent are insufficient");
        (bool sent,) = consorcioAddress.call {
            value: msg.value
        }("");
        require(sent == true, "Fallo la transferencia");
        emit ExpensesPaid(rentalCost);
    }

    function payExpensesForOwner() public payable onlyOwner{
        // TODO: llamar a las funciones getTotalAmountForService() y
        // getTotalAmountForSalaries() del contrato Consorcio.sol 
        // y determinar si el balance del contrato es superior a dicha suma.
        require(address(this).balance > 0, "The funds sent are insufficient");
        (bool sent,) = consorcioAddress.call {
            value: address(this).balance
        }("");
        require(sent == true, "Fallo la transferencia");
        emit ExpensesPaid(address(this).balance);
    }

}   