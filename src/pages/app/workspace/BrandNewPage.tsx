import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { Tag } from "lucide-react";

export default function BrandNewPage() {
  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-2">Create Brand</h1>
      <p className="text-muted-foreground mb-8">Set up a new brand identity.</p>
      <Card className="p-12 flex flex-col items-center gap-4 text-center">
        <Tag className="h-12 w-12 text-muted-foreground/40" />
        <p className="text-muted-foreground">Brand creation form coming soon.</p>
      </Card>
    </div>
  );
}
