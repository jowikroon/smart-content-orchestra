import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";
import { FolderKanban, Plus } from "lucide-react";

export default function ProjectsPage() {
  return (
    <div>
      <Breadcrumbs />
      <div className="flex items-center justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold mb-1">Projects</h1>
          <p className="text-muted-foreground text-sm">Organize work into projects.</p>
        </div>
        <Link to="new">
          <Button size="sm" className="gap-2"><Plus className="h-4 w-4" /> New Project</Button>
        </Link>
      </div>
      <Card className="p-12 flex flex-col items-center gap-4 text-center">
        <FolderKanban className="h-12 w-12 text-muted-foreground/40" />
        <p className="text-muted-foreground">No projects yet. Create one to start organizing content.</p>
      </Card>
    </div>
  );
}
