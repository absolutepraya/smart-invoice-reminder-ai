import { createFileRoute } from '@tanstack/react-router'
import { ClientsPage } from '@/pages/clients'

export const Route = createFileRoute('/clients/')({
  component: ClientsPage,
})
