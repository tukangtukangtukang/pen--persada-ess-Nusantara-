/**
 * @swagger
 * tags:
 *   name: Customers
 *   description: API untuk data customer
 */

/**
 * @swagger
 * /api/customers:
 *   get:
 *     summary: Ambil semua customer
 *     tags: [Customers]
 *     responses:
 *       200:
 *         description: List customer berhasil diambil
 */

/**
 * @swagger
 * /api/customers:
 *   post:
 *     summary: Tambah customer baru
 *     tags: [Customers]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *     responses:
 *       201:
 *         description: Customer berhasil dibuat
 */

/**
 * @swagger
 * /api/customers/{id}:
 *   get:
 *     summary: Ambil customer berdasarkan ID
 *     tags: [Customers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Data customer berhasil diambil
 */

/**
 * @swagger
 * /api/customers/{id}:
 *   put:
 *     summary: Update customer berdasarkan ID
 *     tags: [Customers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Customer berhasil diperbarui
 */

/**
 * @swagger
 * /api/customers/{id}:
 *   delete:
 *     summary: Hapus customer berdasarkan ID
 *     tags: [Customers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Customer berhasil dihapus
 */

import express from 'express';
import * as ctrl from '../controllers/customers.js';
const router = express.Router();

router.get('/', ctrl.listCustomers);
router.post('/', ctrl.createCustomer);
router.get('/:id', ctrl.getCustomer);
router.put('/:id', ctrl.updateCustomer);
router.delete('/:id', ctrl.deleteCustomer);

export default router;
