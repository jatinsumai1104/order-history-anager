# User Order History Management

This Rails application manages the order history of users. It allows users to view a list of all users and download their respective order histories in CSV format. The CSV generation process is handled asynchronously to prevent timeouts, ensuring a smooth user experience.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Database Schema](#database-schema)
- [Importing Data](#importing-data)
- [Asynchronous CSV Generation](#asynchronous-csv-generation)
- [Frontend Integration](#frontend-integration)
- [Technologies Used](#technologies-used)

## Features

- Displays a list of users with options to download their order history in CSV format.
- Asynchronous CSV generation using Sidekiq to handle large datasets without browser timeouts.
- Data imported from CSV files.
- User-friendly interface with jQuery DataTables for enhanced table functionality.

## Installation

### Prerequisites

- Ruby 3.x
- Rails 7.x
- PostgreSQL
- Redis (for Sidekiq)
- Node.js and Yarn

### Steps

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your_username/user-order-history.git
   cd user-order-history
   ```

2. **Install dependencies:**

   ```bash
   bundle install
   yarn install
   ```

3. **Set up the database:**

   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Install and start Redis (for Sidekiq):**

   ```bash
   brew install redis
   redis-server
   ```

5. **Start Sidekiq in a separate terminal:**

   ```bash
   bundle exec sidekiq
   ```

6. **Start the Rails server:**

   ```bash
   rails server
   ```

7. **Access the application:**

   Open your browser and navigate to `http://localhost:3000`.

## Usage

### Importing Data

1. Place your CSV files (users.csv, products.csv, order_details.csv) in a `user-order-history/tmp/input csv` directory.
2. Run the import script:

   ```bash
   rails import:csv
   ```
> [!WARNING]
> 1. Before importing data, all existing users, products, and orders are deleted from the database to ensure a fresh import and avoid duplication.
> 2. A user is only created if the username, email, and phone fields exist. If any of these fields are missing, the user will not be created.
> 3. While importing an order, if a product with the given product code is not found, a new product record will be created with the name and category fields set to null.

### Viewing Users and Downloading Orders

- Navigate to the homepage to view the list of users.
- Click on the "Download CSV" button next to a user to initiate the CSV generation process.
- Once the CSV is ready, it will be automatically downloaded.

## Database Schema

### Tables

1. **Users**
   
  | Column Name  | Data Type | Constraints   | Description                        |
  |--------------|-----------|---------------|------------------------------------|
  | `id`         | `uuid`    | Primary Key   | Unique identifier for each user    |
  | `name`       | `string`  |               | Name of the user                   |
  | `email`      | `string`  | Unique, Indexed | User's email address, must be unique |
  | `phone`      | `string`  |               | User's phone number                |

2. **Products**

| Column Name  | Data Type   | Constraints       | Description                          |
|--------------|-------------|-------------------|--------------------------------------|
| `id`         | `uuid`      | Primary Key       | Unique identifier for each product   |
| `code`       | `string`    | Unique, Indexed   | Unique product code                  |
| `name`       | `string`    | Nullable          | Name of the product (can be null)    |
| `category`   | `string`      | Nullable          | Product category (can be null)       |

3. **Orders**

| Column Name  | Data Type   | Constraints       | Description                          |
|--------------|-------------|-------------------|--------------------------------------|
| `id`         | `uuid`      | Primary Key       | Unique identifier for each order     |
| `user_id`    | `uuid`      | Foreign Key       | References the `id` of the `User`    |
| `product_id` | `uuid`      | Foreign Key       | References the `id` of the `Product` |
| `order_date` | `date`      |                   | The date when the order was placed   |

### Relationships

- A user can have many orders.
- An order belongs to a user and a product.

## Importing Data

- Data is imported from CSV files located in the `/tmp/input csv` directory.
- Bulk insertion is used to optimize the import process.
- N+1 query issues have been mitigated using eager loading and proper associations.

## Asynchronous CSV Generation

- The CSV generation process is handled asynchronously using Sidekiq.
- WebSocket implementation alerts users when the CSV is ready for download
- This prevents the application from timing out when handling large datasets.

> [!NOTE]
> 1. The generated CSV files are stored in the `tmp/user_csv` folder with filenames in the format `<user_email>_orders.csv`.
> 2. If a file with the same name already exists, the existing file will be reused, and a new file will not be created. The frontend will be served the available file to avoid redundant CSV generation.

## Frontend Integration

- The user interface is built with Bootstrap and jQuery DataTables for enhanced table functionality.
- AJAX is used to trigger CSV downloads without refreshing the page.
- Polling is implemented to notify users when the CSV is ready.

## Technologies Used

- **Ruby on Rails** - Web application framework
- **Sidekiq** - Background job processing
- **Redis** - In-memory data structure store, used by Sidekiq
- **PostgreSQL** - Database
- **jQuery DataTables** - Interactive tables
- **Bootstrap** - Frontend framework
