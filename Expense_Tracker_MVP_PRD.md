# Expense Tracker MVP — Simplified College Project PRD

## 1. Problem Statement

College students struggle to track their daily expenses and manage their monthly budgets. Most finance apps are too complex or require bank linking. This project builds a simple, user-friendly mobile expense tracker using Flutter for the frontend and Node.js with MongoDB for the backend that helps students manually log their spending, categorize expenses, and stay within budget.

---

## 2. Target Users

- College students managing allowances and part-time income
- Anyone wanting a simple expense tracker without bank account linking

---

## 3. MVP Features (Core Only)

### 3.1 Must-Have Features

| # | Feature | Description |
|---|---------|-------------|
| F1 | **Add Transaction** | Log income or expenses with amount, category, date, and optional note. Simple form with validation. |
| F2 | **Expense Categories** | 8 pre-defined categories (Food, Transport, Shopping, Entertainment, Bills, Education, Health, Other). No custom categories in MVP. |
| F3 | **Transaction History** | Scrollable list of all transactions. Ability to edit and delete transactions. |
| F4 | **Enhanced Dashboard** | Home screen with time filter (Week/Month). Shows earnings, savings, and expenditures for selected period. Includes budget vs expenditure charts with toggle between overall and category-wise view. |
| F5 | **Monthly & Category Budgets** | Set both overall monthly spending limit AND individual category limits. Progress bars with color coding (green < 80%, yellow 80-100%, red > 100%). |
| F6 | **Budget Charts** | Visual charts showing budget vs actual spending. Toggle between overall budget view and category-wise breakdown. |
| F7 | **Basic Authentication** | Email/password sign up and login using JWT tokens. |
| F8 | **Data Persistence** | All data stored in MongoDB so it persists across app restarts. |

### 3.2 Explicitly Excluded (Future Enhancements)

- ❌ AI Financial Copilot (too complex)
- ❌ Receipt Scanner (requires OCR integration)
- ❌ Savings Goals tracking system
- ❌ PIN/Biometric Lock
- ❌ Export functionality
- ❌ Dark mode
- ❌ Offline support (requires sync logic)
- ❌ Recurring transactions

---

## 4. Simplified Screens & Navigation

### 4.1 Navigation Structure

**3-tab bottom navigation** (much simpler than original 5-tab design)

```
┌────────────────────────────────────────────┐
│              [Screen Content]               │
│                                             │
│                                             │
│                                             │
├────────────┬──────────────┬─────────────────┤
│    Home    │   History    │    Settings    │
│     🏠     │      📋      │       ⚙️       │
└────────────┴──────────────┴─────────────────┘
```

| Tab | Purpose |
|-----|---------|
| Home | Dashboard + floating (+) button to add transaction |
| History | List of all transactions with delete option |
| Settings | Budget setting, logout, account info |

### 4.2 Screen Breakdown

---

#### Screen 1 — Auth (Login / Sign Up)

**Purpose:** User registration and login

- **Sign Up:** Email, password, confirm password. "Sign Up" button.
- **Login:** Email, password. "Log In" button.
- Toggle between Login and Sign Up using tabs at top.
- No password reset in MVP (keep it simple).

---

#### Screen 2 — Dashboard (Home)

**Purpose:** Financial overview with time-based filtering and visual insights

**Top Section - Time Filter:**
- Dropdown selector: "This Week" / "This Month" (default: This Month)

**Section 1 - Financial Summary Cards (3 cards in a row)**
1. **Earnings Card**
   - Icon: 💰
   - Label: "Earnings"
   - Amount: ₹X,XXX
   - Subtitle: "for [selected period]"

2. **Expenditures Card**
   - Icon: 💸
   - Label: "Expenditures"
   - Amount: ₹Y,YYY
   - Subtitle: "for [selected period]"

3. **Savings Card**
   - Icon: 🏦
   - Label: "Savings"
   - Amount: ₹Z,ZZZ (Earnings - Expenditures)
   - Subtitle: "for [selected period]"
   - Color: Green if positive, Red if negative

