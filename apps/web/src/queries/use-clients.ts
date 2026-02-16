import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { Client } from '@/types'

export function useClients() {
  return useQuery<Client[]>({
    queryKey: ['clients'],
    queryFn: () => api.get('/clients').then((r) => r.data),
  })
}

export function useClient(id: string) {
  return useQuery<Client>({
    queryKey: ['clients', id],
    queryFn: () => api.get(`/clients/${id}`).then((r) => r.data),
  })
}
