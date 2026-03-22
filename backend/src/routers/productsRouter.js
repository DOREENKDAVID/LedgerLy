import express from 'express';
import * as ProductsController from '../controllers/products.controller.js';
import auth from '../middleware/auth.js';

const router = express.Router();

// POST /v1/products - Add a new product
router.post('/products', auth, ProductsController.addProducts);

export default router;