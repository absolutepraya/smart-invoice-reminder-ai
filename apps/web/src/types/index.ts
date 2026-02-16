import type {
  DeliveryStatus,
  InvoiceStatus,
  MessageType,
  ReminderChannel,
  RiskLevel,
} from '@/lib/constants'

export interface Client {
  id: string
  company_name: string
  email: string
  phone: string | null
  current_risk_category: RiskLevel
  created_at: string
}

export interface Invoice {
  id: string
  client_id: string
  invoice_number: string
  amount: number
  issued_date: string
  due_date: string
  status: InvoiceStatus
}

export interface Payment {
  id: string
  invoice_id: string
  amount_paid: number
  payment_date: string
  days_late: number
}

export interface RiskScoringLog {
  id: string
  client_id: string
  evaluation_date: string
  probability_score: number
  risk_label: RiskLevel
  model_version: string
}

export interface Reminder {
  id: string
  invoice_id: string
  channel: ReminderChannel
  message_type: MessageType
  message_content: string
  delivery_status: DeliveryStatus
  sent_at: string
}

export interface RiskSummary {
  low: number
  medium: number
  high: number
  total_overdue_amount: number
}
