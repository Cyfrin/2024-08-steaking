function getConfig() {
    let rpcUrl, steakingAddress;

    if (process.env.ENVIRONMENT === "dev") {
        rpcUrl = process.env.LOCALHOST_RPC_URL;
        steakingAddress = process.env.STEAKING_CONTRACT_ADDRESS_LOCALHOST;
    } else if (process.env.ENVIRONMENT == "production") {
        rpcUrl = process.env.MAINNET_RPC_URL;
        steakingAddress = process.env.STEAKING_CONTRACT_ADDRESS_MAINNET;
    } else {
        console.error("Invalid environment");
        process.exit(1);
    }

    return {
        rpcUrl,
        steakingAddress,
    };
}

export default getConfig;
