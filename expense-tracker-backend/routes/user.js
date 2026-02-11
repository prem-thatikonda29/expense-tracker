import express from "express";
import auth from "../middleware/auth.js";
import {
  getUserProfile,
  updateMonthlyBudget,
  updateCategoryBudgets,
} from "../controllers/userController.js";

const router = express.Router();

// @route   GET /api/user/profile
// @desc    Get user profile (including budgets)
// @access  Private
router.get("/profile", auth, getUserProfile);

// @route   PUT /api/user/budget
// @desc    Update overall monthly budget
// @access  Private
router.put("/budget", auth, updateMonthlyBudget);

// @route   PUT /api/user/category-budgets
// @desc    Update category-wise budgets
// @access  Private
router.put("/category-budgets", auth, updateCategoryBudgets);

export default router;
