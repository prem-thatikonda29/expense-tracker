import mongoose from "mongoose";

const transactionSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  type: {
    type: String,
    required: true,
    enum: ["income", "expense"],
  },
  amount: {
    type: Number,
    required: true,
    min: 0.01,
  },
  category: {
    type: String,
    required: true,
    enum: [
      "Food",
      "Transport",
      "Shopping",
      "Entertainment",
      "Bills",
      "Education",
      "Health",
      "Other",
    ],
  },
  date: {
    type: Date,
    required: true,
    default: Date.now,
  },
  note: {
    type: String,
    trim: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Index for faster queries usually involving user and date
transactionSchema.index({ userId: 1, date: -1 });

export default mongoose.model("Transaction", transactionSchema);
