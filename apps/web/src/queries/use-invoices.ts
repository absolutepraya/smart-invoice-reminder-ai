import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { Invoice } from '@/types'

export function useInvoices() {
  return useQuery<Invoice[]>({
    queryKey: ['invoices'],
    queryFn: () => api.get('/invoices').then((r) => r.data),
  })
}

export function useInvoice(id: string) {
  return useQuery<Invoice>({
    queryKey: ['invoices', id],
    queryFn: () => api.get(`/invoices/${id}`).then((r) => r.data),
  })
}

export function useOverdueInvoices() {
  return useQuery<Invoice[]>({
    queryKey: ['invoices', 'overdue'],
    queryFn: () => api.get('/invoices/overdue').then((r) => r.data),
  })
}
