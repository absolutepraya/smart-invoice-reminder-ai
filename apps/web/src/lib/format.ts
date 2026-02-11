export function formatCurrency(amount: number, currency = 'IDR'): string {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency,
  }).format(amount)
}

export function formatDate(date: string | Date): string {
  return new Intl.DateTimeFormat('id-ID', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  }).format(new Date(date))
}

export function formatRiskLevel(level: 'low' | 'medium' | 'high'): string {
  const labels = { low: 'Low', medium: 'Medium', high: 'High' } as const
  return labels[level]
}
