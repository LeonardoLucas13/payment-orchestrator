import { Router } from 'express';
import { createOrderSchema } from '../../application/schemas/order.schemas';
import { OrderService } from '../../application/services/order.service';

export const orderRouter = Router();

const orderService = new OrderService();

orderRouter.post('/', async (req, res) => {
  const parsed = createOrderSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'invalid_request', details: parsed.error.issues });
  }

  const order = await orderService.createOrder(parsed.data);
  return res.status(201).json(order);
});