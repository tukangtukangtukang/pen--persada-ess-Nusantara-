/**
 * @swagger
 * tags:
 *   name: Products
 *   description: API untuk data produk
 */

/**
 * @swagger
 * /api/products:
 *   get:
 *     summary: Ambil semua produk
 *     tags: [Products]
 *     responses:
 *       200:
 *         description: List produk berhasil diambil
 */

/**
 * @swagger
 * /api/products:
 *   post:
 *     summary: Tambah produk baru
 *     tags: [Products]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *     responses:
 *       201:
 *         description: Produk berhasil dibuat
 */

/**
 * @swagger
 * /api/products/{id}:
 *   put:
 *     summary: Update produk berdasarkan ID
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Produk berhasil diupdate
 */

/**
 * @swagger
 * /api/products/{id}:
 *   delete:
 *     summary: Hapus produk berdasarkan ID
 *     tags: [Products]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Produk berhasil dihapus
 */

import express from 'express';
import * as ctrl from '../controllers/products.js';
const router = express.Router();

router.get('/', ctrl.listProducts);
router.post('/', ctrl.createProduct);
router.get('/:id', ctrl.getProduct);
router.put('/:id', ctrl.updateProduct);
router.delete('/:id', ctrl.deleteProduct);

export default router;
