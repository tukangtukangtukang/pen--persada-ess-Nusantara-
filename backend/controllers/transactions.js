// controllers/transactions.js
import { supabase } from '../db.js';

export const listTransactions = async (req, res) => {
  try {
    const { page=1, limit=50 } = req.query;
    const from = (page-1)*limit;
    const { data, error } = await supabase.from('transactions').select('*').order('date', { ascending: false }).range(from, from + Number(limit) -1);
    if (error) return res.status(500).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const getTransaction = async (req, res) => {
  try {
    const { id } = req.params;
    const { data, error } = await supabase.from('transactions').select('*').eq('id', id).single();
    if (error) return res.status(404).json({ error: 'Transaction not found' });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const createTransaction = async (req, res) => {
  try {
    const payload = req.body;
    const { data, error } = await supabase.from('transactions').insert(payload).select().single();
    if (error) return res.status(400).json({ error });
    res.status(201).json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const updateTransaction = async (req, res) => {
  try {
    const { id } = req.params;
    const payload = req.body;
    const { data, error } = await supabase.from('transactions').update(payload).eq('id', id).select().single();
    if (error) return res.status(400).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const deleteTransaction = async (req, res) => {
  try {
    const { id } = req.params;
    const { error } = await supabase.from('transactions').delete().eq('id', id);
    if (error) return res.status(400).json({ error });
    res.json({ message: 'Deleted' });
  } catch (err) { res.status(500).json({ error: err.message }); }
};
