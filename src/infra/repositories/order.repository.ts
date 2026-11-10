import { pool } from '../db';
import { CreateOrderInput } from '../../application/schemas/order.schemas';

export interface OrderRow {
  id: string;
  customer_email: string;
  amount_cents: number;
  status: 'pending' | 'paid' | 'canceled';
  created_at: Date;
}

export async function insertOrder(input: CreateOrderInput) : Promise<OrderRow> {
  const result = await pool.query<OrderRow>(
    "INSERT INTO orders (customer_email, amount_cents) VALUES ($1, $2) RETURNING *;",
    [input.customerEmail, input.amountCents]
  );
  return result.rows[0];
}