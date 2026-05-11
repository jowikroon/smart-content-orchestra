import { Button } from "@/components/ui/button";
import { ArrowRight, BarChart3, Bot, Globe, ShieldCheck, Sparkles, Store, Workflow, Zap } from "lucide-react";
import { Link } from "react-router-dom";
import { motion } from "framer-motion";
import heroVisual from "@/assets/hero-visual.png";

const features = [
  {
    icon: Bot,
    title: "AI Content Studio",
    description: "Generate product listings, SEO descriptions, ad copy, and A+ modules tuned to your audience and brand voice.",
  },
  {
    icon: Store,
    title: "Template Marketplace",
    description: "Launch with proven playbooks for Amazon, Bol, Etsy, Shopify, and more with reusable templates.",
  },
  {
    icon: Globe,
    title: "Multi-Channel Publishing",
    description: "Coordinate publishing workflows across marketplaces, storefronts, and social channels from one command center.",
  },
  {
    icon: BarChart3,
    title: "Revenue Intelligence",
    description: "Track conversion lift, listing performance, and growth opportunities with actionable analytics.",
  },
  {
    icon: Workflow,
    title: "Ops Automation",
    description: "Automate QA checks, approvals, localization, and publish queues for faster catalog operations.",
  },
  {
    icon: ShieldCheck,
    title: "Team & Workspace Security",
    description: "Workspace-scoped permissions and audit-friendly workflows for agencies and multi-brand teams.",
  },
];

const workflowSteps = [
  {
    title: "1. Pick a growth template",
    description: "Start from conversion-focused templates and presets aligned to your marketplace motion.",
  },
  {
    title: "2. Generate and refine",
    description: "Use objective + creativity controls to produce on-brand copy in minutes.",
  },
  {
    title: "3. Publish and optimize",
    description: "Push content live, monitor outcomes, and iterate with measurable feedback loops.",
  },
];

const pricingPlans = [
  {
    name: "Starter",
    price: "€49",
    period: "/month",
    description: "For solo sellers shipping consistently",
    features: ["50 generations/month", "1 workspace", "Marketplace presets", "Email support"],
    cta: "Start Free Trial",
    highlight: false,
  },
  {
    name: "Growth",
    price: "€149",
    period: "/month",
    description: "For teams scaling catalogs and channels",
    features: ["Unlimited generations", "3 workspaces", "Automation workflows", "Advanced analytics", "Priority support"],
    cta: "Start Free Trial",
    highlight: true,
  },
  {
    name: "Enterprise",
    price: "Custom",
    period: "",
    description: "For agencies and enterprise commerce ops",
    features: ["Everything in Growth", "SSO + governance", "Custom integrations", "Dedicated success manager"],
    cta: "Contact Sales",
    highlight: false,
  },
];

const fadeUp = {
  hidden: { opacity: 0, y: 24 },
  visible: (i: number) => ({
    opacity: 1,
    y: 0,
    transition: { delay: i * 0.1, duration: 0.5, ease: "easeOut" as const },
  }),
};

