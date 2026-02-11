import { useParams } from "@tanstack/react-router";

export function ClientDetailPage() {
  const { id } = useParams({ from: "/clients/$id" });

  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold">Client {id}</h1>
      <p className="mt-2 text-gray-600">Client details and risk history.</p>
    </div>
  );
}
