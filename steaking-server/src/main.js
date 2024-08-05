import dotenv from "dotenv";
import { ethers } from "ethers";

import connectToMongodb from "./utils/connectToMongodb.js";
import getConfig from "./utils/getConfig.js";
import steakingAbi from "./utils/steakingAbi.js";
import steakPointsModel from "./models/steakPoints.js";
import { STAKED, PRECISION } from "./utils/constants.js";

dotenv.config();

async function main() {
    await connectToMongodb();
    const { rpcUrl, steakingAddress } = getConfig();

    const provider = new ethers.JsonRpcProvider(rpcUrl);
    const steaking = new ethers.Contract(steakingAddress, steakingAbi, provider);

    steaking.on(STAKED, async (_, amount, onBehalfOf) => {
        let steakPoints;

        steakPoints = await steakPointsModel.findOne({ walletAddress: onBehalfOf });

        if (!steakPoints) {
            steakPoints = new steakPointsModel({
                walletAddress: onBehalfOf,
                points: +ethers.formatEther(amount) * PRECISION,
            });
        } else {
            steakPoints.points += +ethers.formatEther(amount) * PRECISION;
        }

        await steakPoints.save();
    });
}

main().catch((error) => {
    console.log(error.message);
    process.exit(1);
});
