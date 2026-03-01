import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { ScrollText } from "lucide-react";

export default function AuditLogPage() {
  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-1">Audit Log</h1>
      <p className="text-muted-foreground text-sm mb-8">Track all workspace activity for compliance.</p>
      <Card className="p-12 flex flex-col items-center gap-4 text-center">
        <ScrollText className="h-12 w-12 text-muted-foreground/40" />
        <p className="text-muted-foreground">Audit log coming soon.</p>
      </Card>
    </div>
  );
}
