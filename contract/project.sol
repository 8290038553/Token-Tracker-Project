// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenTracker {
    string public name = "FitnessGoalToken";
    string public symbol = "FGT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => uint256) public fitnessGoals;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event GoalAchieved(address indexed user, uint256 goal, uint256 tokensAwarded);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Transfer to the zero address");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(balanceOf[sender] >= amount, "Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Allowance exceeded");

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        allowance[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Fitness goal functions
    function setFitnessGoal(uint256 goal) public {
        fitnessGoals[msg.sender] = goal;
    }

    function trackGoalAchievement(uint256 achieved) public {
        require(fitnessGoals[msg.sender] > 0, "No fitness goal set");
        require(achieved >= fitnessGoals[msg.sender], "Goal not achieved");

        uint256 rewardTokens = achieved / 100; // Example: 1 token per 100 units of goal
        balanceOf[msg.sender] += rewardTokens;
        totalSupply += rewardTokens;

        emit GoalAchieved(msg.sender, fitnessGoals[msg.sender], rewardTokens);
    }

    // Utility functions
    function getBalance() public view returns (uint256) {
        return balanceOf[msg.sender];
    }

    function getFitnessGoal() public view returns (uint256) {
        return fitnessGoals[msg.sender];
    }
}