**Section 2 - Budget vs Expenditure Charts**

**Chart Toggle Buttons:**
- "Overall Budget" (default selected)
- "Category-wise Budgets"

**A) Overall Budget View:**
- **Bar Chart:** Shows total budget vs actual spending
  - Budget bar (light color)
  - Actual spending bar (color-coded: green/yellow/red)
- **Summary below chart:**
  - Budget: ₹X,XXX
  - Spent: ₹Y,YYY
  - Remaining: ₹Z,ZZZ
  - Progress: XX% (with color indicator)

**B) Category-wise Budget View:**
- **Horizontal Bar Chart:** One bar per category showing budget vs spending
  - Each category has two bars side-by-side:
    - Budget amount (light gray)
    - Actual spending (color-coded)
  - Categories listed vertically (Food, Transport, Shopping, etc.)
- **Summary cards below:** Top 3 categories by spending

**Section 3 - Quick Actions**
- Floating Action Button (+) in bottom-right
  - Opens "Add Transaction" screen

---

#### Screen 3 — Add/Edit Transaction

**Purpose:** Log a new transaction or edit an existing one

**Screen Title:**
- "Add Transaction" (when creating new)
- "Edit Transaction" (when editing existing)

**Form Fields:**
- **Type Toggle** (Income / Expense)
  - Default: Expense
  - Switch button at top
- **Amount** (required, number input)
- **Category** (required, dropdown with 8 categories)
- **Date** (default: today, date picker if user wants to change)
- **Note** (optional, text input)
- **Save** button (labeled "Add" for new, "Update" for edit)
- **Cancel** button (returns to previous screen)

**Validation:**
- Amount must be > 0
- Category must be selected
- Date cannot be in future

**Behavior:**
- When adding: After saving → return to Dashboard with success message
- When editing: Pre-fill all fields with existing data → After updating → return to previous screen with success message

---

#### Screen 4 — Transaction History

**Purpose:** View and manage all past transactions

**Layout:**
- List of transaction cards, newest first
- Each card shows:
  - Transaction type indicator (Income: green ↑ / Expense: red ↓)
  - Category icon
  - Category name
  - Amount (₹XXX)
  - Date (DD MMM YYYY)
  - Note (if any)
  - Action buttons: Edit icon (✏️) and Delete icon (🗑️)

**Actions:**
- Tap edit icon → navigate to "Edit Transaction" screen with pre-filled data
- Tap delete icon → confirmation dialog → delete from database
- Optional: Filter by month using dropdown at top (current month, last month, all time)
- Optional: Filter by type (All / Income / Expense)

---

#### Screen 5 — Settings

**Purpose:** Account and budget management

**Sections:**

1. **Account Info** (non-editable card)
   - Email address
   - Member since date

2. **Budget Settings**
   
   **Overall Monthly Budget:**
   - Input field: "Monthly Budget Limit"
   - Default: ₹10,000
   - Save button
   
   **Category-wise Budgets:**
   - List of all 8 categories
   - Each category has:
     - Category icon and name
     - Input field for budget amount
     - Default: ₹0 (no limit)
   - "Save All" button at bottom
   - Note: "Leave at ₹0 for no category limit"

3. **About**
   - App name, version
   - "Made by [Your Group Names]"

4. **Logout Button**
   - Red button at bottom
   - Logs out and returns to login screen

---

## 5. Technology Stack (Simplified)

### 5.1 Frontend (Flutter)
- **State Management:** Provider (simpler than Bloc/Riverpod)
- **UI:** Material Design, built-in widgets only
- **Navigation:** Basic Navigator with named routes
- **HTTP Client:** http or dio package for API calls

### 5.2 Backend (Node.js + Express)
- **Framework:** Express.js
- **Authentication:** JWT (JSON Web Tokens) with bcrypt for password hashing
- **Database:** MongoDB with Mongoose ODM
- **Validation:** express-validator

