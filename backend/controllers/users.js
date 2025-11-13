// controllers/users.js
import { supabase } from '../db.js';

export const listUsers = async (req, res) => {
  try {
    const { data, error } = await supabase.from('users').select('id, username');
    if (error) return res.status(500).json({ error });
    res.json(data);
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const registerUser = async (req, res) => {
  try {
    const { username, password } = req.body;
    const { data, error } = await supabase.from('users').insert({ username, password }).select().single();
    if (error) return res.status(400).json({ error });
    res.status(201).json({ message: 'Registered', user: { id: data.id, username: data.username } });
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const loginUser = async (req, res) => {
  try {
    const { username, password } = req.body;
    const { data, error } = await supabase.from('users').select('*').eq('username', username).eq('password', password).single();
    if (!data || error) return res.status(401).json({ message: 'Invalid credentials' });
    // later: return JWT; for now return user minimal data
    res.json({ message: 'Login successful', user: { id: data.id, username: data.username } });
  } catch (err) { res.status(500).json({ error: err.message }); }
};

export const deleteUser = async (req, res) => {
  try {
    const { id } = req.params;
    const { error } = await supabase.from('users').delete().eq('id', id);
    if (error) return res.status(400).json({ error });
    res.json({ message: 'Deleted' });
  } catch (err) { res.status(500).json({ error: err.message }); }
};
