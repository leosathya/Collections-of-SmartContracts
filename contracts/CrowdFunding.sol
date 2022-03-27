// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./ERC20Token.sol";

contract CrowdFunding{
    struct Campaign{
        address creator;
        uint targetAmount;
        uint pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }

    IERC20 public immutable token;
    uint public campaignsCount;
    mapping(uint => Campaign) public campaigns;
    mapping(uint => mapping(address => uint)) pledgeAmount;

    event Launch(uint id, address indexed creator, uint goal, uint32 startAt, uint32 endAt);
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed sender, uint amount);
    event Unpledge(uint indexed id, address indexed sender, uint amount);
    event Claim(uint id);
    event Refund(uint indexed id, address indexed sender, uint amount);

    constructor(address _token){
        token = IERC20(_token);
    }
    
    function launch(uint _targetAmount, uint32 _startAt, uint32 _endAt) external {
        require(_startAt >= block.timestamp, "Invalide Time Period");
        require(_endAt >= _startAt, "Invalide Time Period");
        require(_endAt <= block.timestamp + 3 days, "Campaign Ended.");

        campaignsCount++;
        campaigns[campaignsCount] = Campaign({
            creator: msg.sender,
            targetAmount: _targetAmount,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });
        emit Launch(campaignsCount, msg.sender, _targetAmount, _startAt, _endAt);
    }
    function cancel(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "Only Creator call this feature");
        require(block.timestamp < campaign.startAt, "Cannot delete it, Already live");
        delete campaigns[_id];

        emit Cancel(_id);
    }
    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.startAt, "Campaign Not Started Yet.");
        require(block.timestamp < campaign.endAt, "Campaign Already Ended");

        campaign.pledged += _amount;
        pledgeAmount[_id][msg.sender] += _amount;
        token.transfer(address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }
    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.startAt, "Campaign Not Started Yet.");
        require(block.timestamp < campaign.endAt, "Campaign Already Ended");

        pledgeAmount[_id][msg.sender] -= _amount;
        campaign.pledged -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    }
    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "Only Creator can Call this.");
        require(block.timestamp > campaign.endAt, "Campaign Not ended");
        require(campaign.pledged >= campaign.targetAmount, "Target amount not archived.");
        require(!campaign.claimed, "Claimed.");

        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged);

        emit Claim(_id);
    }
    function refund(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "Campaign Not ended.");
        require(campaign.pledged < campaign.targetAmount, "Target amount not archived.");

        uint balance = pledgeAmount[_id][msg.sender];
        pledgeAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, balance);

        emit Refund(_id, msg.sender, balance);
    }
}