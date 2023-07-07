// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./DAOC.sol";

contract ODAOMTC is DAOMTC{
        constructor(string memory name_, string memory symbol_, string memory baseURI_) DAOMTC( name_, symbol_, baseURI_) {

    }
}

// A contract that represents a DAO based on ODAOMTs
contract ODAOC is DAOC{

    constructor (address member1, address member2, string  memory baseURI_){
        ODAOMTC ODAOMTCI = new ODAOMTC("Orchestrator-DAOMT","ODAOMT", baseURI_); 
        address _DAOMTCAddr = payable(address(ODAOMTCI)); 
        setDAOMTCAddr(_DAOMTCAddr);

        IDAOMTC(_DAOMTCAddr).mint(owner());
        IDAOMTC(_DAOMTCAddr).mint(member1);
        IDAOMTC(_DAOMTCAddr).mint(member2);
        
    }

    function ODAOMTCAddr() public view returns(address){
        return getDAOMTCAddr();
    }

   
}