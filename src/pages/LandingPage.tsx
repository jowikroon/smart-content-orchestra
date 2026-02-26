import { useState } from "react";
import { Button } from "@/components/ui/button";
import { ArrowRight, BarChart3, Bot, Globe, Zap, Menu, X } from "lucide-react";
import { Link } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import heroVisual from "@/assets/hero-visual.png";

const features = [
  {
    icon: Bot,
    title: "AI Content Generation",
    description: "Generate high-converting product listings, A+ content, and campaigns with specialized AI agents.",
  },
  {
    icon: Globe,
    title: "Multi-Platform Publishing",
    description: "One-click publishing to Amazon, Bol.com, and your custom storefronts.",
  },
  {
    icon: BarChart3,
    title: "Performance Analytics",
    description: "Track conversions, SEO rankings, and sales with an AI-powered optimization dashboard.",
  },
  {
    icon: Zap,
    title: "Automated Orchestration",
    description: "A/B testing, content refinement, and publishing workflows — fully automated.",
  },
];

const pricingPlans = [
  {
    name: "Starter",
    price: "€49",
    period: "/month",
    description: "For individual sellers getting started",
    features: ["5 product listings/month", "1 marketplace", "Basic analytics", "Email support"],
    cta: "Start Free Trial",
    highlight: false,
  },
  {
    name: "Growth",
    price: "€149",
    period: "/month",
    description: "For scaling e-commerce brands",
    features: ["Unlimited listings", "3 marketplaces", "Advanced analytics", "A/B testing", "Priority support"],
    cta: "Start Free Trial",
    highlight: true,
  },
  {
    name: "Enterprise",
    price: "Custom",
    period: "",
    description: "For large teams and agencies",
    features: ["Everything in Growth", "Unlimited marketplaces", "Custom AI training", "Dedicated account manager", "SLA guarantee"],
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
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  return (
    <div className="min-h-screen bg-background">
      {/* Nav */}
      <nav className="fixed top-0 left-0 right-0 z-50 glass">
        <div className="container mx-auto flex h-16 items-center justify-between px-6">
          <Link to="/" className="text-lg font-bold tracking-tight">
            marketplace<span className="text-gradient">growth</span>.nl
          </Link>
          <div className="hidden md:flex items-center gap-8 text-sm text-muted-foreground">
            <a href="#features" className="hover:text-foreground transition-colors">Features</a>
            <a href="#pricing" className="hover:text-foreground transition-colors">Pricing</a>
          </div>
          <div className="flex items-center gap-3">
            <Link to="/auth" className="hidden sm:inline-flex">
              <Button variant="ghost" size="sm">Log in</Button>
            </Link>
            <Link to="/auth?tab=signup" className="hidden sm:inline-flex">
              <Button size="sm">Get Started</Button>
            </Link>
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="md:hidden text-muted-foreground hover:text-foreground transition-colors"
              aria-label="Toggle menu"
            >
              {mobileMenuOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
            </button>
          </div>
        </div>

        {/* Mobile menu */}
        <AnimatePresence>
          {mobileMenuOpen && (
            <motion.div
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: "auto", opacity: 1 }}
              exit={{ height: 0, opacity: 0 }}
              transition={{ duration: 0.2 }}
              className="md:hidden border-t border-border overflow-hidden"
            >
              <div className="container mx-auto px-6 py-4 flex flex-col gap-3">
                <a
                  href="#features"
                  onClick={() => setMobileMenuOpen(false)}
                  className="text-sm text-muted-foreground hover:text-foreground transition-colors py-2"
                >
                  Features
                </a>
                <a
                  href="#pricing"
                  onClick={() => setMobileMenuOpen(false)}
                  className="text-sm text-muted-foreground hover:text-foreground transition-colors py-2"
                >
                  Pricing
                </a>
                <div className="flex gap-3 pt-2 border-t border-border">
                  <Link to="/auth" className="flex-1">
                    <Button variant="outline" size="sm" className="w-full">Log in</Button>
                  </Link>
                  <Link to="/auth?tab=signup" className="flex-1">
                    <Button size="sm" className="w-full">Get Started</Button>
                  </Link>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </nav>

      {/* Hero */}
      <section className="relative pt-32 pb-20 overflow-hidden">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top,hsl(142_70%_49%/0.08),transparent_60%)]" />
        <div className="container mx-auto px-6 relative">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7 }}
            className="max-w-3xl mx-auto text-center"
          >
            <div className="inline-flex items-center gap-2 rounded-full border border-primary/20 bg-primary/5 px-4 py-1.5 text-sm text-primary mb-8">
              <Zap className="h-3.5 w-3.5" />
              AI-Powered Marketplace Growth
            </div>
            <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold leading-[1.1] mb-6">
              Turn products into
              <br />
              <span className="text-gradient">profit machines</span>
            </h1>
            <p className="text-lg text-muted-foreground max-w-xl mx-auto mb-10">
              Generate high-converting content, publish to every marketplace, and optimize performance — all with sovereign AI that keeps your data yours.
            </p>
            <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
              <Link to="/auth?tab=signup">
                <Button size="lg" className="gap-2 px-8">
                  Start Free Trial <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
              <a href="#features">
                <Button variant="outline" size="lg" className="px-8">
                  See How It Works
                </Button>
              </a>
            </div>
          </motion.div>

          {/* Hero image */}
          <motion.div
            initial={{ opacity: 0, y: 40 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8, delay: 0.3 }}
            className="mt-16 max-w-4xl mx-auto"
          >
            <div className="rounded-xl border border-border overflow-hidden shadow-2xl">
              <img src={heroVisual} alt="Marketplace growth dashboard" className="w-full" />
            </div>
          </motion.div>
        </div>
      </section>

      {/* Features */}
      <section id="features" className="py-24">
        <div className="container mx-auto px-6">
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true, margin: "-100px" }}
            className="text-center mb-16"
          >
            <motion.h2 variants={fadeUp} custom={0} className="text-3xl font-bold mb-4">
              Everything you need to <span className="text-gradient">dominate</span> marketplaces
            </motion.h2>
            <motion.p variants={fadeUp} custom={1} className="text-muted-foreground max-w-lg mx-auto">
              From content creation to performance tracking — one platform to rule your e-commerce empire.
            </motion.p>
          </motion.div>
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true, margin: "-50px" }}
            className="grid md:grid-cols-2 lg:grid-cols-4 gap-6"
          >
            {features.map((f, i) => (
              <motion.div
                key={f.title}
                variants={fadeUp}
                custom={i + 2}
                className="group rounded-xl border border-border bg-card p-6 hover:border-primary/30 transition-colors"
              >
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

      {/* Pricing */}
      <section id="pricing" className="py-24 bg-muted/30">
        <div className="container mx-auto px-6">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold mb-4">Simple, transparent pricing</h2>
            <p className="text-muted-foreground">Start free. Scale as you grow.</p>
          </div>
          <div className="grid md:grid-cols-3 gap-6 max-w-5xl mx-auto">
            {pricingPlans.map((plan) => (
              <div
                key={plan.name}
                className={`rounded-xl border p-8 flex flex-col ${
                  plan.highlight
                    ? "border-primary/40 bg-card glow-border"
                    : "border-border bg-card"
                }`}
              >
                {plan.highlight && (
                  <span className="text-xs font-medium text-primary mb-4">Most Popular</span>
                )}
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
                  <Button
                    variant={plan.highlight ? "default" : "outline"}
                    className="w-full"
                  >
                    {plan.cta}
                  </Button>
                </Link>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-border py-12">
        <div className="container mx-auto px-6 flex flex-col md:flex-row items-center justify-between gap-4">
          <span className="text-sm text-muted-foreground">
            © 2026 marketplacegrowth.nl — All rights reserved.
          </span>
          <div className="flex items-center gap-6 text-sm text-muted-foreground">
            <a href="#" className="hover:text-foreground transition-colors">Privacy</a>
            <a href="#" className="hover:text-foreground transition-colors">Terms</a>
            <a href="#" className="hover:text-foreground transition-colors">Contact</a>
          </div>
        </div>
      </footer>
    </div>
  );
}
