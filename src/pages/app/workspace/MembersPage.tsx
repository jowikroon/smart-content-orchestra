import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { Users } from "lucide-react";

export default function MembersPage() {
  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-1">Members</h1>
      <p className="text-muted-foreground text-sm mb-8">Manage workspace members and invitations.</p>
      <Card className="p-12 flex flex-col items-center gap-4 text-center">
        <Users className="h-12 w-12 text-muted-foreground/40" />
        <p className="text-muted-foreground">Member management coming soon.</p>
      </Card>
    </div>
  );
}
