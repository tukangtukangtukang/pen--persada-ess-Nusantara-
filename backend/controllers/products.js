// controllers/products.js
import { supabase } from '../db.js';

export const listProducts = async (req, res) => {
  try {
    const { data, error } = await supabase.from('products').select('*');
    if (error) return res.status(500).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const getProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await supabase.from('products').select('*').eq('id', id).single();
    if (error) return res.status(404).json({ error: 'Product not found' });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const createProduct = async (req, res) => {
  try {
    const payload = req.body;
    const { data, error } = await supabase.from('products').insert(payload).select().single();
    if (error) return res.status(400).json({ error });
    res.status(201).json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const payload = req.body;
    const { data, error } = await supabase.from('products').update(payload).eq('id', id).select().single();
    if (error) return res.status(400).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const { error } = await supabase.from('products').delete().eq('id', id);
    if (error) return res.status(400).json({ error });
    res.json({ message: 'Deleted' });
  } catch (err) { res.status(500).json({ error: err.message }); }
};
