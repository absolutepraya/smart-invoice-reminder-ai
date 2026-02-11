import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'

export function useRiskSummary() {
  return useQuery({
    queryKey: ['risk', 'summary'],
    queryFn: () => api.get('/risk/summary').then((r) => r.data),
  })
}
