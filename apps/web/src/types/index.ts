import type { RiskLevel, InvoiceStatus } from "@/lib/constants";

export interface Client {
  id: string;
  name: string;
  email: string;
  risk_level: RiskLevel;
  created_at: string;
}

export interface Invoice {
  id: string;
  client_id: string;
  client_name: string;
  amount: number;
  currency: string;
  status: InvoiceStatus;
  due_date: string;
  days_overdue: number;
  risk_level: RiskLevel;
  created_at: string;
}

export interface Reminder {
  id: string;
  invoice_id: string;
  client_name: string;
  channel: "email" | "whatsapp" | "telegram";
  status: "sent" | "failed" | "pending";
  sent_at: string;
}

export interface RiskSummary {
  low: number;
  medium: number;
  high: number;
  total_overdue_amount: number;
}
