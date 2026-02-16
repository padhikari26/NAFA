# Database Seeders

This directory contains seeders for populating the database with initial data.

## Available Seeders

### Events Seeder
- Creates 15 sample events with realistic titles, descriptions, and dates
- Only includes required fields: `title`, `description`, and `date`

### Members Seeder  
- Creates 15 sample user accounts with USER role
- Only includes required fields: `name`, `email`, and `role`
- Optional fields included: `phone`, `isActive`, `isVerified`

## Usage

To run all seeders:

```bash
npm run seed
```

This will:
1. Connect to your MongoDB database
2. Check if data already exists (prevents duplicate seeding)
3. Insert sample events and members
4. Display success/error messages

## Environment Setup

Make sure you have the `MONGO_URI` environment variable set in your `.env` file:

```
MONGO_URI=mongodb://localhost:27017/nafusa
```

If not set, it will default to `mongodb://localhost:27017/nafusa`.

## Notes

- The seeders check for existing data before inserting to prevent duplicates
- Events are created with dates ranging from August to December 2024
- Members include a mix of active/inactive and verified/unverified users
- All required schema fields are included, optional fields are selectively added