### 5.3 Flutter Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^latest              # State management
  http: ^latest                  # API calls
  intl: ^latest                  # Date formatting
  shared_preferences: ^latest    # Store JWT token locally
  fl_chart: ^latest              # Charts for budget visualization
```

### 5.4 Node.js Packages
```json
{
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^8.0.0",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.2",
    "dotenv": "^16.3.1",
    "cors": "^2.8.5",
    "express-validator": "^7.0.1"
  }
}
```

---

## 6. Database Schema (MongoDB)

### 6.1 Collections

**users**
```javascript
{
  _id: ObjectId,
  email: String (unique, required),
  password: String (hashed, required),
  monthlyBudget: Number (default: 10000),
  categoryBudgets: {
    Food: Number (default: 0),
    Transport: Number (default: 0),
    Shopping: Number (default: 0),
    Entertainment: Number (default: 0),
    Bills: Number (default: 0),
    Education: Number (default: 0),
    Health: Number (default: 0),
    Other: Number (default: 0)
  },
  createdAt: Date (default: Date.now)
}
```

**transactions**
```javascript
{
  _id: ObjectId,
  userId: ObjectId (ref: 'User', required),
  type: String (required, enum: ['income', 'expense']),
  amount: Number (required, min: 0.01),
  category: String (required, enum: ['Food', 'Transport', 'Shopping', 'Entertainment', 'Bills', 'Education', 'Health', 'Other']),
  date: Date (required),
  note: String (optional),
  createdAt: Date (default: Date.now)
}
```

### 6.2 Mongoose Models

**User Model (models/User.js):**
```javascript
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true
  },
  password: {
    type: String,
    required: true
  },
  monthlyBudget: {
    type: Number,
    default: 10000
  },
  categoryBudgets: {
    Food: { type: Number, default: 0 },
    Transport: { type: Number, default: 0 },
    Shopping: { type: Number, default: 0 },
    Entertainment: { type: Number, default: 0 },
    Bills: { type: Number, default: 0 },
    Education: { type: Number, default: 0 },
    Health: { type: Number, default: 0 },
    Other: { type: Number, default: 0 }
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('User', userSchema);
```

**Transaction Model (models/Transaction.js):**
```javascript
const mongoose = require('mongoose');

const transactionSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  type: {
    type: String,
    required: true,
    enum: ['income', 'expense']
  },
  amount: {
    type: Number,
    required: true,
    min: 0.01
  },
  category: {
    type: String,
    required: true,
    enum: ['Food', 'Transport', 'Shopping', 'Entertainment', 'Bills', 'Education', 'Health', 'Other']
  },
  date: {
    type: Date,
    required: true
  },
  note: {
    type: String
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Index for faster queries
transactionSchema.index({ userId: 1, date: -1 });

module.exports = mongoose.model('Transaction', transactionSchema);
```

**Default Categories (hardcoded in app):**
- Food
- Transport
- Shopping
- Entertainment
- Bills
- Education
- Health
- Other

---

## 7. API Endpoints & Authentication

### 7.1 Authentication Middleware

All protected routes require a valid JWT token in the Authorization header.

**middleware/auth.js:**
```javascript
const jwt = require('jsonwebtoken');

module.exports = function(req, res, next) {
  // Get token from header
  const token = req.header('Authorization')?.replace('Bearer ', '');

  if (!token) {
    return res.status(401).json({ message: 'No token, authorization denied' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch (error) {
    res.status(401).json({ message: 'Token is not valid' });
  }
};
```

### 7.2 API Routes

**Auth Routes (no middleware required):**
- `POST /api/auth/signup` - Register new user
- `POST /api/auth/login` - Login and get JWT token

**User Routes (auth middleware required):**
- `GET /api/user/profile` - Get user profile and budgets
- `PUT /api/user/budget` - Update overall monthly budget
- `PUT /api/user/category-budgets` - Update category-wise budgets

**Transaction Routes (auth middleware required):**
- `POST /api/transactions` - Create new transaction
- `GET /api/transactions` - Get all user's transactions (with optional query params: month, year, type, period)
- `GET /api/transactions/summary` - Get summary (earnings, savings, expenditures) with time filter
- `GET /api/transactions/category-spending` - Get category-wise spending for charts
- `PUT /api/transactions/:id` - Update a transaction
- `DELETE /api/transactions/:id` - Delete a transaction

### 7.3 Example API Implementations

**POST /api/auth/signup:**
```javascript
router.post('/signup', async (req, res) => {
  const { email, password } = req.body;
  
  // Hash password
  const hashedPassword = await bcrypt.hash(password, 10);
  
  // Create user
  const user = new User({ email, password: hashedPassword });
  await user.save();
  
  // Generate JWT
  const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET);
  
  res.status(201).json({ token, userId: user._id });
});
```

**POST /api/transactions (protected):**
```javascript
router.post('/', auth, async (req, res) => {
  const { type, amount, category, date, note } = req.body;
  
  const transaction = new Transaction({
    userId: req.userId, // From auth middleware
    type,
    amount,
    category,
    date,
    note
  });
  
  await transaction.save();
  res.status(201).json(transaction);
});
```

**PUT /api/transactions/:id (protected):**
```javascript
router.put('/:id', auth, async (req, res) => {
  const { type, amount, category, date, note } = req.body;
  
  const transaction = await Transaction.findOneAndUpdate(
    { _id: req.params.id, userId: req.userId },
    { type, amount, category, date, note },
    { new: true }
  );
  
  if (!transaction) {
    return res.status(404).json({ message: 'Transaction not found' });
  }
  
  res.json(transaction);
});
```

**GET /api/transactions/summary (protected):**
```javascript
router.get('/summary', auth, async (req, res) => {
  const { period } = req.query; // 'week' or 'month'
  
  // Calculate date range based on period
  const now = new Date();
  let startDate;
  
  if (period === 'week') {
    startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 7);
  } else {
    startDate = new Date(now.getFullYear(), now.getMonth(), 1);
  }
  
  const transactions = await Transaction.find({
    userId: req.userId,
    date: { $gte: startDate }
  });
  
  const earnings = transactions
    .filter(t => t.type === 'income')
    .reduce((sum, t) => sum + t.amount, 0);
    
  const expenditures = transactions
    .filter(t => t.type === 'expense')
    .reduce((sum, t) => sum + t.amount, 0);
  
  res.json({
    earnings,
    expenditures,
    savings: earnings - expenditures,
    period
  });
});
```

**GET /api/transactions/category-spending (protected):**
```javascript
router.get('/category-spending', auth, async (req, res) => {
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  
  const transactions = await Transaction.find({
    userId: req.userId,
    type: 'expense',
    date: { $gte: startOfMonth }
  });
  
  const categoryTotals = {};
  transactions.forEach(t => {
    categoryTotals[t.category] = (categoryTotals[t.category] || 0) + t.amount;
  });
  
  res.json(categoryTotals);
});
```

---

## 8. Implementation Plan (Simplified Milestones)

### Week 1 — Setup & Auth
**Backend:**
- Initialize Node.js project with Express
- Set up MongoDB connection (local or MongoDB Atlas)
- Create User and Transaction models
- Implement signup endpoint (password hashing with bcrypt)
- Implement login endpoint (JWT token generation)
- Create auth middleware

**Frontend:**
- Create Flutter project
- Build login/signup screens
- Implement API service class for HTTP requests
- Store JWT token in SharedPreferences
- Implement auth flow (login → home, logout → login)

### Week 2 — Core Functionality & Charts
**Backend:**
- Create transaction endpoints (POST, GET, PUT, DELETE)
- Implement summary endpoint with period filter (week/month)
- Implement category-spending endpoint for charts
- Add input validation using express-validator

**Frontend:**
- Build Dashboard layout with time filter dropdown
- Build earnings/savings/expenditures cards
- Implement fl_chart for budget visualizations
- Build Add Transaction screen
- Implement API calls to create transactions
- Connect Dashboard to show real data from backend

### Week 3 — History, Edit & Category Budgets
**Backend:**
- Create user profile endpoints (GET profile, UPDATE overall budget, UPDATE category budgets)
- Add filtering for transactions by month and type

**Frontend:**
- Build Transaction History screen with edit and delete
- Implement edit transaction functionality
- Build Settings screen with both overall and category budget inputs
- Implement chart toggle (overall vs category-wise)
- Build category-wise budget charts

### Week 4 — Polish & Testing
- **Both:** Add error handling and loading states
- **Frontend:** UI polish (colors, spacing, icons)
- **Backend:** Add request validation and error responses
- **Testing:** Test all flows (signup, add transaction, delete, budget)
- Fix bugs
- Prepare demo/presentation

---

## 9. What Makes This MVP Easier for Group Projects

### 9.1 Simplified Feature Set
- **No AI/ML complexity** — No LLM integration, no receipt scanning
- **No offline sync** — Always requires internet (much simpler)
- **No complex state** — Basic CRUD operations only
- **Hardcoded categories** — No custom category management

### 9.2 Clear Task Division
Easy to split among 3-4 team members:

**Person 1 — Backend Setup & Auth**
- Node.js + Express setup
- MongoDB connection
- User model (with category budgets) and auth endpoints
- JWT middleware

**Person 2 — Backend Transactions & Analytics**
- Transaction model (with income/expense type)
- Transaction endpoints (CRUD)
- Summary endpoints (earnings, savings, expenditures)
- Category spending aggregation

**Person 3 — Frontend Auth & Transactions**
- Login/Signup screens
- Add/Edit Transaction screen (with income/expense toggle)
- Transaction History screen
- API service class
- Token management

**Person 4 — Frontend Dashboard & Charts**
- Dashboard layout with time filters
- Earnings/Savings/Expenditure cards
- Budget charts (fl_chart implementation)
- Settings screen with category budgets
- Budget progress logic
- UI polish

### 9.3 Easy to Explain in Presentations

**Simple Architecture:**
```
User → Flutter App → Node.js API (Express) → MongoDB
                  ↓
              JWT Auth
```

**Key Demo Points:**
1. "Users sign up and log in securely with JWT tokens"
2. "They can add both income and expenses with categories"
3. "The dashboard shows earnings, savings, and expenditures with week/month filter"
4. "Visual charts compare budget vs actual spending - both overall and by category"
5. "They can edit and delete transactions from history"
6. "Category-wise budgets allow granular spending control"
7. "Color-coded progress bars warn when approaching budget limits"
8. "All data is stored in MongoDB and accessible via REST API"

---

## 10. Success Criteria

✅ User can sign up and log in (JWT tokens working)
✅ User can add income and expense transactions with type toggle
✅ User can edit existing transactions
✅ User can delete transactions
✅ User can view all transactions in history with income/expense indicators
✅ Dashboard shows earnings, savings, and expenditures with week/month filter
✅ Dashboard displays budget vs expenditure charts (overall and category-wise)
✅ Chart toggle works between overall and category-wise budget views
✅ Budget progress bars change color based on spending percentage
✅ User can set overall monthly budget
✅ User can set individual category budgets
✅ Data persists after closing app (stored in MongoDB)
✅ Only user's own data is visible (auth middleware protecting routes)
✅ API endpoints properly validate input
✅ Backend handles errors gracefully
✅ Charts display accurate real-time budget data

---

## 11. What You Removed & Why

| Original Feature | Why Removed / Status |
|------------------|----------------------|
| AI Copilot | ❌ Requires LLM integration, API costs, complex prompt engineering |
| Receipt Scanner | ❌ Needs OCR, image processing, ML models — too advanced |
| Savings Goals | ❌ Adds separate tracking system, additional complexity |
| PIN/Biometric | ❌ Security feature nice but not core to expense tracking |
| Per-category budgets | ✅ **NOW INCLUDED** - Added to MVP |
| Charts/Reports | ✅ **NOW INCLUDED** - Budget charts added with fl_chart |
| Offline support | ❌ Needs sync queue, conflict resolution — very complex |
| Edit transactions | ✅ **NOW INCLUDED** - Full edit functionality added |
| Custom categories | ❌ Hardcoding 8 categories is simpler and sufficient |
| Export functionality | ❌ PDF/CSV generation adds extra dependencies |
| Recurring transactions | ❌ Requires scheduler/cron jobs |
| Dark mode | ❌ UI theming can be added later if time permits |

---

## 12. Project Folder Structure

### Backend (Node.js)
```
expense-tracker-backend/
├── config/
│   └── db.js                 # MongoDB connection
├── models/
│   ├── User.js              # User schema
│   └── Transaction.js       # Transaction schema
├── routes/
│   ├── auth.js              # Auth endpoints
│   ├── user.js              # User profile endpoints
│   └── transaction.js       # Transaction endpoints
├── middleware/
│   └── auth.js              # JWT verification
├── .env                     # Environment variables
├── server.js                # Express app entry point
└── package.json
```

### Frontend (Flutter)
```
expense_tracker/
├── lib/
│   ├── models/
│   │   ├── user.dart
│   │   └── transaction.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── transaction_provider.dart
│   │   └── budget_provider.dart
│   ├── services/
│   │   └── api_service.dart      # HTTP calls to backend
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── home/
│   │   │   └── dashboard_screen.dart
│   │   ├── transactions/
│   │   │   ├── add_transaction_screen.dart
│   │   │   └── transaction_history_screen.dart
│   │   └── settings/
│   │       └── settings_screen.dart
│   ├── widgets/
│   │   ├── budget_progress_bar.dart
│   │   ├── transaction_card.dart
│   │   ├── category_icon.dart
│   │   ├── overall_budget_chart.dart
│   │   └── category_budget_chart.dart
│   └── main.dart
└── pubspec.yaml
```

---

## 13. Environment Configuration

### Backend .env File
```env
PORT=5000
MONGODB_URI=mongodb://localhost:27017/expense_tracker
# OR for MongoDB Atlas:
# MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/expense_tracker

JWT_SECRET=your_super_secret_jwt_key_change_this_in_production
JWT_EXPIRE=7d
```

### Frontend API Configuration
Create a `lib/config/api_config.dart` file:
```dart
class ApiConfig {
  // Change this to your actual backend URL
  static const String baseUrl = 'http://localhost:5000/api';
  
  // For Android Emulator, use: http://10.0.2.2:5000/api
  // For iOS Simulator, use: http://localhost:5000/api
  // For real device, use your computer's IP: http://192.168.x.x:5000/api
}
```

---

## 14. Chart Implementation Guide

### 14.1 Overall Budget Chart (Bar Chart)

**Data needed:**
- Total monthly budget
- Total expenses this month

**Chart type:** Grouped Bar Chart

**Implementation approach:**
```dart
BarChart(
  BarChartData(
    barGroups: [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: budgetAmount, color: Colors.grey[300]),
          BarChartRodData(toY: spentAmount, color: getColorBasedOnPercentage()),
        ],
      ),
    ],
  ),
)
```

**Color logic:**
- Green if spent < 80% of budget
- Yellow if spent 80-100% of budget
- Red if spent > 100% of budget

### 14.2 Category-wise Budget Chart (Horizontal Bar Chart)

**Data needed:**
- For each category:
  - Category budget (if set, otherwise 0)
  - Actual spending in that category

**Chart type:** Horizontal Bar Chart

**Implementation approach:**
```dart
BarChart(
  BarChartData(
    alignment: BarChartAlignment.spaceAround,
    barGroups: categories.map((category) {
      return BarChartGroupData(
        x: categoryIndex,
        barRods: [
          BarChartRodData(toY: categoryBudget, color: Colors.grey[300]),
          BarChartRodData(toY: categorySpent, color: getColorForCategory()),
        ],
      );
    }).toList(),
    titlesData: FlTitlesData(
      leftTitles: SideTitles(
        showTitles: true,
        getTitles: (value) => categories[value.toInt()].name,
      ),
    ),
  ),
)
```

**Tips:**
- Only show categories with either a budget set OR spending > 0
- Sort categories by spending amount (highest first)
- Horizontal orientation works better for category names
- Add tap functionality to show detailed breakdown

### 14.3 API Data Flow for Charts

**Frontend requests:**
1. `GET /api/user/profile` → Get budget amounts
2. `GET /api/transactions/category-spending` → Get actual spending per category
3. `GET /api/transactions/summary?period=month` → Get total earnings/expenses

**Combine data in Provider:**
```dart
class BudgetProvider extends ChangeNotifier {
  Map<String, double> categoryBudgets = {};
  Map<String, double> categorySpending = {};
  double overallBudget = 0;
  double totalSpending = 0;
  
