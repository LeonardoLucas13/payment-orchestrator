import { z } from 'zod';

export const createOrderSchema = z.object({
  customerEmail: z.string().email(),
  amountCents: z.number().int().positive(),
});

export type CreateOrderInput = z.infer<typeof createOrderSchema>;