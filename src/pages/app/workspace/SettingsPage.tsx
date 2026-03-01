import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { Settings } from "lucide-react";

export default function SettingsPage() {
  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-1">Settings</h1>
      <p className="text-muted-foreground text-sm mb-8">Workspace configuration and preferences.</p>
      <Card className="p-12 flex flex-col items-center gap-4 text-center">
        <Settings className="h-12 w-12 text-muted-foreground/40" />
        <p className="text-muted-foreground">Settings coming soon.</p>
      </Card>
    </div>
  );
}
