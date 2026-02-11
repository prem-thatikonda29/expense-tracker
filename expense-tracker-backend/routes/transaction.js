import express from "express";
import { check } from "express-validator";
import auth from "../middleware/auth.js";
import {
  createTransaction,
  getTransactions,
  updateTransaction,
  deleteTransaction,
  getSummary,
  getCategorySpending,
} from "../controllers/transactionController.js";

const router = express.Router();

// @route   POST /api/transactions
// @desc    Create a new transaction
// @access  Private
router.post(
  "/",
  [
    auth,
    [
      check("type", "Type is required").isIn(["income", "expense"]),
      check("amount", "Amount must be a positive number").isFloat({
        min: 0.01,
      }),
      check("category", "Category is required").not().isEmpty(),
      check("date", "Date is required").not().isEmpty(),
    ],
  ],
  createTransaction,
);

// @route   GET /api/transactions
// @desc    Get all transactions (optional filters)
// @access  Private
router.get("/", auth, getTransactions);

// @route   PUT /api/transactions/:id
// @desc    Update a transaction
// @access  Private
router.put("/:id", auth, updateTransaction);

// @route   DELETE /api/transactions/:id
// @desc    Delete a transaction
// @access  Private
router.delete("/:id", auth, deleteTransaction);

// @route   GET /api/transactions/summary
// @desc    Get earnings, expenditures, savings for a period
// @access  Private
router.get("/summary", auth, getSummary);

// @route   GET /api/transactions/category-spending
// @desc    Get category-wise spending request for charts
// @access  Private
router.get("/category-spending", auth, getCategorySpending);

export default router;
