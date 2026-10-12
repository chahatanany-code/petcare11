# 🐾 PetCare Connect — Complete Java Web Application

**PetCare Connect** is a full-stack, enterprise-grade Java web application that bridges pet parents with background-checked pet sitters, dog walkers, and boarding caregivers. Built with **Spring Boot 3.3.4**, **Spring Security 6**, **Spring Data MongoDB**, **Thymeleaf**, and **Bootstrap 5**, it provides a responsive, trustworthy experience for managing pets and booking appointments.

---

## 📑 Table of Contents

1. [Project Overview](#-project-overview)
2. [Key Features](#-key-features)
3. [Technology Stack](#-technology-stack)
4. [Architecture & Layered Design](#-architecture--layered-design)
5. [Database Design & MongoDB Configuration](#-database-design--mongodb-configuration)
6. [Security & Role-Based Access Control](#-security--role-based-access-control)
7. [Default Demo Accounts](#-default-demo-accounts)
8. [Getting Started & Running Locally](#-getting-started--running-locally)
9. [Automated Testing Suite](#-automated-testing-suite)
10. [Project Directory Layout](#-project-directory-layout)

---

## 🌟 Project Overview

PetCare Connect eliminates the friction and uncertainty of finding reliable pet care. It allows pet owners to maintain rich digital profiles for their dogs, cats, and exotic pets, search local caregivers by specialty and rate, and book time-specific appointments with real-time conflict validation. Sitters can customize their care packages, manage incoming booking requests, toggle availability, and track their ratings.

---

## ✨ Key Features

### 🏡 Public Platform
* **Hero Search & Filtering**: Multi-factor search across cities/locations, service types (Dog Walking, Pet Sitting, Boarding, Grooming), maximum hourly price, and minimum rating.
* **Top-Rated & Trending Sitters**: Dynamic rankings calculated from stored ratings and completed appointments.
* **Service Catalog**: Clear breakdown of care offerings, typical durations, and included perks (GPS route logs, photo updates).
* **Company & Trust Pages**: Dedicated *How It Works*, *About Us*, and *Contact* pages with server-validated inquiry forms and interactive FAQ accordions.

### 🐶 Pet Owner Experience
* **Owner Dashboard**: Real-time stats on registered pets, pending requests, confirmed visits, and recent booking receipts.
* **Pet Profile Management**: Full CRUD operations for pets (name, species, breed, age, weight, medical/dietary notes, photo URL).
* **Ownership Security**: Strict authorization ensuring owners can only view, edit, or delete their own pets.
* **Live Cost Calculator**: Dynamic duration and total price calculation as service or appointment times change.
* **Booking Management**: View detailed booking vouchers and cancel eligible appointments with customized cancellation notes.

### 🐱 Pet Sitter Experience
* **Sitter Dashboard**: Incoming booking requests table with instant **Accept** and **Decline** workflows.
* **Availability Toggle**: Instant toggle between *Accepting New Bookings* and *Temporarily Away*.
* **Service Offering Management**: Add, edit, or delete customized care offerings with independent hourly rates and descriptions.
* **Public Profile Editor**: Customize bio, headline, specialties tags (e.g. Senior Dog Care, Oral Medication, Trail Hikes), and service area.
* **Appointment Completion**: Mark confirmed appointments as *Completed* to increment verified experience metrics.

### 🛡️ Core Reliability & Business Logic
* **Time-Slot Conflict Engine**: Backend conflict detection rejecting overlapping bookings (`start < existing.end AND end > existing.start`) for sitters on the same date with active appointments (`PENDING` or `CONFIRMED`).
* **Clean Status Transitions**: State machine enforcing transitions: `PENDING` ➔ `CONFIRMED` ➔ `COMPLETED` (or `CANCELLED` / `REJECTED`).
* **Zero-Setup Embedded Fallback**: Automatically binds a high-performance in-memory MongoDB wire server on `localhost:27017` when external MongoDB is not configured, while seamlessly connecting to MongoDB Atlas whenever `MONGODB_URI` is provided!

---

## 💻 Technology Stack

* **Language**: Java 17 (LTS)
* **Backend Framework**: Spring Boot 3.3.4
  * `spring-boot-starter-web`: REST endpoints, MVC controllers, file uploads
  * `spring-boot-starter-thymeleaf`: Server-Side Rendering (SSR)
  * `spring-boot-starter-security`: Authentication, authorization, CSRF protection, BCrypt
  * `thymeleaf-extras-springsecurity6`: Role-aware conditional template rendering
  * `spring-boot-starter-data-mongodb`: High-level document mapping and indexing
  * `spring-boot-starter-validation`: Jakarta Bean Validation (`@Valid`, `@NotBlank`, etc.)
  * `de.bwaldvogel:mongo-java-server`: Lightweight in-memory MongoDB engine for zero-friction local testing
* **Database**: MongoDB Atlas / MongoDB 6+
* **Frontend UI**:
  * HTML5 + CSS3 (Warm Cream `#FAF7F2`, Forest Green `#1B4332`, Terracotta `#E76F51`)
  * JavaScript (Vanilla ES6+ for live cost calculation, conflict warnings, role toggles)
  * Bootstrap 5.3 & Bootstrap Icons 1.11
* **Build Tool**: Apache Maven 3.9+ (includes Maven Wrapper `mvnw`)

---

## 🏛️ Architecture & Layered Design

The application follows a strict layered enterprise architecture:

```
src/main/java/com/petcareconnect/
├── controller/            # Web MVC Controllers
│   ├── HomeController.java         (Home, Services, Trending, How It Works, About, Contact)
│   ├── AuthController.java         (Login, Register, Session Redirects)
│   ├── OwnerController.java        (Owner Dashboard, Profile Updates)
│   ├── PetController.java          (Pet CRUD & Authorization Enforcement)
│   ├── SitterController.java       (Public Sitter Profiles & Sitter Dashboard)
│   ├── ServiceController.java      (Sitter Care Offerings Management)
│   └── BookingController.java      (Appointment Creation, Vouchers, Accept/Reject/Cancel)
│
├── service/               # Core Business Logic & Validation
│   ├── AuthenticationService.java  (User Registration, Role Provisioning, Current User)
│   ├── CustomUserDetailsService.java (Spring Security Integration)
│   ├── OwnerService.java           (Owner Profile Logic)
│   ├── PetService.java             (Pet Validation & CRUD)
│   ├── SitterService.java          (Multi-Factor Search, Ratings, Availability)
│   ├── ServiceOfferingService.java (Service Package Rules)
│   ├── BookingService.java         (Conflict Detection, Pricing, State Transitions)
│   └── TrendingSittersService.java (Platform Analytics & Ranking Calculations)
│
├── repository/            # Spring Data MongoDB Repositories
│   ├── UserRepository.java
│   ├── OwnerRepository.java
│   ├── SitterRepository.java
│   ├── PetRepository.java
│   ├── ServiceRepository.java
│   ├── BookingRepository.java
│   └── ReviewRepository.java
│
├── model/                 # MongoDB Document Entities
│   ├── User.java                   (Abstract base with email, passwordHash, role, avatar)
│   ├── Owner.java                  (Address, emergency contact, pet references)
│   ├── Sitter.java                 (City, bio, headline, base rate, rating, specialties)
│   ├── Pet.java                    (Species, breed, age, weight, care notes, photo URL)
│   ├── ServiceOffering.java / Service.java (Title, description, hourly price, status)
│   ├── Booking.java                (Date, time slots, duration, total price, status)
│   ├── Review.java                 (Rating, comments, verified owner details)
│   ├── Role.java                   (ROLE_OWNER, ROLE_SITTER)
│   ├── ServiceType.java            (DOG_WALKING, PET_SITTING, PET_BOARDING, PET_GROOMING)
│   └── BookingStatus.java          (PENDING, CONFIRMED, COMPLETED, CANCELLED, REJECTED)
│
├── dto/                   # Form Submission & Validation DTOs
│   ├── RegisterDto.java, LoginDto.java, PetDto.java, ServiceOfferingDto.java,
│   ├── SitterProfileDto.java, BookingDto.java, SearchFilterDto.java, ContactDto.java
│
├── config/                # Framework & Security Configuration
│   ├── SecurityConfig.java         (Filter chain, role redirection, BCrypt encoder)
│   ├── MongoConfig.java            (Atlas connectivity + zero-config embedded fallback)
│   └── DataInitializer.java        (Development seed runner)
│
├── exception/             # Custom Exceptions & Global Handling
│   ├── SlotUnavailableException.java
│   ├── SitterNotFoundException.java
│   ├── ResourceNotFoundException.java
│   ├── UnauthorizedException.java
│   └── GlobalExceptionHandler.java (Handles 404, 403, 500 & conflict redirects)
│
└── util/                  # Diagnostics & Utilities
    └── MongoConnection.java        (Ping & database health checks)
```

---

## 🍃 Database Design & MongoDB Configuration

### MongoDB Atlas Setup
In compliance with 12-factor configuration principles, database credentials are never hardcoded. Configure MongoDB Atlas via the standard environment variable:

```bash
export MONGODB_URI="mongodb+srv://<username>:<password>@<cluster>.mongodb.net/petcareconnect?retryWrites=true&w=majority"
```

### Zero-Setup Local Execution
If `MONGODB_URI` is not set, `MongoConfig` detects whether port `27017` is active. If no local MongoDB is running, it automatically spins up an in-memory pure-Java MongoDB wire server. This allows students, reviewers, and developers to clone and run the application immediately without installing Docker or external databases!

---

## 🔒 Security & Role-Based Access Control

* **Passwords**: Encrypted with `BCryptPasswordEncoder` (strength 10). Plain-text passwords are never stored.
* **Role Redirection**:
  * Authenticated `ROLE_OWNER` users are automatically routed to `/owner/dashboard`.
  * Authenticated `ROLE_SITTER` users are automatically routed to `/sitter/dashboard`.
* **Access Control**:
  * `/owner/**`, `/pets/**`, `/bookings/new`, `/bookings/my-bookings` ➔ `ROLE_OWNER`
  * `/sitter/**`, `/services/manage/**` ➔ `ROLE_SITTER`
  * Unauthorized cross-role access is blocked with custom `error/403.html`.
* **CSRF Protection**: All POST forms include Spring Security CSRF tokens.

---

## 👥 Default Demo Accounts

When started for the first time, `DataInitializer` seeds realistic sample data:

| Role | Email | Password | Details |
| :--- | :--- | :--- | :--- |
| **Pet Owner** | `alex.turner@example.com` | `password123` | Owner of Golden Retriever (Bella) and Scottish Fold (Mochi) |
| **Pet Owner** | `olivia.reed@example.com` | `password123` | Owner of French Bulldog (Rocky) |
| **Pet Sitter** | `sarah.jenkins@example.com` | `password123` | Certified Vet Tech, San Francisco, CA ($32/hr, 4.9★) |
| **Pet Sitter** | `marcus.chen@example.com` | `password123` | Canine Fitness Specialist, Seattle, WA ($28/hr, 5.0★) |
| **Pet Sitter** | `elena.rostova@example.com` | `password123` | Gentle Feline Specialist, Portland, OR ($35/hr, 4.8★) |
| **Pet Sitter** | `david.miller@example.com` | `password123` | Backyard Boarding, Austin, TX ($40/hr, 4.9★) |

---

## 🚀 Getting Started & Running Locally

### Prerequisites
* **Java 17 or newer** (`java -version`)
* Terminal / Command Prompt

### Step 1: Navigate to Project Directory
```bash
cd /Users/avikamdeol/.gemini/antigravity-ide/scratch/petcare-connect
```

### Step 2: (Optional) Set MongoDB Atlas Credentials
```bash
export MONGODB_URI="mongodb+srv://<username>:<password>@<cluster>.mongodb.net/petcareconnect?retryWrites=true&w=majority"
```
*(If omitted, the app will run with the automatic in-memory MongoDB fallback)*

### Step 3: Run the Application

Using the provided Maven Wrapper:
```bash
./mvnw spring-boot:run
```

Or using an installed Maven:
```bash
mvn spring-boot:run
```

Or execute the pre-built standalone JAR:
```bash
java -jar target/petcare-connect-1.0.0.jar
```

### Step 4: Open in Your Browser
Open [http://localhost:8080](http://localhost:8080) in any web browser.

---

## 🧪 Automated Testing Suite

Run the full automated test suite (including unit tests, validation tests, and Spring MockMvc integration tests):

```bash
./mvnw test
```

### Tests Covered:
1. `WebMvcIntegrationTest`:
   * Verifies all public routes return `HTTP 200 OK`.
   * Verifies anonymous users attempting to access dashboards are redirected to `/login` (`HTTP 302`).
   * Verifies role-based security (`ROLE_OWNER` access allowed, cross-role access to `/sitter/dashboard` rejected with `HTTP 403 Forbidden`).
   * Verifies end-to-end booking creation and **slot conflict rejection** (`SlotUnavailableException`).
2. `BookingConflictTest`:
   * Unit tests overlapping time logic across partial, enclosing, and adjacent slots.
3. `PetCareConnectApplicationTests`:
   * Verifies clean Spring ApplicationContext initialization and MongoDB index registration.

---

## 📂 Project Directory Layout

```
petcare-connect/
├── pom.xml                                  # Maven dependencies & build configuration
├── README.md                                # Project documentation
├── mvnw / mvnw.cmd                          # Maven wrapper executables
├── src/
│   ├── main/
│   │   ├── java/com/petcareconnect/         # Java backend source code
│   │   └── resources/
│   │       ├── application.properties       # Environment configuration
│   │       ├── static/
│   │       │   ├── css/styles.css           # Design tokens, color palette, responsive cards
│   │       │   └── js/                      # main.js (roles & alerts) and booking.js (pricing)
│   │       └── templates/                   # Server-rendered Thymeleaf HTML templates
│   │           ├── fragments/               # Reusable head, navbar, footer, alerts
│   │           ├── auth/                    # login.html, register.html
│   │           ├── owner/                   # dashboard.html, profile.html
│   │           ├── sitter/                  # dashboard.html, profile-edit.html, services-manage.html, service-form.html
│   │           ├── sitters/                 # list.html, detail.html, trending.html
│   │           ├── services/                # list.html
│   │           ├── pets/                    # list.html, add.html, edit.html
│   │           ├── bookings/                # create.html, owner-bookings.html, detail.html
│   │           ├── pages/                   # how-it-works.html, about.html, contact.html
│   │           └── error/                   # 403.html, 404.html, 500.html
│   └── test/
│       └── java/com/petcareconnect/         # Integration & unit test suite
```

---

## 📜 License & Credits

Built for **PetCare Connect**. Created with Spring Boot & Thymeleaf. Free to expand and customize for production deployment.
