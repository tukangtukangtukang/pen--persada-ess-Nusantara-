// server.js
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import swaggerUi from "swagger-ui-express";
import swaggerJSDoc from "swagger-jsdoc";

import customersRouter from "../routes/customers.js";
import productsRouter from "../routes/products.js";
import suppliersRouter from "../routes/suppliers.js";
import supplierProductsRouter from "../routes/supplierProducts.js";
import transactionsRouter from "../routes/transactions.js";
import setoranRouter from "../routes/setoran.js";
import usersRouter from "../routes/users.js";

dotenv.config();
const app = express();
app.use(cors());
app.use(express.json());

const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Persada ESS API",
      version: "1.0.0",
      description: "RESTful API (Supabase) - Persada ESS",
    },
    servers: [{ url: process.env.BASE_URL || `http://localhost:${process.env.PORT || 3000}` }]
  },
  apis: ["../routes/*.js", "./api/index.js"],
};

const swaggerSpec = swaggerJSDoc(swaggerOptions);
app.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// simple root message
app.get("/", (req, res) => res.send("Persada ESS API Running. Open /docs for API docs"));

// mount routers
app.use("/api/customers", customersRouter);
app.use("/api/products", productsRouter);
app.use("/api/suppliers", suppliersRouter);
app.use("/api/supplier-products", supplierProductsRouter);
app.use("/api/transactions", transactionsRouter);
app.use("/api/setoran", setoranRouter);
app.use("/api/users", usersRouter);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`✅ Server jalan di http://localhost:${PORT}`));

export default app;