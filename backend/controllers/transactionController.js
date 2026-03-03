import { validationResult } from "express-validator";
import Transaction from "../models/Transaction.js";

export const createTransaction = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { type, amount, category, date, note } = req.body;

  try {
    const newTransaction = new Transaction({
      userId: req.userId,
      type,
      amount,
      category,
      date,
      note,
    });

    const transaction = await newTransaction.save();
    res.json(transaction);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};

export const getTransactions = async (req, res) => {
  try {
    const transactions = await Transaction.find({ userId: req.userId }).sort({
      date: -1,
    });
    res.json(transactions);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};

export const updateTransaction = async (req, res) => {
  const { type, amount, category, date, note } = req.body;

  try {
    let transaction = await Transaction.findById(req.params.id);

    if (!transaction)
      return res.status(404).json({ message: "Transaction not found" });

    if (transaction.userId.toString() !== req.userId) {
      return res.status(401).json({ message: "Not authorized" });
    }

    transaction = await Transaction.findByIdAndUpdate(
      req.params.id,
      { $set: { type, amount, category, date, note } },
      { new: true },
    );

    res.json(transaction);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};

export const deleteTransaction = async (req, res) => {
  try {
    let transaction = await Transaction.findById(req.params.id);

    if (!transaction)
      return res.status(404).json({ message: "Transaction not found" });

    if (transaction.userId.toString() !== req.userId) {
      return res.status(401).json({ message: "Not authorized" });
    }

    await Transaction.findByIdAndDelete(req.params.id);

    res.json({ message: "Transaction removed" });
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};

export const getSummary = async (req, res) => {
  const { period } = req.query; // 'week' or 'month'

  try {
    const now = new Date();
    let startDate;

    if (period === "week") {
      startDate = new Date(
        now.getFullYear(),
        now.getMonth(),
        now.getDate() - 7,
      );
    } else {
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
    }

    const transactions = await Transaction.find({
      userId: req.userId,
      date: { $gte: startDate },
    });

    const earnings = transactions
      .filter((t) => t.type === "income")
      .reduce((sum, t) => sum + t.amount, 0);

    const expenditures = transactions
      .filter((t) => t.type === "expense")
      .reduce((sum, t) => sum + t.amount, 0);

    res.json({
      earnings,
      expenditures,
      savings: earnings - expenditures,
      period,
    });
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};

export const getCategorySpending = async (req, res) => {
  try {
    const now = new Date();
    const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    const transactions = await Transaction.find({
      userId: req.userId,
      type: "expense",
      date: { $gte: startOfMonth },
    });

    const categoryTotals = {};
    const categories = [
      "Food",
      "Transport",
      "Shopping",
      "Entertainment",
      "Bills",
      "Education",
      "Health",
      "Other",
    ];
    categories.forEach((cat) => (categoryTotals[cat] = 0));

    transactions.forEach((t) => {
      if (categoryTotals[t.category] !== undefined) {
        categoryTotals[t.category] += t.amount;
      }
    });

    res.json(categoryTotals);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};
