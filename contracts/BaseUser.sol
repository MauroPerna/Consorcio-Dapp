// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BaseUser {

    string private name;
    address public withdrawAddress;

    event WithdrawalSuccessful(uint addressBalance);
    event EtherReceived(uint amount, address tenantAddress, uint balance);

    receive() external virtual payable {
        emit EtherReceived(msg.value, address(this), address(this).balance);
    }

    fallback() external virtual  payable {
        emit EtherReceived(msg.value, address(this), address(this).balance);
    }

    constructor(string memory newName, address newAddress) {
        name = newName;
        withdrawAddress = newAddress;
    }

    // function withdrawal(uint amount) public virtual {
    //     require(address(this).balance >= amount, "The balance of contract is insufficient");
    //     (bool success,) = withdrawAddress.call{value: amount}("");
    //     require(success == true, "Fallo la transferencia");
    //     emit WithdrawalSuccessful(address(this).balance);
    // }


    function getAddress() public view returns (address) {
        return address(this);
    }
}