// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IDAOMTC {
   
   function mint(address recipient) external returns(bool);
   function burn(address recipient) external returns(bool);
   function totalSupply() external view returns (uint256);
   function balanceOf(address account) external view returns (uint256);
}
