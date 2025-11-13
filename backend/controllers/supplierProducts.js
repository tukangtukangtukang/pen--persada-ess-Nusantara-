// controllers/supplierProducts.js
import { supabase } from '../db.js';

export const listSupplierProducts = async (req, res) => {
  try {
    const { data, error } = await supabase.from('supplier_products').select('*');
    if (error) return res.status(500).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const createSupplierProduct = async (req, res) => {
  try {
    const payload = req.body;
    const { data, error } = await supabase.from('supplier_products').insert(payload).select().single();
    if (error) return res.status(400).json({ error });
    res.status(201).json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const updateSupplierProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const payload = req.body;
    const { data, error } = await supabase.from('supplier_products').update(payload).eq('id', id).select().single();
    if (error) return res.status(400).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const deleteSupplierProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const { error } = await supabase.from('supplier_products').delete().eq('id', id);
    if (error) return res.status(400).json({ error });
    res.json({ message: 'Deleted' });
  } catch (err) { res.status(500).json({ error: err.message }); }
};
