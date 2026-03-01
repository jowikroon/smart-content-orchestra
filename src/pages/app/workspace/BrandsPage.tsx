import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";
import { Tag, Plus } from "lucide-react";

export default function BrandsPage() {
  return (
    <div>
      <Breadcrumbs />
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold mb-1">Brands</h1>
          <p className="text-muted-foreground text-sm">Manage your brand identities and voice profiles.</p>
        </div>
        <Link to="new">
          <Button size="sm" className="gap-2"><Plus className="h-4 w-4" /> New Brand</Button>
        </Link>
      </div>
      <Card className="p-12 flex flex-col items-center gap-4 text-center">
        <Tag className="h-12 w-12 text-muted-foreground/40" />
        <p className="text-muted-foreground">No brands yet. Create your first brand to get started.</p>
      </Card>
    </div>
  );
}
