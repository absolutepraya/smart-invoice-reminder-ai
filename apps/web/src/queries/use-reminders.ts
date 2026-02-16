import { useQuery } from '@tanstack/react-query'
import { api } from '@/lib/api'
import type { Reminder } from '@/types'

export function useReminders() {
  return useQuery<Reminder[]>({
    queryKey: ['reminders'],
    queryFn: () => api.get('/reminders').then((r) => r.data),
  })
}
