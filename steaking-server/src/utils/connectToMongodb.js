import mongoose from "mongoose";

async function connectToMongodb() {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log("Successfully connected to Mongodb");
    } catch (error) {
        console.error("Failed to connect to Mongodb");
        console.error(error.message);
    }
}

export default connectToMongodb;
