const main = async () => {
	const Ether_Wallet = await hre.ethers.getContractFactory("Ether_Wallet");
	const ether_wallet = await Ether_Wallet.deploy();
	await ether_wallet.deployed();

	const ERC20Token = await hre.ethers.getContractFactory("ERC20Token");
	const erc20token = await ERC20Token.deploy();
	await erc20token.deployed();

	console.log("Ether_Wallet Deployed to :: ", ether_wallet.address);
	console.log("ERC20Token Deployed to :: ", erc20token.address);
};

const runMain = async () => {
	try {
		await main();
		process.exit(0);
	} catch (error) {
		console.error(error);
		process.exit(1);
	}
};
runMain();
