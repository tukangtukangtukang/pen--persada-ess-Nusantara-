/**
 * @swagger
 * tags:
 *   name: Users
 *   description: API user & login
 */

/**
 * @swagger
 * /api/users:
 *   get:
 *     summary: Ambil semua user
 *     tags: [Users]
 *     responses:
 *       200:
 *         description: List user berhasil diambil
 */

/**
 * @swagger
 * /api/login:
 *   post:
 *     summary: Login user
 *     tags: [Users]
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

import express from 'express';
import * as ctrl from '../controllers/users.js';
const router = express.Router();

router.get('/', ctrl.listUsers);
router.post('/register', ctrl.registerUser);
router.post('/login', ctrl.loginUser);
router.delete('/:id', ctrl.deleteUser);

export default router;
