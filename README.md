# Collections of SmartContracts

Writing a No. of Smart Contract to Master Solidity best practices.

## Lessons To be Learned

Solidity Patterns, Reduction of Gas Fee, Some Solidity Hacks, More Optimized Code Structure, Security ready SmartContracts

## Deployment

Deployment Tools : Hardhat, Rinkeby Testnet, Alchemy API, Metamask, Tested on Remix

## Contracts

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
