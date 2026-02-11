import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true,
  },
  password: {
    type: String,
    required: true,
  },
  monthlyBudget: {
    type: Number,
    default: 0,
  },
  categoryBudgets: {
    Food: { type: Number, default: 0 },
    Transport: { type: Number, default: 0 },
    Shopping: { type: Number, default: 0 },
    Entertainment: { type: Number, default: 0 },
    Bills: { type: Number, default: 0 },
    Education: { type: Number, default: 0 },
    Health: { type: Number, default: 0 },
    Other: { type: Number, default: 0 },
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

export default mongoose.model("User", userSchema);
