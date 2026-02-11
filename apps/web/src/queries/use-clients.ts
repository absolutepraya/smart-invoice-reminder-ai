import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'

export function useClients() {
  return useQuery({
    queryKey: ['clients'],
    queryFn: () => api.get('/clients').then((r) => r.data),
  })
}

export function useClient(id: string) {
  return useQuery({
    queryKey: ['clients', id],
    queryFn: () => api.get(`/clients/${id}`).then((r) => r.data),
  })
}
