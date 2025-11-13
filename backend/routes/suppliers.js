/**
 * @swagger
 * tags:
 *   name: Suppliers
 *   description: API untuk data supplier
 */

/**
 * @swagger
 * /api/suppliers:
 *   get:
 *     summary: Ambil semua supplier
 *     tags: [Suppliers]
 *     responses:
 *       200:
 *         description: List supplier berhasil diambil
 */

/**
 * @swagger
 * /api/suppliers:
 *   post:
 *     summary: Tambah supplier baru
 *     tags: [Suppliers]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *     responses:
 *       201:
 *         description: Supplier berhasil dibuat
 */

/**
 * @swagger
 * /api/suppliers/{id}:
 *   put:
 *     summary: Update supplier
 *     tags: [Suppliers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Supplier berhasil diperbarui
 */

/**
 * @swagger
 * /api/suppliers/{id}:
 *   delete:
 *     summary: Hapus supplier
 *     tags: [Suppliers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *     responses:
 *       200:
 *         description: Supplier berhasil dihapus
 */

import express from 'express';
import * as ctrl from '../controllers/suppliers.js';
const router = express.Router();

router.get('/', ctrl.listSuppliers);
router.post('/', ctrl.createSupplier);
router.get('/:id', ctrl.getSupplier);
router.put('/:id', ctrl.updateSupplier);
router.delete('/:id', ctrl.deleteSupplier);

export default router;
