// controllers/suppliers.js
import { supabase } from '../db.js';

export const listSuppliers = async (req, res) => {
  try {
    const { data, error } = await supabase.from('suppliers').select('*');
    if (error) return res.status(500).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const getSupplier = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await supabase.from('suppliers').select('*').eq('id', id).single();
    if (error) return res.status(404).json({ error: 'Supplier not found' });
    // include products
    const { data: products } = await supabase.from('supplier_products').select('*').eq('supplier_id', id);
    res.json({ ...data, products });
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const createSupplier = async (req, res) => {
  try {
    const payload = req.body;
    const { products: prods = [], ...supplierData } = payload;
    const { data, error } = await supabase.from('suppliers').insert(supplierData).select().single();
    if (error) return res.status(400).json({ error });
    // insert supplier_products if any
    if (prods.length) {
      const withSupplier = prods.map(p => ({ ...p, supplier_id: data.id }));
      await supabase.from('supplier_products').insert(withSupplier);
    }
    res.status(201).json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const updateSupplier = async (req, res) => {
  try {
    const { id } = req.params;
    const { products: prods, ...supplierData } = req.body;
    const { data, error } = await supabase.from('suppliers').update(supplierData).eq('id', id).select().single();
    if (error) return res.status(400).json({ error });
    // optionally update products - for simplicity, not implemented complex diff here
    if (Array.isArray(prods)) {
      // delete existing and re-insert (simple approach)
      await supabase.from('supplier_products').delete().eq('supplier_id', id);
      const withSupplier = prods.map(p => ({ ...p, supplier_id: id }));
      if (withSupplier.length) await supabase.from('supplier_products').insert(withSupplier);
    }
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const deleteSupplier = async (req, res) => {
  try {
    const { id } = req.params;
    await supabase.from('supplier_products').delete().eq('supplier_id', id);
    const { error } = await supabase.from('suppliers').delete().eq('id', id);
    if (error) return res.status(400).json({ error });
    res.json({ message: 'Deleted' });
  } catch (err) { res.status(500).json({ error: err.message }); }
};
