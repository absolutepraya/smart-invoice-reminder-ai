import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";

export function useInvoices() {
  return useQuery({
    queryKey: ["invoices"],
    queryFn: () => api.get("/invoices").then((r) => r.data),
  });
}

export function useInvoice(id: string) {
  return useQuery({
    queryKey: ["invoices", id],
    queryFn: () => api.get(`/invoices/${id}`).then((r) => r.data),
  });
}

export function useOverdueInvoices() {
  return useQuery({
    queryKey: ["invoices", "overdue"],
    queryFn: () => api.get("/invoices/overdue").then((r) => r.data),
  });
}
