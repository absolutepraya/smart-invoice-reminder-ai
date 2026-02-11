import { createFileRoute } from '@tanstack/react-router'
import { InvoiceDetailPage } from '@/pages/invoice-detail'

export const Route = createFileRoute('/invoices/$id')({
  component: InvoiceDetailPage,
})
