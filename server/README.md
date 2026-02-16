# nafusa

A NestJS application with authentication, MongoDB, and Firebase integration.

## Features

- 🔐 JWT Authentication (Register/Login)
- 🛡️ Role-based access control
- 🔥 Firebase integration
- 📊 MongoDB with Mongoose
- 🚀 Rate limiting and security middleware
- ✨ Input validation with class-validator
- 🎯 TypeScript support

## Quick Start

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with your actual values
   ```

3. **Start MongoDB:**
   ```bash
   # Using Docker
   docker run -d -p 27017:27017 --name mongodb mongo:latest
   
   # Or install MongoDB locally
   ```

4. **Run the application:**
   ```bash
   npm run start:dev
   ```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/profile` - Get user profile (protected)

## Environment Variables

See `.env.example` for all required environment variables.

## Project Structure

```
src/
├── auth/                 # Authentication module
│   ├── dto/             # Data transfer objects
│   ├── guards/          # Auth guards
│   ├── schemas/         # MongoDB schemas
│   └── strategies/      # Passport strategies
├── common/              # Shared utilities
│   ├── decorators/      # Custom decorators
│   ├── guards/          # Global guards
│   └── middleware/      # Custom middleware
├── config/              # Configuration files
└── firebase/            # Firebase integration
```

## Security Features

- Helmet.js for security headers
- Rate limiting
- CORS configuration
- Input validation and sanitization
- JWT token authentication
- Password hashing with bcrypt

## License

MIT
