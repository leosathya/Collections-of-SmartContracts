# Collections of SmartContracts

Writing a No. of Smart Contract to Master Solidity best practices.

## Lessons To be Learned

Solidity Patterns, Reduction of Gas Fee, Some Solidity Hacks, More Optimized Code Structure, Security ready SmartContracts

## Deployment

Deployment Tools : Hardhat, Rinkeby Testnet, Alchemy API, Metamask, Tested on Remix

## Contracts

### 6. Uni-Directional Payment Channel

Mainly use to get rid of Multiple transaction mining fees :

- Sender create a contract where Ethers are locked
- then sender create a Hash signature that requires contract address to prevnt replay attack and amount of ether to be sent to receiver
- then sender send this signature to receiver off-chain
- then receiver verify this signture on contract and claim his ether
- sender can cancel contract after time period is over

### 5. Delegated Voting System

A Voting system

- Admin give authority to other addresses to give their votes on some Purposals
- Every address can give only one vote
- Any address can give votes on behalf of other addresses
- Addresses can delegate their votes, only when they and their deligated address are not alredy voted.
- After Time period is over, Admin can annaounce Winning Purposal.

### 4. Multi Signature Wallet

This Wallet has multiple Owners and for complete one transaction it will require a no. of approvals form other owners :

- One owner can execute transaction only when there is necessary no. of approvals from other owners.
- Owners can approve transaction and can unapprove previously approved transaction only before execution of that contract.
- if necessary amount of approvals not given to transaction, then it will not excuted.

### 3. CrowdFunding Using ERC-20 Token

CrowdFunding Contract where a Organization list his Goal and Amount to be Raised within a certain time period:

- Anyone can list his Target-Amount.
- Lister only able to withdraw Amount when Target amount reached.
- If target amount not archived within time period, Pledger can request for refund.
- Anyone can Pledge amount to any no. of listed Organization.
- Pleadger can Unpleadge his amount before end of a Campaign.

### 2. ERC-20 Token

ERC-20 Token Contract with some ERC-20 Standards :

- Only Owner can Mint new Tokens.
- Anyone can Burn Their Tokens.
- Anyone can Transfer Their Tokens.
- Owner will allow some Addresses to use his token on his behalf.
- Anyone can see TotalSupply & Tokens hold by other Addresses.

### 1. Ether_Wallet

Anyone can send Ether to Contract, Only Owner can withdraw Ether :

- Anyone can send Ether
- Only Owner can see Wallet Balance, Can withdraw all Or Specific Amount.
