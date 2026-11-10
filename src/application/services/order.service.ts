import { CreateOrderInput } from "../schemas/order.schemas";
import { insertOrder, OrderRow } from "../../infra/repositories/order.repository";

export interface IOrderService {
  createOrder(input: CreateOrderInput): Promise<OrderRow>;
}


export class OrderService implements IOrderService {

  public async createOrder(input: CreateOrderInput): Promise<OrderRow> {
    return insertOrder(input);
  }
}