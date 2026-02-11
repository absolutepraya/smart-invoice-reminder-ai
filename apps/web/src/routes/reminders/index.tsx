import { createFileRoute } from "@tanstack/react-router";
import { RemindersPage } from "@/pages/reminders";

export const Route = createFileRoute("/reminders/")({
  component: RemindersPage,
});
