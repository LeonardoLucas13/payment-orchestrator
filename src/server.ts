import express from 'express';
import { pool } from './db';

const app = express();
app.use(express.json());

app.get('/health', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', database: 'up' });
  } catch {
    res.status(503).json({ status: 'error', database: 'down' });
  }
});

const port = Number(process.env.PORT ?? 3000);
app.listen(port, () => console.log(`API rodando na porta ${port}`));