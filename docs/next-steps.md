# What's Next — Top 10 Highest-Impact Steps

After the Information Architecture is in place, these are the recommended next steps in priority order:

## 1. Auto-create default workspace on signup
After onboarding completes, automatically create the user's first workspace and redirect them into it. Eliminates friction for new users.

## 2. Scope generated_content and publications to workspaces
Add a `workspace_id` column to `generated_content` and `publications` tables. Update RLS policies to be workspace-scoped. This is foundational for multi-tenant data isolation.

## 3. Build the Brands CRUD
Implement brand creation, listing, and detail views. Brands define voice profiles, rules, and templates that feed into content generation.

## 4. Build the Projects CRUD
Projects organize content under brands. Implement create/list/detail with the tab structure (overview, assets, publishing queue, history).

## 5. Integrate Content Generation into workspace context
Update `ContentGeneration.tsx` to save content scoped to the current workspace and optionally to a brand/project. Wire up the Library page to display workspace assets.

## 6. Implement real publishing channels
Connect Bol.com and Amazon APIs via backend functions. The Publish section should allow selecting content, choosing a channel, and tracking job status.

## 7. Member invitations and role management
Implement invite-by-email for workspace members. Add role-based access control using a `user_roles` table with security definer functions.

## 8. Build the Insights dashboard
Aggregate content performance metrics (views, conversions, CTR) from marketplace APIs. Display in the Insights page with charts (recharts is already installed).

## 9. Implement Billing & Usage with Stripe
Integrate Stripe for subscription management. Track usage (API calls, content generations) against plan limits.

## 10. Public marketing pages
Fill in the marketing stubs (Product, Solutions, Pricing, Case Studies, Blog, About) with real content, copy, and design to drive conversions.
