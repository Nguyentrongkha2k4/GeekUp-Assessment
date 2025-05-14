## I can't implement all feature within 48 hours because I have an exam 13/5.

Link erd và bảng ánh xạ: [here](https://drive.google.com/file/d/1XweM_Q2_mEY1bjx2yM9xhnYzV6N02srZ/view?usp=sharing)

# API Specifications for E-commerce Platform

## 1. Fetch All Product Categories

### Endpoint:
```
GET /api/v1/categories
```

### Description:
Fetches a list of all product categories available in the e-commerce platform.

### Request:
- **Method**: GET
- **URL**: `/api/v1/categories`

### Response:
- **Status Code**: 200 OK
- **Body**:
  ```json
  [
    {
      "id": 1,
      "name": "Electronics",
    },
    {
      "id": 2,
      "name": "Clothing",
    },
    {
      "id": 3,
      "name": "Home Appliances",
    }
  ]
  ```

### Error Responses:
- **Status Code**: 500 Internal Server Error
  - **Body**:
    ```json
    {
      "error": "Unable to fetch categories"
    }
    ```

---

## 2. Fetch Products in a Specific Category

### Endpoint:
```
GET /api/v1/categories/{categoryId}/products
```

### Description:
Fetches a list of products that belong to a specific category.

### Request:
- **Method**: GET
- **URL**: `/api/v1/categories/{categoryId}/products`
- **Path Parameters**:
  - `categoryId` (integer): The ID of the product category.

### Response:
- **Status Code**: 200 OK
- **Body**:
  ```json
  [
    {
      "id": 101,
      "name": "Smartphone X",
      "price": 799.99,
      "description": "Latest model with advanced features",
      "size": "M",
      "quantity": 30
    },
    {
      "id": 102,
      "name": "Smartphone Y",
      "price": 699.99,
      "description": "Affordable model with essential features",
      "size": "M",
      "quantity": 50
    }
  ]
  ```

### Error Responses:
- **Status Code**: 404 Not Found
  - **Body**:
    ```json
    {
      "error": "Category not found"
    }
    ```
- **Status Code**: 500 Internal Server Error
  - **Body**:
    ```json
    {
      "error": "Unable to fetch products for this category"
    }
    ```

---

## 3. Search for Products Using Filters and Search Terms

### Endpoint:
```
GET /api/v1/products/search
```

### Description:
Allows users to search (full-text search) for products using various filters and search terms such as name, category, brand, price range, etc.

### Request:
- **Method**: GET
- **URL**: `/api/v1/products/search`
- **Query Parameters**:
  - `searchTerm` (string): The keyword(s) to search in product name/description.
  - `categoryId` (integer, optional): The category ID to filter by.
  - `brand` (string, optional): The brand of the product.
  - `minPrice` (decimal, optional): The minimum price range.
  - `maxPrice` (decimal, optional): The maximum price range.
  - `sortBy` (string, optional): Sorting criteria (e.g., "price", "name").
  - `sortOrder` (string, optional): Sorting order ("asc", "desc").

### Response:
- **Status Code**: 200 OK
- **Body**:
  ```json
  {
    "products": [
      {
        "id": 101,
        "name": "Smartphone X",
        "price": 799.99,
        "brand": "BrandA",
        "description": "Latest model with advanced features",
      },
      {
        "id": 102,
        "name": "Smartphone Y",
        "price": 699.99,
        "brand": "BrandB",
        "description": "Affordable model with essential features",
      }
    ]
  }
  ```

### Error Responses:
- **Status Code**: 400 Bad Request
  - **Body**:
    ```json
    {
      "error": "Invalid search parameters"
    }
    ```
- **Status Code**: 500 Internal Server Error
  - **Body**:
    ```json
    {
      "error": "Error searching products"
    }
    ```

---

## 4. Create a New Order and Process Payment

### Endpoint:
```
POST /api/v1/orders
```

### Description:
Creates a new order and processes payment for the user.

### Request:
- **Method**: POST
- **URL**: `/api/v1/orders`
- **Body** (JSON):
  ```json
  {
    "userId": 123,
    "products": [
      { "productId": 101, "quantity": 2 },
      { "productId": 102, "quantity": 1 }
    ],
    "shippingAddress": "123 Main St, City, Country",
    "paymentMethod": "credit_card",
    "paymentDetails": {
      "cardNumber": "1234567890123456",
      "expiryDate": "12/23",
      "cvv": "123"
    }
  }
  ```

### Response:
- **Status Code**: 201 Created
- **Body**:
  ```json
  {
    "orderId": 9876,
    "totalAmount": 2299.97,
    "status": "Payment processed, order confirmed"
  }
  ```

### Error Responses:
- **Status Code**: 400 Bad Request
  - **Body**:
    ```json
    {
      "error": "Invalid order data"
    }
    ```
- **Status Code**: 500 Internal Server Error
  - **Body**:
    ```json
    {
      "error": "Unable to create order or process payment"
    }
    ```

---

## 5. Send Order Confirmation Email (Processed Asynchronously)

### Endpoint:
```
POST /api/v1/orders/{orderId}/send-confirmation-email
```

### Description:
Sends an order confirmation email to the user asynchronously after order creation and payment processing.

### Request:
- **Method**: POST
- **URL**: `/api/v1/orders/{orderId}/send-confirmation-email`
- **Path Parameters**:
  - `orderId` (integer): The ID of the order to send the confirmation email.

### Response:
- **Status Code**: 202 Accepted (Asynchronous Processing)
- **Body**:
  ```json
  {
    "message": "Order confirmation email is being processed"
  }
  ```

### Error Responses:
- **Status Code**: 404 Not Found
  - **Body**:
    ```json
    {
      "error": "Order not found"
    }
    ```
- **Status Code**: 500 Internal Server Error
  - **Body**:
    ```json
    {
      "error": "Unable to send order confirmation email"
    }
    ```
