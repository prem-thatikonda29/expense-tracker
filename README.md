# Expense Tracker

A full-stack personal expense tracking application with a Flutter mobile frontend and a Node.js REST API backend. Users can track income and expenses, set monthly and category-specific budgets, and visualize spending through interactive charts.

**Group 1**

| Roll No | Name               |
| ------- | ------------------ |
| 06      | Prem Thatikonda    |
| 14      | Karunesh Chikne    |
| 31      | Atharav Patil      |
| 42      | Muhammed Faheem    |

---

## Tech Stack

| Layer    | Technology                                                  |
| -------- | ----------------------------------------------------------- |
| Frontend | Flutter (Dart), Material Design 3, fl_chart                 |
| Backend  | Node.js, Express.js 5, MongoDB, Mongoose                    |
| Auth     | JWT (jsonwebtoken), bcryptjs                                |
| Storage  | shared_preferences (local token persistence)                |
| Other    | express-validator, CORS, intl (date formatting), http (REST)|

---

## Backend

### Models

#### 1. User

| Field            | Type   | Details                                                        |
| ---------------- | ------ | -------------------------------------------------------------- |
| email            | String | Required, unique, lowercase, trimmed                           |
| password         | String | Required, hashed with bcrypt                                   |
| monthlyBudget    | Number | Default: 0                                                     |
| categoryBudgets  | Object | Keys: Food, Transport, Shopping, Entertainment, Bills, Education, Health, Other (all Number, default: 0) |
| createdAt        | Date   | Auto-generated                                                 |

#### 2. Transaction

| Field     | Type     | Details                                                             |
| --------- | -------- | ------------------------------------------------------------------- |
| userId    | ObjectId | Required, references User                                           |
| type      | String   | Required, enum: `income`, `expense`                                 |
| amount    | Number   | Required, min: 0.01                                                 |
| category  | String   | Required, enum: Food, Transport, Shopping, Entertainment, Bills, Education, Health, Other |
| date      | Date     | Required, default: now                                              |
| note      | String   | Optional, trimmed                                                   |
| createdAt | Date     | Auto-generated                                                      |

### Endpoints

#### Auth (Public)

| #  | Method | Path               | Description                              |
| -- | ------ | ------------------ | ---------------------------------------- |
| 1  | POST   | /api/auth/signup   | Register a new user, returns JWT         |
| 2  | POST   | /api/auth/login    | Authenticate user, returns JWT           |

#### User (Private — requires Bearer token)

| #  | Method | Path                       | Description                            |
| -- | ------ | -------------------------- | -------------------------------------- |
| 3  | GET    | /api/user/profile          | Get current user profile and budgets   |
| 4  | PUT    | /api/user/budget           | Update overall monthly budget          |
| 5  | PUT    | /api/user/category-budgets | Update per-category budget limits      |

#### Transactions (Private — requires Bearer token)

| #  | Method | Path                                | Description                                        |
| -- | ------ | ----------------------------------- | -------------------------------------------------- |
| 6  | POST   | /api/transactions                   | Create a new transaction                           |
| 7  | GET    | /api/transactions                   | Get all transactions (sorted by date, newest first)|
| 8  | PUT    | /api/transactions/:id               | Update a transaction (owner only)                  |
| 9  | DELETE | /api/transactions/:id               | Delete a transaction (owner only)                  |
| 10 | GET    | /api/transactions/summary           | Get earnings/expenditures/savings for a period     |
| 11 | GET    | /api/transactions/category-spending | Get spending breakdown by category (current month) |

**Total endpoints: 11**

---

## Frontend

### Screens

| #  | Screen              | Route                 | Description                                                              |
| -- | ------------------- | --------------------- | ------------------------------------------------------------------------ |
| 1  | Login               | /login                | Email & password sign-in with visibility toggle                          |
| 2  | Signup              | /signup               | Account creation with password strength validation                       |
| 3  | Onboarding          | /onboarding           | Post-signup 2-step wizard to set monthly & category budgets              |
| 4  | Dashboard           | /dashboard            | Main hub — summary cards, bar/pie charts, bottom nav (Home/History/Settings) |
| 5  | Add Transaction     | /add-transaction      | Create or edit a transaction with category picker & date selector        |
| 6  | Transaction History | /transaction-history  | Chronological list of all transactions with edit/delete actions          |
| 7  | Settings            | /settings             | Manage monthly budget, category budgets, and logout                      |

**Total screens: 7**
