# 🚀 Swagger UI Quick Start Guide

## 📖 Overview

The Billiard Club Management API provides comprehensive interactive documentation through Swagger UI, allowing you to explore and test all available endpoints directly from your browser.

---

## 🔗 Access URLs

### 🌐 **Swagger UI (Interactive)**
```
http://localhost:8080/api/v1/swagger-ui/index.html
```

### 📄 **OpenAPI Specification (Raw JSON)**
```
http://localhost:8080/api/v1/api-docs
```

---

## 🎯 Getting Started

### 1. **Open Swagger UI**
1. Navigate to: `http://localhost:8080/api/v1/swagger-ui/index.html`
2. You'll see the interactive API documentation interface

### 2. **Authenticate (Optional)**
1. Click the **"Authorize"** button (🔒) at the top right
2. Enter your JWT token: `Bearer <your-jwt-token>`
3. Click **"Authorize"** to apply authentication

### 3. **Test Endpoints**
1. Expand any endpoint section (e.g., "Authentication", "Companies")
2. Click on an endpoint to expand it
3. Click **"Try it out"** button
4. Fill in required parameters
5. Click **"Execute"** to test the endpoint

---

## 🔑 Authentication

### **Getting a JWT Token**
1. Find the **`POST /auth/login`** endpoint
2. Click **"Try it out"**
3. Enter credentials:
   ```json
   {
     "username": "admin",
     "password": "password123"
   }
   ```
4. Click **"Execute"**
5. Copy the `accessToken` from the response

### **Using the Token**
1. Click the **"Authorize"** button (🔒)
2. Enter: `Bearer <your-access-token>`
3. Click **"Authorize"**
4. Now you can access protected endpoints

---

## 📋 Available Endpoints

### 🔐 **Authentication**
- `POST /auth/login` - User login
- `GET /auth/health` - Auth service health
- `GET /auth/debug/users` - Get all users (debug)

### 🏢 **Companies**
- `GET /companies` - Get all companies
- `GET /companies/{id}` - Get company by ID
- `POST /companies` - Create new company
- `PUT /companies/{id}` - Update company
- `DELETE /companies/{id}` - Delete company

### 👥 **Users**
- `GET /users` - Get all users
- `GET /users/{username}` - Get user by username
- `POST /users/create` - Create new user
- `GET /users/test/password` - Test password matching
- `GET /users/test/hash` - Generate password hash

### 🔍 **System**
- `GET /health` - Health check
- `GET /simple/health` - Simple health check
- `GET /simple/test` - Simple test endpoint

---

## 🎨 Swagger UI Features

### **Interactive Testing**
- ✅ **Try it out** - Test endpoints directly
- ✅ **Request/Response** - See full request and response
- ✅ **Schema Validation** - Automatic parameter validation
- ✅ **Authentication** - Bearer token support

### **Documentation**
- 📖 **Endpoint Descriptions** - Detailed explanations
- 📋 **Parameter Documentation** - Required/optional fields
- 🔍 **Response Examples** - Sample responses
- 📊 **Schema Definitions** - Data structure documentation

### **Developer Tools**
- 🔧 **Code Generation** - Generate client code
- 📝 **Export** - Export API specification
- 🔍 **Search** - Find endpoints quickly

---

## 🛠️ Common Use Cases

### **1. Testing Authentication**
```bash
# 1. Open Swagger UI
# 2. Find POST /auth/login
# 3. Try it out with:
{
  "username": "admin",
  "password": "password123"
}
# 4. Copy the accessToken
```

### **2. Creating a Company**
```bash
# 1. Authorize with your token
# 2. Find POST /companies
# 3. Try it out with:
{
  "name": "New Billiard Club",
  "address": "123 Main Street",
  "phone": "+84 123 456 789",
  "email": "info@newclub.com"
}
```

### **3. Getting All Users**
```bash
# 1. Authorize with your token
# 2. Find GET /users
# 3. Try it out (no parameters needed)
# 4. View the response
```

---

## 🔧 Troubleshooting

### **Common Issues**

#### **1. 401 Unauthorized**
- **Problem:** Endpoint requires authentication
- **Solution:** Click "Authorize" and add your JWT token

#### **2. 404 Not Found**
- **Problem:** Endpoint doesn't exist
- **Solution:** Check the URL and ensure the API is running

#### **3. 400 Bad Request**
- **Problem:** Invalid request parameters
- **Solution:** Check the required fields and data types

#### **4. 500 Internal Server Error**
- **Problem:** Server-side error
- **Solution:** Check server logs and try again

### **Getting Help**
- Check the **Response** section for error details
- Review the **Schema** for correct data types
- Ensure all **required** fields are provided

---

## 📱 Mobile Access

### **Mobile-Friendly Interface**
- Swagger UI is responsive and works on mobile devices
- Touch-friendly interface for testing on tablets/phones
- Same functionality as desktop version

### **Mobile URLs**
```
http://localhost:8080/api/v1/swagger-ui/index.html
```

---

## 🔒 Security Notes

### **Development Environment**
- ✅ Swagger UI enabled for development
- ✅ Debug endpoints available
- ✅ Full API documentation visible

### **Production Environment**
- ⚠️ Consider disabling Swagger UI in production
- ⚠️ Remove debug endpoints
- ⚠️ Limit API documentation exposure

### **Best Practices**
- 🔐 Always use HTTPS in production
- 🔑 Keep JWT tokens secure
- 🗑️ Don't share tokens in logs or screenshots
- 🔄 Rotate tokens regularly

---

## 📚 Additional Resources

### **API Documentation**
- **OpenAPI Spec:** `/api/v1/api-docs`
- **Health Check:** `/api/v1/health`
- **Test Results:** `docs/SWAGGER_TEST_RESULTS.md`

### **Development Tools**
- **Postman Collection:** Available for import
- **cURL Examples:** In test scripts
- **Code Samples:** Generated by Swagger UI

### **Support**
- **Email:** support@acme-bida.com
- **Documentation:** https://acme-bida.com/docs
- **GitHub:** Repository with full source code

---

*Quick Start Guide - Billiard Club Management API*  
*Version: 1.0.0*  
*Last Updated: August 16, 2025*
