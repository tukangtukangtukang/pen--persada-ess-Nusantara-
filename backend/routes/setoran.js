/**
 * @swagger
 * tags:
 *   name: Setoran
 *   description: API untuk data setoran
 */

/**
 * @swagger
 * /api/setoran:
 *   get:
 *     summary: Ambil semua setoran
 *     tags: [Setoran]
 *     responses:
 *       200:
 *         description: List setoran berhasil diambil
 */

/**
 * @swagger
 * /api/setoran:
 *   post:
 *     summary: Tambah setoran
 *     tags: [Setoran]
 *     requestBody:
 *       required: true
 *     responses:
 *       201:
 *         description: Setoran berhasil dibuat
 */

import express from 'express';
import * as ctrl from '../controllers/setoran.js';
const router = express.Router();

router.get('/', ctrl.listSetoran);
router.post('/', ctrl.createSetoran);
router.get('/:id', ctrl.getSetoran);
router.put('/:id', ctrl.updateSetoran);
router.delete('/:id', ctrl.deleteSetoran);

export default router;
