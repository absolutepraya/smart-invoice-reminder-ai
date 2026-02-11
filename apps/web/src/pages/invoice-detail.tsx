import { useParams } from "@tanstack/react-router";

export function InvoiceDetailPage() {
  const { id } = useParams({ from: "/invoices/$id" });

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold">Invoice {id}</h1>
      <p className="mt-2 text-gray-600">Invoice details and payment history.</p>
    </div>
  );
}
