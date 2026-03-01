

# SaaS Information Architecture for Marketplacegrowth.nl

## Overview

Restructure the entire app from a flat `/dashboard` layout into a scalable workspace-scoped IA with public marketing pages, an auth-guarded app shell, and workspace-aware routing.

## Current State

- Flat routing: `/`, `/auth`, `/dashboard`, `/dashboard/*`
- Dashboard.tsx is a monolith: sidebar + auth guard + content rendering all in one file
- No workspace concept in DB or UI
- Existing pages: LandingPage, AuthPage, OnboardingPage, ResetPasswordPage, Dashboard (with ContentGeneration and PublishingPage inline)
- DB tables: profiles, generated_content, publications (no workspaces table)

## Database Change

Create a `workspaces` table with minimal fields and a `workspace_members` join table:

```sql
CREATE TABLE public.workspaces (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz DEFAULT now(),
  created_by uuid NOT NULL
);

CREATE TABLE public.workspace_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid REFERENCES public.workspaces(id) ON DELETE CASCADE,
  user_id uuid NOT NULL,
  role text DEFAULT 'owner',
  created_at timestamptz DEFAULT now(),
  UNIQUE(workspace_id, user_id)
);

ALTER TABLE public.workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their workspaces"
  ON public.workspaces FOR SELECT
  USING (id IN (SELECT workspace_id FROM public.workspace_members WHERE user_id = auth.uid()));

CREATE POLICY "Users can create workspaces"
  ON public.workspaces FOR INSERT
  WITH CHECK (created_by = auth.uid());

CREATE POLICY "Members can view membership"
  ON public.workspace_members FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Workspace creators can add members"
  ON public.workspace_members FOR INSERT
  WITH CHECK (user_id = auth.uid());
```

## Folder Structure

```text
src/
  components/
    layouts/
      AppShell.tsx           -- Sidebar + header + outlet for /app routes
      PublicLayout.tsx        -- Marketing nav + footer wrapper
    app/
      AppSidebar.tsx          -- Primary sidebar navigation
      WorkspaceSwitcher.tsx   -- Dropdown to switch/create workspaces
      Breadcrumbs.tsx         -- Workspace > Section > Detail
    ui/                       -- (existing shadcn components)
    NavLink.tsx               -- (existing)
  hooks/
    use-workspace.tsx         -- Context: current workspace, list, switch, persist
  pages/
    public/
      HomePage.tsx            -- Current LandingPage (moved)
      ProductPage.tsx         -- Stub
      SolutionsPage.tsx       -- Stub (with children: Amazon, Bol, Multi)
      PricingPage.tsx         -- Stub (extract from LandingPage)
      CaseStudiesPage.tsx     -- Stub
      BlogPage.tsx            -- Stub
      AboutPage.tsx           -- Stub
      SecurityPage.tsx        -- Stub
      DocsPage.tsx            -- Stub
      ContactPage.tsx         -- Stub
    auth/
      AuthPage.tsx            -- (existing, update redirect to /app)
      ResetPasswordPage.tsx   -- (existing)
    app/
      AppEntryPage.tsx        -- /app: redirect to last workspace or onboarding
      OnboardingPage.tsx      -- /app/onboarding (move existing)
      WorkspacesPage.tsx      -- /app/workspaces: list + create
      workspace/
        OverviewPage.tsx
        BrandsPage.tsx
        BrandDetailPage.tsx   -- Tabs: overview, voice, rules, templates, assets, publish-settings
        ProjectsPage.tsx
        ProjectDetailPage.tsx -- Tabs: overview, assets, publishing-queue, history
        CreatePage.tsx        -- With sub-routes: bulk, templates
        LibraryPage.tsx
        AssetDetailPage.tsx   -- Tabs: versions, comments, export, publish
        PublishPage.tsx        -- With sub-routes: jobs/:jobId, channels/*
        InsightsPage.tsx
        LogsPage.tsx
        IntegrationsPage.tsx  -- With sub-routes: connectors, webhooks, api-keys
        MembersPage.tsx
        RolesPage.tsx
        BillingPage.tsx
        UsagePage.tsx
        AuditLogPage.tsx
        SettingsPage.tsx
      HelpPage.tsx
      ChangelogPage.tsx
      StatusPage.tsx
      ProfileSettingsPage.tsx
  docs/
    next-steps.md
```

