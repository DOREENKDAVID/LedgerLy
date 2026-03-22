import express from 'express';
import * as businessController from '../controllers/business.controller.js';
import auth from '../middleware/auth.js';

const V1 = express.Router();


// GET all businesses
V1.get('/business', auth, businessController.findAllBusiness);
// POST a new business
V1.post('/business', auth, businessController.addBusiness);
// DELETE a business by ID
V1.delete('/business/:id', auth, businessController.deleteBusiness);
// Update a business by ID
V1.put('/business/:id', auth, businessController.updateBusiness);
// Get a single business by ID
V1.get('/business/:id', auth, businessController.getBusinessById);

export default V1

