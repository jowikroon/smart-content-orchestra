import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { FlaskConical, TrendingUp, Brain, FileBarChart } from "lucide-react";

const sections = [
  { icon: FlaskConical, title: "A/B Testing", description: "Compare content variants and measure impact." },
  { icon: TrendingUp, title: "Conversion Analytics", description: "Track ROI and conversion metrics across channels." },
  { icon: Brain, title: "AI Performance Reports", description: "Evaluate AI generation quality over time." },
  { icon: FileBarChart, title: "Custom Reports", description: "Build and export tailored reports." },
];

export default function InsightsPage() {
  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-1">Insights</h1>
      <p className="text-muted-foreground text-sm mb-8">Performance analytics and content intelligence.</p>
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