## Implementation Steps

### A. Routing (src/App.tsx)

Replace the current flat routes with a nested structure:

1. **Public routes** wrapped in `PublicLayout`:
   - `/` (HomePage), `/product`, `/solutions/*`, `/pricing`, `/case-studies`, `/blog`, `/about`, `/security`, `/docs`, `/contact`
   - `/login` and `/signup` redirect to `/auth` and `/auth?tab=signup`

2. **Auth routes** (no layout wrapper):
   - `/auth`, `/reset-password`

3. **App routes** wrapped in auth guard + `AppShell`:
   - `/app` -- AppEntryPage (redirect logic)
   - `/app/onboarding`
   - `/app/workspaces`
   - `/app/workspace/:workspaceId/*` -- nested workspace routes
   - `/app/help`, `/app/changelog`, `/app/status`, `/app/settings/profile`

4. **Catch-all** `*` -- NotFound

### B. Auth Guard

Create a `RequireAuth` wrapper component that:
- Checks `supabase.auth.getSession()` on mount
- Listens to `onAuthStateChange`
- Redirects to `/auth` if not authenticated
- Renders `<Outlet />` if authenticated
- Extracts this logic from the current Dashboard.tsx monolith

### C. AppShell Layout

`src/components/layouts/AppShell.tsx`:
- Uses shadcn `SidebarProvider` + `Sidebar` (already installed)
- Left sidebar with `AppSidebar` component
- Header with `SidebarTrigger`, `WorkspaceSwitcher`, user menu
- `<Outlet />` for page content
- Responsive: mobile sheet sidebar, desktop fixed sidebar

### D. AppSidebar

Primary nav items (scoped to current workspace):
- Overview, Brands, Projects, Create, Library, Publish, Insights, Integrations

Secondary section (bottom):
- Members and Roles, Billing and Usage, Audit Log, Settings, Support link

Uses `NavLink` component for active state highlighting.

### E. Workspace Context

`src/hooks/use-workspace.tsx`:
- React context providing: `workspaces`, `currentWorkspace`, `switchWorkspace`, `createWorkspace`, `loading`
- Fetches workspaces from DB via `workspace_members` join
- Persists last selected workspace ID in `localStorage`
- If no workspaces exist, signals redirect to workspace creation

### F. WorkspaceSwitcher

Dropdown (shadcn `DropdownMenu`) showing:
- Current workspace name
- List of other workspaces
- "Create workspace" option
- Selecting a workspace navigates to `/app/workspace/:id/overview`

### G. Stub Pages

Each stub page will follow a consistent pattern:
- Page title as `h1`
- Short description paragraph
- Empty state card with icon and "Coming soon" or relevant placeholder
- Tabs component where applicable (BrandDetailPage, ProjectDetailPage, AssetDetailPage)
- Breadcrumbs at the top

### H. Migration of Existing Features

- `ContentGeneration.tsx` moves to become the content of `CreatePage.tsx`
- `PublishingPage.tsx` moves to become the content of `PublishPage.tsx`
- `Dashboard.tsx` overview content moves to `OverviewPage.tsx`
- `LandingPage.tsx` becomes `HomePage.tsx` in `pages/public/`
- Auth redirect targets change from `/dashboard` to `/app`

### I. PublicLayout

Simple wrapper with:
- Marketing navigation bar (Product, Solutions, Pricing, Case Studies, Blog, About)
- Login / Get Started buttons
- Footer
- Extracted from current LandingPage nav/footer pattern

### J. docs/next-steps.md

Document listing the top 10 highest-impact steps after IA is in place.

## Technical Details

- Total new files: ~35 stub pages + 5 layout/component files + 1 hook + 1 doc
- No new npm dependencies required
- All routing uses react-router-dom v6 nested routes with `<Outlet />`
- Workspace ID validation in routes via the workspace context (redirect to `/app/workspaces` if invalid)
- Existing `profiles` table and onboarding flow remain unchanged
- The `onboarding_completed` check moves from Dashboard into `AppEntryPage` redirect logic

