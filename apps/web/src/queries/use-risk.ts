import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { RiskSummary } from '@/types'

export function useRiskSummary() {
  return useQuery<RiskSummary>({
    queryKey: ['risk', 'summary'],
    queryFn: () => api.get('/risk/summary').then((r) => r.data),
  })
}
