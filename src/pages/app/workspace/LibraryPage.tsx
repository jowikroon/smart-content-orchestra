import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { Library } from "lucide-react";

export default function LibraryPage() {
  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-1">Library</h1>
      <p className="text-muted-foreground text-sm mb-8">Browse and manage all your generated assets.</p>
      <Card className="p-12 flex flex-col items-center gap-4 text-center">
        <Library className="h-12 w-12 text-muted-foreground/40" />
        <p className="text-muted-foreground">Your content library will appear here.</p>
      </Card>
    </div>
  );
}
