/**
 * @swagger
 * tags:
 *   name: Transactions
 *   description: API untuk data transaksi
 */

/**
 * @swagger
 * /api/transactions:
 *   get:
 *     summary: Ambil semua transaksi
 *     tags: [Transactions]
 *     responses:
 *       200:
 *         description: List transaksi berhasil diambil
 */

/**
 * @swagger
 * /api/transactions:
 *   post:
 *     summary: Tambah transaksi baru
 *     tags: [Transactions]
 *     requestBody:
 *       required: true
 *     responses:
 *       201:
 *         description: Transaksi berhasil dibuat
 */

import express from 'express';
import * as ctrl from '../controllers/transactions.js';
const router = express.Router();

router.get('/', ctrl.listTransactions);
router.post('/', ctrl.createTransaction);
router.get('/:id', ctrl.getTransaction);
router.put('/:id', ctrl.updateTransaction);
router.delete('/:id', ctrl.deleteTransaction);

export default router;
