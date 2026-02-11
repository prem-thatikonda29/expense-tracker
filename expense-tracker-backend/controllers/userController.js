import User from "../models/User.js";

export const getUserProfile = async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("-password");
    res.json(user);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};

export const updateMonthlyBudget = async (req, res) => {
  try {
    const { monthlyBudget } = req.body;

    const user = await User.findByIdAndUpdate(
      req.userId,
      { monthlyBudget },
      { new: true },
    ).select("-password");

    res.json(user);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};

export const updateCategoryBudgets = async (req, res) => {
  try {
    const { categoryBudgets } = req.body;

    const user = await User.findById(req.userId);
    user.categoryBudgets = { ...user.categoryBudgets, ...categoryBudgets };
    await user.save();

    const userResponse = await User.findById(req.userId).select("-password");
    res.json(userResponse);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
};
