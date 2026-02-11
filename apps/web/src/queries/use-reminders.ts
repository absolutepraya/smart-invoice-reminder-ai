import { useQuery } from "@tanstack/react-query";
import { api } from "@/lib/api";

export function useReminders() {
  return useQuery({
    queryKey: ["reminders"],
    queryFn: () => api.get("/reminders").then((r) => r.data),
  });
}