  Future<void> fetchChartData() async {
    // Fetch from API
    // Calculate percentages
    // notifyListeners()
  }
  
  Color getColorForPercentage(double percentage) {
    if (percentage < 80) return Colors.green;
    if (percentage < 100) return Colors.amber;
    return Colors.red;
  }
}
```

---

## 15. Potential Extensions (If You Finish Early)

If your team finishes the MVP and wants to add ONE feature for bonus points:

**Easiest additions:**
1. **Date range filters** — Custom date picker for flexible date ranges in history
2. **Search in history** — Search transactions by note/category
3. **Monthly comparison** — Compare current month vs previous months in charts
4. **Budget alerts** — Show notification when approaching budget limits
5. **Dark mode** — Add theme toggle for dark/light mode

**Medium difficulty:**
1. **Export to CSV** — Download transaction history as CSV file
2. **Recurring transactions** — Set up automatic monthly expenses (rent, subscriptions)
3. **Transaction tags** — Add custom tags beyond categories

**Still avoid:** AI, OCR, offline sync (these are genuinely complex).

---

## 16. Final Notes

This enhanced MVP focuses on:
- ✅ **Core value:** Track income/expenses and manage budgets with visual insights
- ✅ **Learning goals:** Flutter UI, REST API integration, Node.js backend, MongoDB, data visualization
- ✅ **Team-friendly:** Clear separation of frontend/backend tasks with chart implementation
- ✅ **Demo-friendly:** Impressive visual charts and full CRUD operations showcase full-stack skills
- ✅ **Real-world applicable:** Features mirror actual finance apps (budget tracking, charts, savings calculation)

**Key Enhancements from Basic MVP:**
- Income tracking alongside expenses
- Week/Month time filters for better insights
- Earnings, Savings, Expenditures breakdown
- Visual budget charts (overall + category-wise)
- Category-level budget controls
- Edit transaction functionality
- Professional chart visualizations with fl_chart

**Additional Tips:**
- Use MongoDB Atlas (free tier) for cloud database hosting
- Use environment variables (.env) for JWT secret and DB connection string
- Test API endpoints with Postman before connecting Flutter
- Add CORS to Express to allow Flutter app to make requests
- Keep error messages consistent across backend and frontend
- Use fl_chart examples from their documentation for chart implementation
- Test charts with various data scenarios (no data, single category, all categories)

**Chart Implementation Tips:**
- Start with overall budget chart (simpler - just 2 bars)
- Then implement category-wise chart (horizontal bars for better category label visibility)
- Use color coding consistently: green (safe), yellow (warning), red (over budget)
- Add loading states while fetching chart data
- Handle empty states gracefully (e.g., "No expenses yet this month")

You can confidently present this as a professional full-stack personal finance tracker with data visualization capabilities!
