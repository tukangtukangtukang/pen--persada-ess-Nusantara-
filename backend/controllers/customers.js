// controllers/customers.js
import { supabase } from '../db.js';

export const listCustomers = async (req, res) => {
  try {
    const { page=1, limit=50, search } = req.query;
    const from = (page-1)*limit;
    let qb = supabase.from('customers').select('*');

    if (search) {
      qb = qb.ilike('name', `%${search}%`);
    }

    const { data, error } = await qb.range(from, from + Number(limit) - 1);
    if (error) return res.status(500).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const getCustomer = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await supabase.from('customers').select('*').eq('id', id).single();
    if (error) return res.status(404).json({ error: 'Customer not found' });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const createCustomer = async (req, res) => {
  try {
    const payload = req.body;
    const { data, error } = await supabase.from('customers').insert(payload).select().single();
    if (error) return res.status(400).json({ error });
    res.status(201).json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const updateCustomer = async (req, res) => {
  try {
    const { id } = req.params;
    const payload = req.body;
    const { data, error } = await supabase.from('customers').update(payload).eq('id', id).select().single();
    if (error) return res.status(400).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const deleteCustomer = async (req, res) => {
  try {
    const { id } = req.params;
    const { error } = await supabase.from('customers').delete().eq('id', id);
    if (error) return res.status(400).json({ error });
    res.json({ message: 'Deleted' });
  } catch (err) { res.status(500).json({ error: err.message }); }
};
