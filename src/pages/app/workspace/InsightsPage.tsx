import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { BarChart3 } from "lucide-react";

export default function InsightsPage() {
  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-1">Insights</h1>
      <p className="text-muted-foreground text-sm mb-8">Performance analytics and content intelligence.</p>
      <Card className="p-12 flex flex-col items-center gap-4 text-center">
        <BarChart3 className="h-12 w-12 text-muted-foreground/40" />
        <p className="text-muted-foreground">Insights dashboard coming soon.</p>
      </Card>
    </div>
  );
}