export default function LandingPage() {
  return (
    <>
      <section className="relative pt-16 pb-20 overflow-hidden">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top,hsl(142_70%_49%/0.12),transparent_60%)]" />
        <div className="container mx-auto px-6 relative">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7 }}
            className="max-w-4xl mx-auto text-center"
          >
            <div className="inline-flex items-center gap-2 rounded-full border border-primary/20 bg-primary/5 px-4 py-1.5 text-sm text-primary mb-8">
              <Sparkles className="h-3.5 w-3.5" />
              AI Commerce OS for Template-Driven Growth
            </div>
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold leading-[1.05] mb-6">
              Build bestselling
              <br />
              <span className="text-gradient">ecommerce experiences at scale</span>
            </h1>
            <p className="text-lg text-muted-foreground max-w-2xl mx-auto mb-10">
              Create standout product content, deploy across channels, and orchestrate your full marketplace lifecycle from one SaaS backend.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link to="/auth?tab=signup">
                <Button size="lg" className="gap-2 px-8">
                  Start Free Trial <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
              <a href="#workflow">
                <Button variant="outline" size="lg" className="px-8">
                  See Workflow
                </Button>
              </a>
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 40 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.3 }}
            className="mt-16 max-w-5xl mx-auto"
          >
            <div className="rounded-xl border border-border overflow-hidden shadow-2xl">
              <img src={heroVisual} alt="Commerce orchestration dashboard" className="w-full" />
            </div>
          </motion.div>
        </div>
      </section>

      <section id="features" className="py-24">
        <div className="container mx-auto px-6">
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true, margin: "-100px" }} className="text-center mb-16">
            <motion.h2 variants={fadeUp} custom={0} className="text-3xl font-bold mb-4">
              Everything needed to scale your <span className="text-gradient">template marketplace engine</span>
            </motion.h2>
            <motion.p variants={fadeUp} custom={1} className="text-muted-foreground max-w-xl mx-auto">
              Move from idea to conversion with generation, governance, publishing, and optimization in one unified stack.
            </motion.p>
          </motion.div>
          <motion.div initial="hidden" whileInView="visible" viewport={{ once: true, margin: "-50px" }} className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {features.map((f, i) => (
              <motion.div key={f.title} variants={fadeUp} custom={i + 2} className="group rounded-xl border border-border bg-card p-6 hover:border-primary/30 transition-colors">
                <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center mb-4 group-hover:bg-primary/20 transition-colors">
                  <f.icon className="h-5 w-5 text-primary" />
                </div>
                <h3 className="font-semibold mb-2">{f.title}</h3>
                <p className="text-sm text-muted-foreground leading-relaxed">{f.description}</p>
              </motion.div>
            ))}
          </motion.div>
        </div>
      </section>

      <section id="workflow" className="py-24 bg-muted/30">
        <div className="container mx-auto px-6 max-w-5xl">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold mb-4">How it works</h2>
            <p className="text-muted-foreground">A simple three-step flow designed for speed and repeatable outcomes.</p>
          </div>
          <div className="grid md:grid-cols-3 gap-6">
            {workflowSteps.map((step) => (
              <div key={step.title} className="rounded-xl border border-border bg-card p-6">
                <div className="inline-flex h-8 w-8 items-center justify-center rounded-full bg-primary/10 text-primary mb-3">
                  <Zap className="h-4 w-4" />
                </div>
                <h3 className="font-semibold mb-2">{step.title}</h3>
                <p className="text-sm text-muted-foreground">{step.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      <section id="pricing" className="py-24">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold mb-4">Simple pricing for every growth stage</h2>
            <p className="text-muted-foreground">Start free. Scale when your catalog and channels grow.</p>
          </div>
          <div className="grid md:grid-cols-3 gap-6 max-w-5xl mx-auto">
            {pricingPlans.map((plan) => (
              <div key={plan.name} className={`rounded-xl border p-8 flex flex-col ${plan.highlight ? "border-primary/40 bg-card glow-border" : "border-border bg-card"}`}>
                {plan.highlight && <span className="text-xs font-medium text-primary mb-4">Most Popular</span>}
                <h3 className="text-lg font-semibold">{plan.name}</h3>
                <p className="text-sm text-muted-foreground mt-1 mb-6">{plan.description}</p>
                <div className="mb-6">
                  <span className="text-4xl font-bold">{plan.price}</span>
                  <span className="text-muted-foreground">{plan.period}</span>
                </div>
                <ul className="space-y-3 mb-8 flex-1">
                  {plan.features.map((feat) => (
                    <li key={feat} className="flex items-center gap-2 text-sm text-muted-foreground">
                      <div className="h-1.5 w-1.5 rounded-full bg-primary" />
                      {feat}
                    </li>
                  ))}
                </ul>
                <Link to="/auth?tab=signup">
                  <Button variant={plan.highlight ? "default" : "outline"} className="w-full">
                    {plan.cta}
                  </Button>
                </Link>
              </div>
            ))}
          </div>
        </div>
      </section>
    </>
  );
}
