import { createFileRoute } from "@tanstack/react-router";
import { ClientDetailPage } from "@/pages/client-detail";

export const Route = createFileRoute("/clients/$id")({
  component: ClientDetailPage,
});
