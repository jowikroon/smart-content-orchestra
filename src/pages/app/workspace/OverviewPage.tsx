import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";
import { useWorkspace } from "@/hooks/use-workspace";
import { Zap, FileText, Send } from "lucide-react";

export default function OverviewPage() {
  const { currentWorkspace } = useWorkspace();

  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-2">Welcome back</h1>
      <p className="text-muted-foreground mb-8">
        {currentWorkspace ? `Workspace: ${currentWorkspace.name}` : "Your dashboard overview."}
      </p>
      <div className="grid md:grid-cols-3 gap-6">
        <Card className="p-6 flex flex-col items-center text-center gap-3">
          <Zap className="h-8 w-8 text-primary" />
          <h3 className="font-semibold">Quick Start</h3>
          <p className="text-sm text-muted-foreground">Generate your first product content.</p>
          <Link to="../create">
            <Button size="sm" className="gap-2"><FileText className="h-4 w-4" /> Create Content</Button>
          </Link>
        </Card>
        <Card className="p-6 flex flex-col items-center text-center gap-3">
          <Send className="h-8 w-8 text-primary" />
          <h3 className="font-semibold">Publish</h3>
          <p className="text-sm text-muted-foreground">Push content to your marketplaces.</p>
          <Link to="../publish">
            <Button size="sm" variant="outline">Go to Publishing</Button>
          </Link>
        </Card>
        <Card className="p-6 flex flex-col items-center text-center gap-3">
          <FileText className="h-8 w-8 text-primary" />
          <h3 className="font-semibold">Library</h3>
          <p className="text-sm text-muted-foreground">Browse your generated assets.</p>
          <Link to="../library">
            <Button size="sm" variant="outline">View Library</Button>
          </Link>
        </Card>
      </div>
    </div>
  );
}
