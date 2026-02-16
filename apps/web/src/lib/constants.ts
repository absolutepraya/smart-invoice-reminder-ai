export const RISK_LEVELS = ['LOW', 'MEDIUM', 'HIGH'] as const
export type RiskLevel = (typeof RISK_LEVELS)[number]

export const INVOICE_STATUSES = ['UNPAID', 'PARTIAL', 'PAID', 'OVERDUE'] as const
export type InvoiceStatus = (typeof INVOICE_STATUSES)[number]

export const REMINDER_CHANNELS = ['EMAIL', 'WHATSAPP', 'SMS'] as const
export type ReminderChannel = (typeof REMINDER_CHANNELS)[number]

export const MESSAGE_TYPES = ['SOPAN', 'TEGAS', 'PERINGATAN'] as const
export type MessageType = (typeof MESSAGE_TYPES)[number]

export const DELIVERY_STATUSES = ['PENDING', 'SENT', 'FAILED'] as const
export type DeliveryStatus = (typeof DELIVERY_STATUSES)[number]
