import express from "express";
import cors from "cors";
import swaggerUi from "swagger-ui-express";
import swaggerJSDoc from "swagger-jsdoc";

import { products } from "./data/product.js";
import { suppliers } from "./data/suppliers.js";
import { customers } from "./data/customers.js";
import { transactions } from "./data/transactions.js";
import { users } from "./data/users.js";
import { setoran } from "./data/setoran.js";



const app = express();
app.use(cors());
app.use(express.json());

// === Swagger ===
const swaggerOptions = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Persada ESS API",
      version: "1.0.0",
      description: "Dokumentasi API Persada ESS (Customer, Product, Supplier)",
    },
  },
  apis: ["./server.js"],
};
const swaggerSpec = swaggerJSDoc(swaggerOptions);
app.use("/docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

/**
 * @swagger
 * /products:
 *   get:
 *     summary: Ambil daftar produk
 *     responses:
 *       200:
 *         description: Berhasil ambil data produk
 */
app.get("/products", (req, res) => {
  res.json(products);
});

/**
 * @swagger
 * /suppliers:
 *   get:
 *     summary: Ambil daftar supplier
 *     responses:
 *       200:
 *         description: Berhasil ambil data supplier
 */
app.get("/suppliers", (req, res) => {
  res.json(suppliers);
});

/**
 * @swagger
 * /suppliers/{id}:
 *   get:
 *     summary: Ambil supplier berdasarkan ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Data supplier ditemukan
 *       404:
 *         description: Supplier tidak ditemukan
 */
app.get("/suppliers/:id", (req, res) => {
  const supplier = suppliers.find((s) => s.id === req.params.id);
  if (!supplier) return res.status(404).json({ message: "Supplier not found" });
  res.json(supplier);
});

/**
 * @swagger
 * /customers:
 *   get:
 *     summary: Ambil daftar customer
 *     responses:
 *       200:
 *         description: Berhasil ambil data customer
 */
app.get("/customers", (req, res) => {
  res.json(customers);
});

/**
 * @swagger
 * /customers/{id}:
 *   get:
 *     summary: Ambil customer berdasarkan ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Data customer ditemukan
 *       404:
 *         description: Customer tidak ditemukan
 */
app.get("/customers/:id", (req, res) => {
  const customer = customers.find((c) => c.id === req.params.id);
  if (!customer) return res.status(404).json({ message: "Customer not found" });
  res.json(customer);
});

/**
 * @swagger
 * /transactions:
 *   get:
 *     summary: Ambil daftar transaksi
 *     responses:
 *       200:
 *         description: Berhasil ambil data transaksi
 */
app.get("/transactions", (req, res) => {
  res.json(transactions);
});

/**
 * @swagger
 * /transactions/{id}:
 *   get:
 *     summary: Ambil detail transaksi berdasarkan ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Data transaksi ditemukan
 *       404:
 *         description: Transaksi tidak ditemukan
 */
app.get("/transactions/:id", (req, res) => {
  const trx = transactions.find((t) => t.id === req.params.id);
  if (!trx) return res.status(404).json({ message: "Transaction not found" });
  res.json(trx);
});

/**
 * @swagger
 * /users:
 *   get:
 *     summary: Ambil daftar semua user
 *     responses:
 *       200:
 *         description: Berhasil ambil data user
 */
app.get("/users", (req, res) => {
  const safeUsers = users.map((u) => ({
    id: u.id,
    username: u.username,
    role: u.role,
    name: u.name,
  }));
  res.json(safeUsers);
});

/**
 * @swagger
 * /login:
 *   post:
 *     summary: Login user dengan username dan password
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               username:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: Login berhasil
 *       401:
 *         description: Username atau password salah
 */
app.post("/login", (req, res) => {
  const { username, password } = req.body;
  const user = users.find(
    (u) => u.username === username && u.password === password
  );

  if (!user) {
    return res.status(401).json({ message: "Username atau password salah" });
  }

  // di versi berikutnya bisa diganti JWT token
  res.json({
    message: "Login berhasil",
    user: {
      id: user.id,
      name: user.name,
      role: user.role,
      username: user.username,
    },
  });
});

/**
 * @swagger
 * /setoran:
 *   get:
 *     summary: Ambil daftar setoran
 *     responses:
 *       200:
 *         description: Berhasil ambil data setoran
 */
app.get("/setoran", (req, res) => {
  res.json(setoran);
});

/**
 * @swagger
 * /setoran/{id}:
 *   get:
 *     summary: Ambil data setoran berdasarkan ID
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Data setoran ditemukan
 *       404:
 *         description: Setoran tidak ditemukan
 */
app.get("/setoran/:id", (req, res) => {
  const record = setoran.find((s) => s.id === req.params.id);
  if (!record) return res.status(404).json({ message: "Setoran not found" });
  res.json(record);
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`✅ Server jalan di http://localhost:${PORT}`));
