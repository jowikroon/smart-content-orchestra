import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { CheckCircle2, FileEdit, Image, Tags } from "lucide-react";

const sections = [
  { icon: CheckCircle2, title: "Approved Content", description: "Final, approved assets ready for publishing." },
  { icon: FileEdit, title: "Drafts", description: "Work-in-progress content and iterations." },
  { icon: Image, title: "Media Gallery", description: "Images, videos, and other rich media." },
  { icon: Tags, title: "Metadata Tags", description: "Organize assets with custom tags and categories." },
];

export default function LibraryPage() {
  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-1">Library</h1>
      <p className="text-muted-foreground text-sm mb-8">Browse and manage all your generated assets.</p>
      <div className="grid sm:grid-cols-2 gap-4">
        {sections.map((s) => (
          <Card key={s.title} className="p-6 flex items-start gap-4">
            <s.icon className="h-8 w-8 text-primary shrink-0 mt-0.5" />
            <div>
              <h3 className="font-semibold mb-1">{s.title}</h3>
              <p className="text-sm text-muted-foreground">{s.description}</p>
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}
