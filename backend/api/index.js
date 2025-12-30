// api/index.js
import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import swaggerUi from "swagger-ui-express";
import swaggerJSDoc from "swagger-jsdoc";
import path from "path"; // <--- JANGAN LUPA INI!
import fs from "fs";     // <--- Kita tambah ini buat debugging file

// Import Routes
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

// --- DEBUGGING FOLDER (Biar tau routes-nya kebawa apa nggak) ---
try {
  const routePath = path.join(process.cwd(), 'routes');
  console.log("📂 Cek Folder Routes ada di:", routePath);
  if (fs.existsSync(routePath)) {
    console.log("✅ Folder Routes DITEMUKAN!");
    const files = fs.readdirSync(routePath);
    console.log("📄 Isi file:", files);
  } else {
    console.log("❌ Folder Routes TIDAK ADA di path tersebut!");
  }
} catch (error) {
  console.log("⚠️ Gagal cek folder:", error.message);
}
// -----------------------------------------------------------

const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Persada ESS API",
      version: "1.0.0",
      description: "RESTful API (Supabase) - Persada ESS",
    },
    servers: [
      { 
        url: process.env.BASE_URL || "https://pen-persada-ess-nusantara.vercel.app" 
      }
    ]
  },
  // Gunakan absolute path yang aman
  apis: [path.join(process.cwd(), 'routes/*.js')], 
};

const swaggerSpec = swaggerJSDoc(swaggerOptions);

app.use(
  "/docs",
  swaggerUi.serve,
  swaggerUi.setup(swaggerSpec, {
    customCssUrl:
      "https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/4.15.5/swagger-ui.min.css",
    customJs:
      "https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/4.15.5/swagger-ui-bundle.js",
    swaggerOptions: {
      persistAuthorization: true,
    },
  })
);

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

if (process.env.NODE_ENV !== 'production') {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () => console.log(`✅ Server jalan di http://localhost:${PORT}`));
}

export default app;