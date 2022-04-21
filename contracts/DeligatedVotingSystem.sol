// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DeligatedVotingSystem{
    // state variable
    struct Voter{
        uint32 weight;
        uint32 votingIndex;
        bool voted;
        address deligatedTo;
    }
    struct Proposal{
        bytes32 proposalName;
        uint voteCount;
    }

    address public admin; 

    Proposal[] public proposals;
    mapping(address => Voter) public voters;

    // Modifiers
    modifier onlyAdmin{
        require(msg.sender == admin, "Only admin call this feature.");
        _;
    }
    modifier allowed{
        require(voters[msg.sender].weight != 0, "User not eligible for voting.");
        _;
    }
    modifier voted(uint _address){
        require(!voters[_address].voted, "User alredy give his vote");
        _;
    }

    // Events

    // Functions
    constructor(bytes32[] memory _proposals){
        admin = msg.sender;
        for(uint i; i < _proposals.length; i++){
            proposals.push(Proposal({
                proposalName: _proposals[i],
                voteCount: 0
            }));
        }
    }

    function giveVotingPower(address _user) external onlyAdmin voted(_user){
        Voter storage user = voters[_user];
        user.weight = 1;
    }
    function delegatedTo(address _to) external pure allowed voted(msg.sender) voted(_to){
        Voter storage sender = voters[msg.sender];
        sender.deligatedTo = _to;
        sender.voted = true;
        Voter storage receiver = voters[_to];
        receiver.weight += sender.weight;  
    }
    function vote(uint _proposalId) external pure allowed voted(msg.sender) {
        Voter storage sender = voters[msg.sender];
        sender.votingIndex = _proposalId;
        sender.voted = true;
        proposals[_proposalId].voteCount += sender.weight; 
    }
    function _winner() internal returns(uint winningId){
        uint count;
        for(uint i; i<proposals.length; i++){
            uint _proposalCount = proposals[i].voteCount;
            if(count > _proposalCount){
                count = _proposalCount[i];
                winningId = i;
            }
        }
    }
    function declarewinner() external returns(bytes32 winningProposal) {
        winningProposal = proposals[_winner()].proposalName;
    }
}

// admin gives write user to vote
// Each user can give single vote
// Each user can deligate his vote another only when he is not voted
// Through error if delegated user is already voted
