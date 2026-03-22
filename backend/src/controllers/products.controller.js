import Products from '../models/products.model.js'
import Business from '../models/business.model.js'
import { getProductPerformance } from '../services/products.service.js'

const addProducts = async (req, res) => {
  const { productName, description, costPrice, sellingPrice, quantity } = req.body;
  const userId = req.user.id;

  // Validate input fields
  if (!productName || !description || !costPrice || !sellingPrice || !quantity) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    // Find the user's business
    const business = await Business.findOne({ where: { userId } });
    if (!business) {
      return res.status(404).json({ message: 'Business not found for this user' });
    }

    const calculatedProfit = sellingPrice - costPrice;

    // Create the product
    const product = await Products.create({
      productName,
      description,
      costPrice,
      sellingPrice,
      quantity,
      profit: calculatedProfit,
      businessId: business.id,
    });

    res.status(200).json({ message: 'Product added successfully', product });
  } catch (error) {
    console.error('addProducts error:', error);
    res.status(500).json({ message: 'Failed to add product', error: error.message });
  }
};

//find all Productss
const findAllProducts = async (req, res) => {
 try {
 const products = await Products.findAll()
 res.status(200).json({ products })
 } catch (error) {
 console.log(error)
 res.status(500).json({error: 'Failed to retrieve Productss'})
 }
}
 
//delete Products by id
const deleteProducts = async (req, res) => {
 try {
 const {id} = req.params
 await Products.destroy({where:{id}})
 res.status(200).json({message: 'Products  deleted successfully'})
 } catch (error) {
 console.log(error)
 res.status(500).json({error: 'Failed to delete Products '})
 }
}

const viewProductPerformance = async (req, res) => {
  try {

    const userId = req.user.id;
    const { id } = req.params;
    const { period } = req.query;

    const performance = await getProductPerformance(userId, id, period);

    res.status(200).json(performance);

  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: "Failed to retrieve product performance"
    });
  }
};
export {addProducts, findAllProducts, deleteProducts, viewProductPerformance}



