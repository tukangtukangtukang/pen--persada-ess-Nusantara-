/**
 * @swagger
 * tags:
 *   name: SupplierProducts
 *   description: API produk milik supplier
 */

/**
 * @swagger
 * /api/supplier-products/{supplierId}:
 *   get:
 *     summary: Ambil semua produk milik supplier
 *     tags: [SupplierProducts]
 *     parameters:
 *       - in: path
 *         name: supplierId
 *         required: true
 *     responses:
 *       200:
 *         description: List produk supplier berhasil diambil
 */

/**
 * @swagger
 * /api/supplier-products/{supplierId}:
 *   post:
 *     summary: Tambah produk ke supplier
 *     tags: [SupplierProducts]
 *     parameters:
 *       - in: path
 *         name: supplierId
 *     requestBody:
 *       required: true
 *     responses:
 *       201:
 *         description: Produk supplier berhasil ditambah
 */

/**
 * @swagger
 * /api/supplier-products/{supplierId}/{productId}:
 *   delete:
 *     summary: Hapus produk supplier
 *     tags: [SupplierProducts]
 *     parameters:
 *       - in: path
 *         name: supplierId
 *       - in: path
 *         name: productId
 *     responses:
 *       200:
 *         description: Produk supplier berhasil dihapus
 */

import express from 'express';
import * as ctrl from '../controllers/supplierProducts.js';
const router = express.Router();

router.get('/', ctrl.listSupplierProducts);
router.post('/', ctrl.createSupplierProduct);
router.put('/:id', ctrl.updateSupplierProduct);
router.delete('/:id', ctrl.deleteSupplierProduct);

export default router;
