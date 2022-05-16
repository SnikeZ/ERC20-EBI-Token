// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "./IERC20.sol";

contract ERC20 is IERC20{
    uint totalTokens;
    address owner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    string _name;
    string _symbol;

    function name() external view returns(string memory){
        return _name;
    }

    function symbol() external view returns(string memory){
        return _symbol;
    }

    function deciminals() external pure returns(uint){
        return 2;
    }
    
    function totalSupply() external view returns(uint){
        return totalTokens;
    }

    function balanceOf (address account) public view returns(uint){
        return balances[account];
    }

    function transfer(address to, uint amount) public enoughTokens(msg.sender, amount){
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer (msg.sender, to, amount);
    }

    modifier enoughTokens (address _from, uint amount){
        require(balanceOf(_from) >= amount, "Not enough tokens!");
        _;
    }

    modifier onlyOwener (){
        require(msg.sender == owner, "Not an owner!");
        _;
    }

    constructor(string memory name_, string memory symbol_, uint initialSupply_){
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender; 
        mint(initialSupply_);
    }

    function mint(uint amount) public onlyOwener{
        balances[owner] += amount;
        totalTokens += amount;
        emit Transfer (address(0), owner, amount);
    }

    function burn(address _from, uint amount) public onlyOwener enoughTokens(_from, amount){
        balances[_from] -= amount;
        totalTokens -= amount;
    }

    function allowance(address _owner, address spender) public view returns(uint){
        return allowances[_owner][spender];
    }

    function approve(address spender, uint amount) external{
        allowances[owner][spender] += amount;
        emit Approve (msg.sender, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) external enoughTokens(sender, amount){
        require (allowances[sender][recipient] >= amount, "Check allowance!");
        allowances[sender][recipient] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

}

contract EBIToken is ERC20{
    constructor() ERC20("EBIToken", "EBI", 1000000){}
}