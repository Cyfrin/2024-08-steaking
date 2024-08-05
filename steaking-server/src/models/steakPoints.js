import mongoose from "mongoose";

const steakPointsSchema = new mongoose.Schema({
    walletAddress: {
        type: String,
        required: true,
    },
    points: {
        type: Number,
        required: true,
    },
});

const modelName = "steakPoints";

const steakPointsModel = mongoose.model(modelName, steakPointsSchema);

export default steakPointsModel;
