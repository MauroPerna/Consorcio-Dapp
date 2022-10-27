// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Service {

    receive() external payable {}
    fallback() external payable {}


    function getAddress() public view returns (address) {
        return address(this);
    }

    function getBalances() external view returns (uint256) {
        return (address(this).balance);
    }
}