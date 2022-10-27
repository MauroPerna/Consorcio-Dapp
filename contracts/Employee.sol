// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./BaseUser.sol";


contract Employee is BaseUser {

    string private profession;
    uint public salary;

    constructor(
        string memory newName,
        address newAddress,
        string memory newProfession, 
        uint _salary
        ) BaseUser(newName, newAddress) {
        profession = newProfession;
        salary = _salary;
    }

}