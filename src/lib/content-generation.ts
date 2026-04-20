export type ContentType = "product_listing" | "a_plus_content" | "seo_description" | "social_ad";

export type GenerationPreset = {
  id: string;
  label: string;
  objective: string;
  brandVoice: string;
  marketplace: string;
  targetAudience: string;
  features: string[];
};

export const CONTENT_TYPES: { value: ContentType; label: string; desc: string }[] = [
  { value: "product_listing", label: "Product Listing", desc: "Title, bullets, description, keywords" },
  { value: "a_plus_content", label: "A+ Content", desc: "Brand story, feature modules, comparison" },
  { value: "seo_description", label: "SEO Description", desc: "Meta tags, long description, keywords" },
  { value: "social_ad", label: "Social Ad Copy", desc: "Headlines, ad text, CTA suggestions" },
];

export const GENERATION_PRESETS: GenerationPreset[] = [
  {
    id: "amazon-launch",
    label: "Amazon Launch Sprint",
    objective: "Maximize click-through and conversion during first 30 days",
    brandVoice: "Confident, benefit-first, premium",
    marketplace: "Amazon",
    targetAudience: "Busy professionals who value reliability and speed",
    features: ["Fast setup", "Long-lasting materials", "Gift-ready packaging"],
  },
  {
    id: "etsy-story",
    label: "Etsy Story Seller",
    objective: "Highlight craftsmanship and emotional storytelling",
    brandVoice: "Warm, artisanal, authentic",
    marketplace: "Etsy",
    targetAudience: "Design-conscious buyers looking for meaningful gifts",
    features: ["Hand-finished details", "Sustainable sourcing", "Personalization options"],
  },
  {
    id: "d2c-growth",
    label: "D2C Growth Booster",
    objective: "Increase repeat purchase intent and branded search",
    brandVoice: "Energetic, modern, transparent",
    marketplace: "Shopify",
    targetAudience: "Gen Z and millennials comparing value and social proof",
    features: ["Subscription discount", "Community driven", "Satisfaction guarantee"],
  },
];

export const MARKETPLACE_OPTIONS = ["Amazon", "Bol", "Etsy", "Shopify", "eBay", "Walmart", "Generic"];

export const BRAND_VOICE_OPTIONS = [
  "Professional",
  "Premium",
  "Playful",
  "Technical",
  "Minimalist",
  "Bold",
  "Friendly",
];

export function dedupeAndLimitFeatures(features: string[], max = 10): string[] {
  const seen = new Set<string>();
  const cleaned: string[] = [];

  for (const feature of features) {
    const normalized = feature.trim();
    const key = normalized.toLowerCase();
    if (!normalized || seen.has(key)) continue;
    seen.add(key);
    cleaned.push(normalized);
    if (cleaned.length >= max) break;
  }

  return cleaned;
}

export function normalizeCreativeLevel(value: number): number {
  if (Number.isNaN(value)) return 3;
  return Math.min(5, Math.max(1, Math.round(value)));
}
