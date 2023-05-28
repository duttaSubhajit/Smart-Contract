// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AssignmentContract {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public stakedBalances;
    mapping(address => uint256) public stakedTimestamps;
    uint256 public totalSupply;
    mapping(address => uint256) public rewards;

    constructor() {
        owner = msg.sender;
        totalSupply = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    function deposit() public payable {
        require(msg.value > 0, "Amount should be greater than zero");
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Amount should be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
        payable(msg.sender).transfer(amount);
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Amount should be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        stakedBalances[msg.sender] += amount;
        stakedTimestamps[msg.sender] = block.timestamp;
    }

    function unstake(uint256 amount) public {
        require(amount > 0, "Amount should be greater than zero");
        require(stakedBalances[msg.sender] >= amount, "Insufficient staked balance");

        balances[msg.sender] += amount;
        stakedBalances[msg.sender] -= amount;
        rewards[msg.sender] += calculateReward(msg.sender);
        stakedTimestamps[msg.sender] = 0;
    }

    function calculateReward(address user) internal view returns (uint256) {
        uint256 stakedTime = block.timestamp - stakedTimestamps[user];
        uint256 rewardMultiplier = stakedTime / 1 days; // Adjust the reward calculation as needed
        return stakedBalances[user] * rewardMultiplier;
    }

    function distributeRewards(address user) public onlyOwner {
        require(totalSupply > 0, "No tokens have been deposited");
        
        for (uint256 i = 0; i < totalSupply; i++) {
            rewards[user] += calculateReward(user);
        }
    }

    function claimRewards() public {
        require(rewards[msg.sender] > 0, "No rewards to claim");
        
        uint256 rewardAmount = rewards[msg.sender];
        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(rewardAmount);
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getStakedBalance() public view returns (uint256) {
        return stakedBalances[msg.sender];
    }

    function getStakedTimestamp() public view returns (uint256) {
        return stakedTimestamps[msg.sender];
    }

    function getRewardBalance() public view returns (uint256) {
        return rewards[msg.sender];
    }
}

