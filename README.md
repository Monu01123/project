# 🎓 Skillvault

> A full-stack SaaS-style Learning Management System (LMS) designed for scalable and seamless online education.

[![Live Demo](https://img.shields.io/badge/Live-Demo-brightgreen.svg)](https://project-azure-six-24.vercel.app/)
[![GitHub Repository](https://img.shields.io/badge/GitHub-Repository-blue.svg)](#) <!-- Add your repo link here -->

## 📖 About the Project

Skillvault is a comprehensive SaaS-style learning platform where students can browse courses, enroll, stream high-quality video content, and process secure payments. Instructors have dedicated tools to create, upload, and manage their course materials. Built with performance and scalability in mind, the platform leverages an optimized backend deployed on Azure to handle concurrent video streaming and secure financial transactions.

## ✨ Key Features

- 📚 **Interactive Learning:** Seamless course browsing, intuitive enrollment, and smooth video streaming.
- 💳 **Secure Payments:** Integrated Stripe payment gateway with robust webhook handling for instant transaction verification.
- 🔐 **Role-Based Access Control (RBAC):** Distinct dashboards and permissions for students and instructors.
- 🛡️ **Robust Authentication:** Secure JWT-based authentication and stateless session management.
- ⚡ **High Performance:** Optimized MySQL database utilizing strategic indexing for lightning-fast queries.
- ☁️ **Cloud-Native Architecture:** Backend deployed on Azure App Service with media securely stored on Azure Blob Storage.

## 🛠️ Tech Stack

![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Stripe](https://img.shields.io/badge/Stripe-626CD9?style=for-the-badge&logo=Stripe&logoColor=white)

## 🏗️ System Architecture

The application follows a modern decoupled architecture:
1. **Frontend (Client):** A responsive React.js application handles the user interface, video player, and course dashboards.
2. **Backend (API):** A Node.js/Express RESTful API orchestrates business logic, handles Stripe webhooks, and manages Azure Blob SDK communications.
3. **Database:** A relational MySQL database stores user profiles, course metadata, enrollments, and payment records.
4. **Cloud Infrastructure:** The Express server is hosted on Azure App Service for high availability, while heavy video files and images are streamed directly from Azure Blob Storage to reduce server load.

## 🚀 Getting Started

### Prerequisites
- Node.js (v16 or higher)
- MySQL Server
- An Azure Account (for Blob Storage)
- Stripe Developer Account

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/skillvault.git
   cd skillvault
   ```

2. **Install Frontend Dependencies:**
   ```bash
   cd client
   npm install
   ```

3. **Install Backend Dependencies:**
   ```bash
   cd server
   npm install
   ```

4. **Configure Environment Variables:**
   Create a `.env` file in the `server` directory and add your specific credentials:
   ```env
   # Database Configuration
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_mysql_password
   DB_NAME=skillvault_db

   # Authentication
   JWT_SECRET=your_super_secret_jwt_key
   JWT_EXPIRES_IN=7d

   # Stripe Keys
   STRIPE_SECRET_KEY=sk_test_your_stripe_secret
   STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret

   # Azure Blob Storage Credentials
   AZURE_STORAGE_CONNECTION_STRING=DefaultEndpointsProtocol=https;AccountName=...
   AZURE_CONTAINER_NAME=course-media
   ```

5. **Start the Development Servers:**
   - For backend: `npm run dev`
   - For frontend: `npm start`

## 🔌 API Endpoints

### 🔐 Auth
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Authenticate user & receive JWT
- `GET /api/auth/me` - Get current logged-in user profile

### 🎓 Courses
- `GET /api/courses` - List all available courses
- `GET /api/courses/:id` - Get specific course details
- `POST /api/courses` - Create a new course (Instructor only)
- `POST /api/courses/:id/modules` - Upload video modules (Instructor only)

### 💳 Payments
- `POST /api/payments/create-checkout-session` - Initialize Stripe checkout
- `POST /api/payments/webhook` - Stripe webhook listener for transaction completion

### 👤 Users
- `GET /api/users/:id/enrollments` - Get student's enrolled courses
- `PUT /api/users/profile` - Update user details

## 🗄️ Database Schema

The core relational structure is optimized for fast read/write operations:
- **`Users`**: Stores credentials, roles (`student`, `instructor`, `admin`), and profile data.
- **`Courses`**: Holds course metadata, pricing, and instructor foreign keys.
- **`Modules`**: Contains video URLs mapped to Azure Blob Storage, linked to specific courses.
- **`Enrollments`**: A junction table linking Users and Courses to track student progress and access.
- **`Payments`**: Logs Stripe transaction IDs, amounts, and payment statuses for auditing.

## 📸 Screenshots

*(Replace the placeholder URLs with actual screenshot links)*

| Student Dashboard | Course Video Player |
| :---: | :---: |
| ![Dashboard Placeholder](https://via.placeholder.com/500x300?text=Student+Dashboard) | ![Player Placeholder](https://via.placeholder.com/500x300?text=Video+Player) |

| Instructor Upload Panel | Stripe Checkout Flow |
| :---: | :---: |
| ![Upload Placeholder](https://via.placeholder.com/500x300?text=Instructor+Upload) | ![Checkout Placeholder](https://via.placeholder.com/500x300?text=Stripe+Checkout) |

## ☁️ Deployment

Skillvault is engineered for the cloud:
- **Frontend:** Deployed and globally distributed via Vercel for fast edge-caching.
- **Backend:** Hosted on **Azure App Service**, configured with auto-scaling to handle traffic spikes during peak enrollment times.
- **Media Storage:** Video and image assets are uploaded to **Azure Blob Storage**. The backend generates SAS (Shared Access Signature) tokens to securely deliver media to the frontend without exposing storage credentials.

## 🧠 What I Learned

Building Skillvault provided invaluable experience in developing scalable full-stack applications:
1. **Cloud Media Management:** Mastered Azure Blob Storage integration, learning how to stream large video files efficiently without bottlenecking the Node.js server.
2. **Asynchronous Payment Flows:** Implemented secure Stripe webhooks, handling asynchronous events to ensure users only get course access *after* successful payment confirmation.
3. **Database Optimization:** Designed a normalized MySQL schema and utilized strategic indexing on foreign keys (like user_id and course_id) to maintain fast query performance as the data grows.
4. **Enterprise-grade Security (RBAC):** Engineered a robust Role-Based Access Control system, creating custom middleware to strictly separate instructor capabilities from student access.

## 📬 Contact

**[Your Name]** 
- 💼 LinkedIn: [linkedin.com/in/yourprofile](#) 
- 🐙 GitHub: [github.com/yourusername](#)
- 📧 Email: your.email@example.com

---
*If you liked this project, please consider giving it a ⭐ on GitHub!*
