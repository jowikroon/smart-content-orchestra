# App Pages Export — marketplacegrowth.nl

> **IMPORTANT**: Do NOT modify any public/marketing pages, the homepage, or any content visible before logging in. Only recreate the authenticated app pages described below.

---

## Table of Contents

1. [Tech Stack & Dependencies](#tech-stack--dependencies)
2. [Database Schema](#database-schema)
3. [Edge Functions](#edge-functions)
4. [Auth Flow](#auth-flow)
5. [Shared Infrastructure](#shared-infrastructure)
6. [Routing Structure](#routing-structure)
7. [Pages Reference](#pages-reference)

---

## Tech Stack & Dependencies

- **Framework**: React 18 + TypeScript + Vite
- **Styling**: Tailwind CSS with semantic design tokens (HSL in `index.css`), `tailwindcss-animate`
- **UI Library**: shadcn/ui (all components in `src/components/ui/`)
- **State**: React Context (`useWorkspace`), `@tanstack/react-query`
- **Routing**: `react-router-dom` v6
- **Backend**: Supabase (auth, database, edge functions)
- **OAuth**: `@lovable.dev/cloud-auth-js` for Google OAuth
- **Animation**: `framer-motion`
- **Icons**: `lucide-react`
- **Notifications**: `sonner` (toast)

---

## Database Schema

### Table: `profiles`
Auto-created on signup via `handle_new_user()` trigger.

| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| id | uuid | No | gen_random_uuid() |
| user_id | uuid | No | — |
| display_name | text | Yes | — |
| avatar_url | text | Yes | — |
| product_name | text | Yes | — |
| product_description | text | Yes | — |
| product_features | text[] | Yes | — |
| product_category | text | Yes | — |
| target_personas | text[] | Yes | — |
| target_age_range | text | Yes | — |
| target_markets | text[] | Yes | — |
| brand_voice | text | Yes | — |
| brand_tone_keywords | text[] | Yes | — |
| brand_language | text | Yes | 'en' |
| desired_outcomes | text[] | Yes | — |
| primary_marketplace | text | Yes | — |
| onboarding_completed | boolean | No | false |
| created_at | timestamptz | No | now() |
| updated_at | timestamptz | No | now() |

**RLS**: Users can SELECT/INSERT/UPDATE their own profile (auth.uid() = user_id). No DELETE.

### Table: `workspaces`

| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| id | uuid | No | gen_random_uuid() |
| name | text | No | — |
| created_by | uuid | No | — |
| created_at | timestamptz | Yes | now() |

**RLS**: Creators can view (created_by = auth.uid()). Members can view (id in workspace_members). Users can insert (created_by = auth.uid()). No UPDATE/DELETE.

### Table: `workspace_members`

| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| id | uuid | No | gen_random_uuid() |
| workspace_id | uuid | No | FK → workspaces.id |
| user_id | uuid | No | — |
| role | text | No | 'owner' |
| created_at | timestamptz | Yes | now() |

**RLS**: Members can view their own membership (user_id = auth.uid()). Users can insert (user_id = auth.uid()). No UPDATE/DELETE.

### Table: `brands`

| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| id | uuid | No | gen_random_uuid() |
| workspace_id | uuid | No | FK → workspaces.id |
| created_by | uuid | No | — |
| name | text | No | — |
| description | text | Yes | — |
| logo_url | text | Yes | — |
| voice_tone | text | Yes | — |
| voice_personality | text | Yes | — |
| voice_language | text | Yes | 'en' |
| voice_keywords | text[] | Yes | — |
| voice_examples | text | Yes | — |
| rules_dos | text[] | Yes | — |
| rules_donts | text[] | Yes | — |
| rules_grammar_notes | text | Yes | — |
| templates | jsonb | Yes | '[]' |
| created_at | timestamptz | No | now() |
| updated_at | timestamptz | No | now() |

**RLS**: All CRUD restricted to workspace members via `is_workspace_member(auth.uid(), workspace_id)`. INSERT also requires `auth.uid() = created_by`.

### Table: `generated_content`

| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| id | uuid | No | gen_random_uuid() |
| user_id | uuid | No | — |
| workspace_id | uuid | Yes | FK → workspaces.id |
| content_type | text | No | — |
| product_name | text | No | — |
| product_description | text | Yes | — |
| product_features | text[] | Yes | — |
| target_audience | text | Yes | — |
| brand_voice | text | Yes | — |
| marketplace | text | Yes | — |
| content | text | No | — |
| created_at | timestamptz | No | now() |

**RLS**: INSERT/DELETE require `auth.uid() = user_id AND is_workspace_member()`. SELECT requires `is_workspace_member()`. No UPDATE policy.

### Table: `publications`

| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| id | uuid | No | gen_random_uuid() |
| content_id | uuid | No | FK → generated_content.id |
| user_id | uuid | No | — |
| workspace_id | uuid | Yes | FK → workspaces.id |
| marketplace | text | No | — |
| status | text | No | 'draft' |
| published_at | timestamptz | Yes | — |
| created_at | timestamptz | No | now() |
| updated_at | timestamptz | No | now() |

**RLS**: All CRUD restricted to `auth.uid() = user_id AND is_workspace_member()`. SELECT only requires membership.

### Database Functions

```sql
-- Check workspace membership (used in RLS policies)
CREATE OR REPLACE FUNCTION public.is_workspace_member(_user_id uuid, _workspace_id uuid)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path TO 'public'
AS $$ SELECT EXISTS (SELECT 1 FROM public.workspace_members WHERE user_id = _user_id AND workspace_id = _workspace_id) $$;

-- Auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path TO 'public'
AS $$ BEGIN INSERT INTO public.profiles (user_id) VALUES (NEW.id); RETURN NEW; END; $$;

-- Auto-update updated_at columns
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS trigger LANGUAGE plpgsql SET search_path TO 'public'
AS $$ BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;
```

The `handle_new_user` trigger fires on `auth.users` INSERT.

---

## Edge Functions

### `generate-content`
- **Path**: `supabase/functions/generate-content/index.ts`
- **JWT verification**: Disabled (`verify_jwt = false` in config.toml)
- **Method**: POST
- **CORS**: Allows all origins
- **Input JSON**:
  ```json
  {
    "contentType": "product_listing" | "a_plus_content" | "seo_description" | "social_ad",
    "productName": "string",
    "productDescription": "string",
    "productFeatures": ["string"],
    "targetAudience": "string",
    "brandVoice": "string",
    "marketplace": "string"
  }
  ```
- **Behavior**: Calls Lovable AI gateway (`https://ai.gateway.lovable.dev/v1/chat/completions`) with `google/gemini-3-flash-preview` model, streaming SSE response. Uses `LOVABLE_API_KEY` secret.
- **Content type prompts**: 4 different system prompts based on `contentType`:
  - `product_listing`: Title, 5 bullets, description, keywords
  - `a_plus_content`: Brand story, 3 feature modules, comparison chart, closing
  - `seo_description`: Meta title/desc, long description, 10-15 keywords, category tags
  - `social_ad`: 3 headlines, 3 primary texts, long-form copy, CTAs, targeting
- **Error handling**: 429 → rate limit message, 402 → credits message, other → generic error
- **Output**: Streams SSE `text/event-stream` directly from AI gateway

---

## Auth Flow

### AuthPage (`/auth`)
- **File**: `src/pages/AuthPage.tsx`
- **Layout**: Full-screen split. Left half: dark branding panel with logo + tagline (hidden on mobile). Right half: form.
- **States**: Login (default), Sign Up (via `?tab=signup`), Forgot Password
- **Logo text**: `marketplace` + `growth` (with `.text-gradient` class) + `.nl`
- **Login form**: Email + Password inputs, "Forgot password?" link, Submit button
- **Sign Up form**: Email + Password, "Create Account" button. Shows "Check your email to confirm" toast.
- **Forgot Password**: Email only, sends reset link via `supabase.auth.resetPasswordForEmail()`, redirects to `/reset-password`
- **Google OAuth**: Button below separator ("OR"). Uses `lovable.auth.signInWithOAuth("google")` from `@lovable.dev/cloud-auth-js`. Displays Google SVG icon.
- **Auto-redirect**: If already logged in, redirects to `/app`
- **Toggle**: "Don't have an account? Sign up" / "Already have an account? Log in"
- **Back link**: Arrow + "Back" → links to `/`
- **Icons used**: `ArrowLeft`, `Loader2` from lucide

### ResetPasswordPage (`/reset-password`)
- **File**: `src/pages/ResetPasswordPage.tsx`
- **Layout**: Same split layout as AuthPage
- **Behavior**: Listens for `PASSWORD_RECOVERY` auth event. Shows spinner until verified. Then shows new password + confirm password form.
- **Validation**: Passwords must match, min 6 chars
- **On success**: Calls `supabase.auth.updateUser({ password })`, navigates to `/dashboard` (legacy, should be `/app`)
- **Icons**: `ArrowLeft`, `Loader2`, `CheckCircle`

### RequireAuth Wrapper
- **File**: `src/components/layouts/RequireAuth.tsx`
- **Behavior**: Wraps all `/app/*` routes. Checks `supabase.auth.getSession()` and subscribes to `onAuthStateChange`. Redirects to `/auth` if no session. Shows spinner while loading.
- **Outlet context**: Passes `{ user }` via React Router outlet context.

---

## Shared Infrastructure

### AppShell (`src/components/layouts/AppShell.tsx`)
- **Layout**: Full-width flex row. Left: collapsible sidebar. Right: header + main content.
- **Header** (h-14, border-bottom):
  - `SidebarTrigger` (hamburger icon)
  - Logo: `marketplace` + `growth` (.text-gradient) + `.nl` — links to `/`
  - Vertical divider (h-5 w-px bg-border)
  - `<WorkspaceSwitcher />`
  - Right-aligned: `<UserMenu />`
- **Main**: `flex-1 overflow-auto p-6`, renders `<Outlet />`
- **CommandPalette**: Rendered at bottom (always mounted)
- **Providers**: `WorkspaceProvider` > `SidebarProvider`

### AppSidebar (`src/components/app/AppSidebar.tsx`)
- **Component**: shadcn `<Sidebar collapsible="icon">`
- **Primary nav group** ("Navigation"):
  - Overview (LayoutDashboard)
  - Brands (Tag)
  - Projects (FolderKanban)
  - Create (Sparkles)
  - Library (Library)
  - Publish (Send)
  - Insights (BarChart3)
  - Logs (ScrollText)
  - AI Hub (Brain)
  - Integrations (Plug)
- **Utility nav group** ("Workspace"):
  - Members (Users)
  - Roles (Shield)
  - Billing (CreditCard)
  - Audit Log (Activity)
  - Settings (Settings)
- **Footer**:
  - Help & Support (HelpCircle) → `/app/help`
  - Log out button (LogOut) → calls `supabase.auth.signOut()`
- **Links**: Uses custom `<NavLink>` component with `activeClassName="bg-sidebar-accent text-sidebar-accent-foreground font-medium"`
- **Collapsed behavior**: Hides label text when `state === "collapsed"`

### NavLink (`src/components/NavLink.tsx`)
- Wraps React Router `<NavLink>` to accept separate `className` and `activeClassName` props using `cn()` utility.

### Breadcrumbs (`src/components/app/Breadcrumbs.tsx`)
- Auto-generates breadcrumbs from URL path segments after `/app/workspace/:id/`
- Uses a `labelMap` to convert URL segments to display names
- First crumb links to workspace overview, last crumb is bold/non-linked
- Chevron separator between crumbs
- Used on most workspace pages (imported at top of each page)

### WorkspaceSwitcher (`src/components/app/WorkspaceSwitcher.tsx`)
- **Trigger**: Ghost button showing Building2 icon + workspace name + chevrons
- **Dropdown**: Lists all workspaces, highlights current. Has "Create workspace" option at bottom.
- **Create dialog**: Modal with text input, creates workspace via `useWorkspace().createWorkspace()`
- **On switch**: Calls `switchWorkspace(id)` and navigates to `/app/workspace/:id/overview`

### UserMenu (`src/components/app/UserMenu.tsx`)
- **Trigger**: Avatar (h-7 w-7) + display name, rounded-full hover:bg-accent
- **Avatar**: Shows `avatar_url` from profiles table, fallback to 2-char initials on primary background
- **Dropdown items**: Profile Settings → `/app/settings/profile`, Help → `/app/help`, separator, Log Out
- **Data**: Fetches from `profiles` table on mount and on auth state change. Falls back to email.

### CommandPalette (`src/components/app/CommandPalette.tsx`)
- **Trigger**: Cmd+K / Ctrl+K keyboard shortcut
- **Component**: shadcn `<CommandDialog>`
- **Items**: All 15 nav items (same as sidebar) + Help & Support
- **On select**: Navigates to `/app/workspace/:id/:segment`
- **Special**: "Help & Support" navigates to `/app/help`

### useWorkspace Hook (`src/hooks/use-workspace.tsx`)
- **Context provider**: `WorkspaceProvider`
- **State**: `workspaces[]`, `currentWorkspace`, `loading`
- **Persistence**: Last workspace ID stored in `localStorage` key `mg_last_workspace_id`
- **Methods**:
  - `switchWorkspace(id)`: Sets current ID + persists to localStorage
  - `createWorkspace(name)`: Inserts workspace, adds creator as "owner" member, refetches list
  - `refetch()`: Re-fetches workspace list
- **Fetches**: `supabase.from("workspaces").select("*").order("created_at", { ascending: true })`

---

## Routing Structure

```
/auth                           → AuthPage (no layout)
/reset-password                 → ResetPasswordPage (no layout)
/login                          → Redirect to /auth
/signup                         → Redirect to /auth?tab=signup
/dashboard                      → Redirect to /app
/dashboard/*                    → Redirect to /app

(RequireAuth wrapper)
  (AppShell layout)
    /app                        → AppEntryPage (redirect logic)
    /app/onboarding             → OnboardingPage
    /app/workspaces             → WorkspacesPage
    
    /app/workspace/:workspaceId/
      overview                  → OverviewPage
      brands                    → BrandsPage
      brands/new                → BrandNewPage
      brands/:brandId           → BrandDetailPage
      projects                  → ProjectsPage
      projects/new              → ProjectNewPage
      projects/:projectId       → ProjectDetailPage
      create                    → CreatePage (index: ContentGeneration)
        create/bulk             → CreateBulkPage
        create/templates        → CreateTemplatesPage
      library                   → LibraryPage
      library/:assetId          → AssetDetailPage
      publish                   → PublishPage (index: PublishingPage)
        publish/jobs/:jobId     → PublishJobPage
        publish/channels        → PublishChannelsPage (index)
          publish/channels/bol      → ChannelDetailPage("Bol.com")
          publish/channels/amazon   → ChannelDetailPage("Amazon")
          publish/channels/shopify  → ChannelDetailPage("Shopify")
      insights                  → InsightsPage
      logs                      → LogsPage
      ai-hub                    → AIHubPage
      integrations              → IntegrationsPage (index)
        integrations/connectors → ConnectorsPage
        integrations/webhooks   → WebhooksPage
        integrations/api-keys   → ApiKeysPage
      members                   → MembersPage
      roles                     → RolesPage
      billing                   → BillingPage
      usage                     → UsagePage
      audit-log                 → AuditLogPage
      settings                  → SettingsPage
    
    /app/help                   → HelpPage
    /app/changelog              → ChangelogPage
    /app/status                 → StatusPage
    /app/settings/profile       → ProfileSettingsPage
```

---

## Pages Reference

### AppEntryPage (`/app`)
- **File**: `src/pages/app/AppEntryPage.tsx`
- **Status**: ✅ Working
- **Purpose**: Redirect hub. Shows spinner while deciding where to send the user.
- **Logic**:
  1. Check if `profiles.onboarding_completed` is false → redirect to `/app/onboarding`
  2. If `currentWorkspace` exists → redirect to its overview
  3. Else if any workspaces exist → redirect to first one's overview
  4. Else → redirect to `/app/workspaces`

---

### OnboardingPage (`/app/onboarding`)
- **File**: `src/pages/OnboardingPage.tsx`
- **Status**: ✅ Working (saves to profiles table)
- **Layout**: Full-screen centered, header with logo, max-w-2xl content
- **4-step wizard** with animated transitions (framer-motion `AnimatePresence`):

**Step 0 — Product** (Package icon):
- Product Name (required, Input, max 100)
- Description (Textarea, max 1000, 4 rows)
- Category (pill selector): Electronics, Fashion & Apparel, Home & Garden, Health & Beauty, Sports & Outdoors, Toys & Games, Food & Beverage, Books & Media, Automotive, Other
- Key Features (tag input with Add button, max 10 tags, Badges with X remove)

**Step 1 — Audience** (Users icon):
- Target Personas (tag input, same pattern as features)
- Age Range (text input, e.g. "25-45")
- Target Markets (multi-select pills): Netherlands, Germany, Belgium, France, UK, USA, Spain, Italy (max 8)

**Step 2 — Voice** (Megaphone icon):
- Brand Voice (required, 2x3 card grid):
  - Professional: "Authoritative, trustworthy, polished"
  - Casual: "Friendly, approachable, conversational"
  - Luxury: "Elegant, refined, exclusive"
  - Playful: "Fun, energetic, youthful"
  - Technical: "Precise, detailed, expert-level"
  - Bold: "Confident, direct, impactful"
- Tone Keywords (multi-select pills, max 5): Trustworthy, Innovative, Eco-friendly, Premium, Value-driven, Minimalist, Adventurous, Caring, Empowering, Authentic
- Primary Content Language (select dropdown): English, Dutch, German, French, Spanish

**Step 3 — Goals** (Target icon):
- Desired Outcomes (required, 1x2 card grid, max 6):
  - Increase Conversions, Improve SEO, Expand Markets, Brand Consistency, Save Time, A/B Testing
- Primary Marketplace (required, pill selector): Amazon, Bol.com, Both, Other / Custom

**Step indicators**: Horizontal pill row with Check icon for completed steps, clickable to go back
**Navigation**: Back / Continue buttons, final step shows "Finish Setup"
**On finish**: Updates profiles table with all data + `onboarding_completed: true`, navigates to `/app`

---

### WorkspacesPage (`/app/workspaces`)
- **File**: `src/pages/app/WorkspacesPage.tsx`
- **Status**: ✅ Working (creates workspaces)
- **Layout**: `max-w-2xl mx-auto`
- **Title**: "Workspaces" / "Manage your workspaces or create a new one."
- **Create form**: Inline Input + "Create" Button (Plus icon). Creates via `useWorkspace().createWorkspace()`
- **Workspace list**: Cards with Building2 icon (h-10 w-10 in primary/10 bg), workspace name, created date. Clickable → navigates to overview.
- **Empty state**: Card with Building2 icon (h-12 w-12, muted) + "No workspaces yet."

---

### OverviewPage (`/app/workspace/:id/overview`)
- **File**: `src/pages/app/workspace/OverviewPage.tsx`
- **Status**: ✅ Working (static data)
- **Title**: "Welcome back" / "Workspace: {name}"
- **Stats row** (4 cards, 2x2 on mobile, 4-col on desktop):
  - Total Assets (Library icon) — "0"
  - Active Projects (FolderKanban) — "0"
  - Pending Publishes (Clock) — "0"
  - AI Credits Used (CreditCard) — "0"
- **Quick Actions** (3 cards, 3-col on desktop):
  - Quick Start (Zap icon): "Generate your first product content." → Button "Create Content" → `../create`
  - Publish (Send): "Push content to your marketplaces." → Button "Go to Publishing" → `../publish`
  - Insights (BarChart3): "View performance analytics." → Button "View Insights" → `../insights`
- **Recent Activity**: Empty card with Clock icon + "Recent activity will appear here."

---

### BrandsPage (`/app/workspace/:id/brands`)
- **File**: `src/pages/app/workspace/BrandsPage.tsx`
- **Status**: ✅ Working (full CRUD via Supabase)
- **Title**: "Brands" / "Manage your brand identities and voice profiles."
- **Header**: Title + "New Brand" button (Plus icon) → links to `new`
- **Loading**: Centered Loader2 spinner
- **Empty state**: Card with Tag icon + "No brands yet."
- **Brand cards** (grid sm:2 lg:3):
  - Brand name (linked to detail page)
  - Description (line-clamp-2)
  - Voice tone Badge
  - Created date
  - Delete button (Trash2, appears on hover, opacity-0 → opacity-100)
- **Data**: Fetches from `brands` table filtered by `workspace_id`

---

### BrandNewPage (`/app/workspace/:id/brands/new`)
- **File**: `src/pages/app/workspace/BrandNewPage.tsx`
- **Status**: ✅ Working (inserts to brands table)
- **Title**: "Create Brand" / "Set up a new brand identity."
- **Form** (Card, max-w-2xl):
  - Brand Name (required)
  - Description (Textarea, 3 rows)
  - Voice Tone + Voice Personality (2-col grid)
  - Create Brand + Cancel buttons
- **On submit**: Inserts to `brands` table with workspace_id, created_by, navigates to brand detail

---

### BrandDetailPage (`/app/workspace/:id/brands/:brandId`)
- **File**: `src/pages/app/workspace/BrandDetailPage.tsx`
- **Status**: ✅ Working (full edit + save + delete)
- **Header**: Brand name + description, Save button (Save icon), Delete button (Trash2, destructive)
- **4 Tabs**:

**Overview tab**: Card with Brand Name input + Description textarea

**Voice tab**: Card with:
- Tone + Personality (2-col)
- Language (text input)
- Keywords (tag input with Badges, Add button)
- Voice Examples (Textarea, 4 rows)

**Rules tab**: Card with:
- Do's (ListEditor component — list of items with X remove + add input)
- Don'ts (same ListEditor)
- Grammar & Style Notes (Textarea, 4 rows)

**Templates tab**:
- List of template cards, each with name Input + content Textarea + delete button
- "Add Template" button (Plus icon)
- Templates stored as JSONB array `[{ id, name, content }]`

**ListEditor** (reusable sub-component): Label, ul of items with X remove, Input + Add button

---

### ProjectsPage (`/app/workspace/:id/projects`)
- **File**: `src/pages/app/workspace/ProjectsPage.tsx`
- **Status**: 🔲 Stub
- **Title**: "Projects" / "Organize work into projects."
- **Header**: Title + "New Project" button → links to `new`
- **Empty state**: Card with FolderKanban icon + "No projects yet."
- **Coming Soon cards** (2-col): Kanban Boards (Kanban icon), Version Timeline (GitBranch)

### ProjectNewPage (`/app/workspace/:id/projects/new`)
- **Status**: 🔲 Stub — "Project creation form coming soon." (FolderKanban icon)

### ProjectDetailPage (`/app/workspace/:id/projects/:projectId`)
- **Status**: 🔲 Stub — Tabs: overview, assets, publishing-queue, history. All show "coming soon."

---

### CreatePage (`/app/workspace/:id/create`)
- **File**: `src/pages/app/workspace/CreatePage.tsx`
- **Status**: ✅ Working (AI content generation with streaming)
- **Layout**: Wrapper with Breadcrumbs. Index renders `<ContentGeneration />`. Sub-routes render `<Outlet />`.

#### ContentGeneration (`src/pages/ContentGeneration.tsx`)
- **Layout**: 2-column (lg:flex-row). Left: input panel (lg:w-[400px]). Right: output panel (flex-1).
- **Title**: "Generate Content" / "Fill in your product details and let AI create optimized content."

**Input panel**:
- Content Type (2x2 grid of selectable cards):
  - Product Listing: "Title, bullets, description, keywords"
  - A+ Content: "Brand story, feature modules, comparison"
  - SEO Description: "Meta tags, long description, keywords"
  - Social Ad Copy: "Headlines, ad text, CTA suggestions"
- Product Name (required, max 100)
- Description (Textarea, max 1000, 3 rows)
- Key Features (tag input, max 10)
- Target Audience (Input, max 100)
- "Generate Content" button (Sparkles icon, full width, lg size)

**Auto-fills** from profiles table on mount: product_name, product_description, product_features, brand_voice, target_personas (joined), primary_marketplace

**Output panel**:
- Header: FileText icon + "Generated Content" label
- Action buttons (shown when content exists & not generating): Regenerate (RotateCcw), Copy (Copy/Check)
- Content area: Rounded-xl border card, min-h-[400px], prose styling, whitespace-pre-wrap
- Empty state: Sparkles icon + "Your AI-generated content will appear here."
- Generating indicator: Pulsing cursor block (w-2 h-5 bg-primary animate-pulse)

**Generation flow**:
1. POST to `${VITE_SUPABASE_URL}/functions/v1/generate-content` with auth header (anon key)
2. Streams SSE response, parses `data: {JSON}` lines
3. Extracts `choices[0].delta.content` and appends to output
4. Auto-scrolls output div during generation
5. On complete: Saves to `generated_content` table with workspace_id

### CreateBulkPage (`/app/workspace/:id/create/bulk`)
- **Status**: 🔲 Stub — "Bulk creation coming soon." (Layers icon)

### CreateTemplatesPage (`/app/workspace/:id/create/templates`)
- **Status**: 🔲 Stub — "Templates coming soon." (LayoutTemplate icon)

---

### LibraryPage (`/app/workspace/:id/library`)
- **File**: `src/pages/app/workspace/LibraryPage.tsx`
- **Status**: 🔲 Stub
- **Title**: "Library" / "Browse and manage all your generated assets."
- **4 cards** (2-col grid):
  - Approved Content (CheckCircle2): "Final, approved assets ready for publishing."
  - Drafts (FileEdit): "Work-in-progress content and iterations."
  - Media Gallery (Image): "Images, videos, and other rich media."
  - Metadata Tags (Tags): "Organize assets with custom tags and categories."

### AssetDetailPage (`/app/workspace/:id/library/:assetId`)
- **Status**: 🔲 Stub — Tabs: versions, comments, export, publish. All "coming soon." Shows Asset ID from URL params.

---

### PublishPage (`/app/workspace/:id/publish`)
- **File**: `src/pages/app/workspace/PublishPage.tsx`
- **Status**: ✅ Working (index shows PublishingPage + capability cards)
- **Index layout**: Breadcrumbs → PublishingPage component → "Capabilities" heading → 3 cards
- **Sub-routes**: Renders Outlet for jobs/channels

#### PublishingPage (`src/pages/PublishingPage.tsx`)
- **Status**: ✅ Working (selects content, publishes to marketplace)
- **Title**: "Publishing" / "Select generated content and publish to your marketplaces."

**Action bar** (shown when content exists):
- Selected count badge
- Marketplace Select dropdown: Amazon, Bol.com, Shopify, Etsy, eBay
- "Publish Selected" button (Send icon)

**Content list** (grid of Cards):
- Each card: Checkbox indicator (custom div), product name, content type Badge, date, content preview (300 chars, line-clamp-3)
- Publication status badges per content item (shows marketplace + status: Draft/Scheduled/Published with icons)
- Delete button (Trash2) per item
- Clickable to toggle selection (ring-1 ring-primary when selected)

**Empty state**: Inbox icon + "No generated content yet. Go to Content to generate product listings first."

**Publish flow**: Inserts to `publications` table with status "published" and current timestamp.

**Capability cards** (3-col):
- Scheduling Queue (CalendarClock)
- Approval Workflows (CheckSquare)
- Preview Simulator (MonitorSmartphone)

### PublishJobPage (`/app/workspace/:id/publish/jobs/:jobId`)
- **Status**: 🔲 Stub — "Job details coming soon." Shows Job ID.

### PublishChannelsPage (`/app/workspace/:id/publish/channels`)
- **Status**: 🔲 Stub
- **Title**: "Channels" / "Manage your marketplace connections."
- **3 cards** (3-col): Bol.com, Amazon, Shopify — each with Globe icon, links to sub-route

### ChannelDetailPage
- **Status**: 🔲 Stub — Takes `name` prop. Shows "{name} Channel" + "Configure your {name} integration." + Globe icon stub.

---

### InsightsPage (`/app/workspace/:id/insights`)
- **Status**: 🔲 Stub
- **Title**: "Insights" / "Performance analytics and content intelligence."
- **4 cards** (2-col):
  - A/B Testing (FlaskConical)
  - Conversion Analytics (TrendingUp)
  - AI Performance Reports (Brain)
  - Custom Reports (FileBarChart)

---

### LogsPage (`/app/workspace/:id/logs`)
- **Status**: 🔲 Stub — "Logs coming soon." (ScrollText icon)

---

### AIHubPage (`/app/workspace/:id/ai-hub`)
- **Status**: 🔲 Stub
- **Title**: "AI Hub" / "Advanced AI tools and experimentation space."
- **4 cards** (2-col):
  - Multi-Modal Generators (Image icon)
  - Marketplace API Browser (Globe)
  - Custom Model Training (Cpu)
  - Experimentation Sandbox (FlaskConical)

---

### IntegrationsPage (`/app/workspace/:id/integrations`)
- **File**: `src/pages/app/workspace/IntegrationsPage.tsx`
- **Status**: 🔲 Stub (index with 3 linked sub-routes)
- **Title**: "Integrations" / "Connect your tools and services."
- **3 cards** (3-col, clickable Links):
  - Connectors (Plug icon) → `connectors`
  - Webhooks (Webhook icon) → `webhooks`
  - API Keys (Key icon) → `api-keys`
- **Sub-route rendering**: If not on index, shows Breadcrumbs + Outlet

### ConnectorsPage
- **Status**: 🔲 Stub — "Connectors coming soon." (Plug icon)

### WebhooksPage
- **Status**: 🔲 Stub — "Webhooks coming soon." (Webhook icon)

### ApiKeysPage
- **Status**: 🔲 Stub — "API key management coming soon (Enterprise)." (Key icon)

---

### MembersPage (`/app/workspace/:id/members`)
- **Status**: 🔲 Stub
- **Title**: "Members" / "Manage workspace members and invitations."
- **2 cards** (2-col):
  - Invite Users (UserPlus)
  - Role Assignments (ShieldCheck)

---

### RolesPage (`/app/workspace/:id/roles`)
- **Status**: 🔲 Stub — "Roles management coming soon." (Shield icon)

---

### BillingPage (`/app/workspace/:id/billing`)
- **Status**: 🔲 Stub
- **Title**: "Billing" / "Manage subscription and payment methods."
- **3 cards** (2-col, lg:3-col):
  - Plan Overview (CreditCard)
  - Invoice History (Receipt)
  - Credit Usage (BarChart3)

---

### UsagePage (`/app/workspace/:id/usage`)
- **Status**: 🔲 Stub — "Usage tracking coming soon." (Activity icon)

---

### AuditLogPage (`/app/workspace/:id/audit-log`)
- **Status**: 🔲 Stub
- **Title**: "Audit Log" / "Track all workspace activity for compliance."
- **3 cards** (2-col, lg:3-col):
  - Activity Logs (ScrollText)
  - Security Settings (ShieldCheck)
  - Compliance (FileCheck)

---

### SettingsPage (`/app/workspace/:id/settings`)
- **Status**: 🔲 Stub
- **Title**: "Settings" / "Workspace configuration and preferences."
- **4 cards** (2-col):
  - Workspace Preferences (Settings icon)
  - Notifications (Bell)
  - Data Export (Download)
  - API Documentation (BookOpen)

---

### ProfileSettingsPage (`/app/settings/profile`)
- **File**: `src/pages/app/ProfileSettingsPage.tsx`
- **Status**: ✅ Working
- **Layout**: `max-w-2xl mx-auto`
- **Title**: "Profile Settings" / "Manage your personal account settings."
- **Content** (Card):
  - Avatar preview (h-16 w-16) with image or initials fallback (bg-primary text-primary-foreground)
  - Display Name input
  - Avatar URL input (text, for pasting URL)
  - "Save Changes" button (right-aligned)
- **Data**: Loads from profiles table, saves via `supabase.from("profiles").update()`

---

### HelpPage (`/app/help`)
- **Status**: 🔲 Stub — "Help center coming soon." (HelpCircle icon)
- **Layout**: `max-w-2xl mx-auto`

### ChangelogPage (`/app/changelog`)
- **Status**: 🔲 Stub — "Changelog coming soon." (Bell icon)
- **Layout**: `max-w-2xl mx-auto`

### StatusPage (`/app/status`)
- **Status**: 🔲 Stub — "Status dashboard coming soon." (Activity icon)
- **Title**: "System Status" / "All systems operational."
- **Layout**: `max-w-2xl mx-auto`

---

## Design Pattern Notes

### Stub page pattern
Most stub pages follow this pattern:
```tsx
import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Card } from "@/components/ui/card";
import { IconName } from "lucide-react";

const sections = [
  { icon: Icon1, title: "Feature", description: "Description." },
];

export default function PageName() {
  return (
    <div>
      <Breadcrumbs />
      <h1 className="text-2xl font-bold mb-1">Title</h1>
      <p className="text-muted-foreground text-sm mb-8">Subtitle.</p>
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
```

### Simple stub (no cards):
```tsx
<Card className="p-12 flex flex-col items-center gap-4 text-center">
  <IconName className="h-12 w-12 text-muted-foreground/40" />
  <p className="text-muted-foreground">Feature coming soon.</p>
</Card>
```

### Card styling conventions
- Icon size in cards: `h-8 w-8 text-primary` (feature cards) or `h-12 w-12 text-muted-foreground/40` (empty states)
- Feature cards: `p-6 flex items-start gap-4`
- Empty state cards: `p-12 flex flex-col items-center gap-4 text-center`

### Color usage
- All colors use semantic tokens: `text-primary`, `text-muted-foreground`, `bg-primary/10`, `border-primary/30`, `bg-card`, `bg-background`, `border-border`, `text-foreground`, `text-destructive`
- Gradient text class: `.text-gradient` (defined in CSS)
- Active nav: `bg-sidebar-accent text-sidebar-accent-foreground`

---

## Design Tokens — index.css

Copy this file as `src/index.css` in the new repo. This is the complete design system.

```css
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap');

@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 220 14% 4%;
    --foreground: 210 20% 95%;

    --card: 220 13% 8%;
    --card-foreground: 210 20% 95%;

    --popover: 220 13% 8%;
    --popover-foreground: 210 20% 95%;

    --primary: 142 70% 49%;
    --primary-foreground: 220 14% 4%;

    --secondary: 220 13% 14%;
    --secondary-foreground: 210 20% 85%;

    --muted: 220 13% 12%;
    --muted-foreground: 215 14% 55%;

    --accent: 220 13% 14%;
    --accent-foreground: 210 20% 90%;

    --destructive: 0 72% 51%;
    --destructive-foreground: 210 40% 98%;

    --border: 220 13% 16%;
    --input: 220 13% 16%;
    --ring: 142 70% 49%;

    --radius: 0.5rem;

    --sidebar-background: 220 14% 6%;
    --sidebar-foreground: 210 20% 85%;
    --sidebar-primary: 142 70% 49%;
    --sidebar-primary-foreground: 220 14% 4%;
    --sidebar-accent: 220 13% 12%;
    --sidebar-accent-foreground: 210 20% 90%;
    --sidebar-border: 220 13% 14%;
    --sidebar-ring: 142 70% 49%;

    /* Custom tokens */
    --gradient-primary: linear-gradient(135deg, hsl(142 70% 49%), hsl(160 70% 40%));
    --gradient-hero: linear-gradient(180deg, hsl(220 14% 4%) 0%, hsl(220 14% 8%) 100%);
    --gradient-card: linear-gradient(135deg, hsl(220 13% 10%), hsl(220 13% 8%));
    --gradient-glow: radial-gradient(600px circle at var(--mouse-x, 50%) var(--mouse-y, 50%), hsl(142 70% 49% / 0.06), transparent 40%);
    --shadow-glow: 0 0 40px -10px hsl(142 70% 49% / 0.3);
    --shadow-card: 0 4px 24px -4px hsl(0 0% 0% / 0.3);
  }

  .dark {
    /* Same as root - dark by default */
  }
}

@layer base {
  * {
    @apply border-border;
  }

  body {
    @apply bg-background text-foreground font-sans antialiased;
  }

  h1, h2, h3, h4, h5, h6 {
    @apply font-semibold tracking-tight;
  }
}

@layer utilities {
  .text-gradient {
    @apply bg-clip-text text-transparent;
    background-image: var(--gradient-primary);
  }

  .glow-border {
    @apply border border-primary/20;
    box-shadow: var(--shadow-glow);
  }

  .glass {
    @apply bg-card/80 backdrop-blur-xl border border-border;
  }
}
```

---

## Tailwind Config — tailwind.config.ts

Copy this file as `tailwind.config.ts` in the new repo.

```ts
import type { Config } from "tailwindcss";

export default {
  darkMode: ["class"],
  content: ["./pages/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}", "./app/**/*.{ts,tsx}", "./src/**/*.{ts,tsx}"],
  prefix: "",
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      fontFamily: {
        sans: ["Inter", "system-ui", "sans-serif"],
        mono: ["JetBrains Mono", "monospace"],
      },
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
        sidebar: {
          DEFAULT: "hsl(var(--sidebar-background))",
          foreground: "hsl(var(--sidebar-foreground))",
          primary: "hsl(var(--sidebar-primary))",
          "primary-foreground": "hsl(var(--sidebar-primary-foreground))",
          accent: "hsl(var(--sidebar-accent))",
          "accent-foreground": "hsl(var(--sidebar-accent-foreground))",
          border: "hsl(var(--sidebar-border))",
          ring: "hsl(var(--sidebar-ring))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: { height: "0" },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: "0" },
        },
        "fade-up": {
          from: { opacity: "0", transform: "translateY(20px)" },
          to: { opacity: "1", transform: "translateY(0)" },
        },
        "fade-in": {
          from: { opacity: "0" },
          to: { opacity: "1" },
        },
        pulse: {
          "0%, 100%": { opacity: "1" },
          "50%": { opacity: "0.5" },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
        "fade-up": "fade-up 0.6s ease-out forwards",
        "fade-in": "fade-in 0.4s ease-out forwards",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
} satisfies Config;
```

### Visual Direction Summary
- **Aesthetic**: Dark premium "Linear-style"
- **Primary accent**: Emerald green (`142 70% 49%`)
- **Background**: Near-black (`220 14% 4%`)
- **Cards**: Slightly lighter dark (`220 13% 8%`)
- **Fonts**: Inter (headings/body), JetBrains Mono (technical/mono)
- **Effects**: Glassmorphism (`.glass`), glow borders (`.glow-border`), gradient text (`.text-gradient`)
- **Dark by default**: No light mode — `:root` IS the dark theme

---

## Project Config Files

### package.json

```json
{
  "name": "vite_react_shadcn_ts",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "build:dev": "vite build --mode development",
    "lint": "eslint .",
    "preview": "vite preview",
    "test": "vitest run",
    "test:watch": "vitest"
  },
  "dependencies": {
    "@hookform/resolvers": "^3.10.0",
    "@lovable.dev/cloud-auth-js": "^0.0.3",
    "@radix-ui/react-accordion": "^1.2.11",
    "@radix-ui/react-alert-dialog": "^1.1.14",
    "@radix-ui/react-aspect-ratio": "^1.1.7",
    "@radix-ui/react-avatar": "^1.1.10",
    "@radix-ui/react-checkbox": "^1.3.2",
    "@radix-ui/react-collapsible": "^1.1.11",
    "@radix-ui/react-context-menu": "^2.2.15",
    "@radix-ui/react-dialog": "^1.1.14",
    "@radix-ui/react-dropdown-menu": "^2.1.15",
    "@radix-ui/react-hover-card": "^1.1.14",
    "@radix-ui/react-label": "^2.1.7",
    "@radix-ui/react-menubar": "^1.1.15",
    "@radix-ui/react-navigation-menu": "^1.2.13",
    "@radix-ui/react-popover": "^1.1.14",
    "@radix-ui/react-progress": "^1.1.7",
    "@radix-ui/react-radio-group": "^1.3.7",
    "@radix-ui/react-scroll-area": "^1.2.9",
    "@radix-ui/react-select": "^2.2.5",
    "@radix-ui/react-separator": "^1.1.7",
    "@radix-ui/react-slider": "^1.3.5",
    "@radix-ui/react-slot": "^1.2.3",
    "@radix-ui/react-switch": "^1.2.5",
    "@radix-ui/react-tabs": "^1.1.12",
    "@radix-ui/react-toast": "^1.2.14",
    "@radix-ui/react-toggle": "^1.1.9",
    "@radix-ui/react-toggle-group": "^1.1.10",
    "@radix-ui/react-tooltip": "^1.2.7",
    "@supabase/supabase-js": "^2.97.0",
    "@tanstack/react-query": "^5.83.0",
    "class-variance-authority": "^0.7.1",
    "clsx": "^2.1.1",
    "cmdk": "^1.1.1",
    "date-fns": "^3.6.0",
    "embla-carousel-react": "^8.6.0",
    "framer-motion": "^12.34.3",
    "input-otp": "^1.4.2",
    "lucide-react": "^0.462.0",
    "next-themes": "^0.3.0",
    "react": "^18.3.1",
    "react-day-picker": "^8.10.1",
    "react-dom": "^18.3.1",
    "react-hook-form": "^7.61.1",
    "react-resizable-panels": "^2.1.9",
    "react-router-dom": "^6.30.1",
    "recharts": "^2.15.4",
    "sonner": "^1.7.4",
    "tailwind-merge": "^2.6.0",
    "tailwindcss-animate": "^1.0.7",
    "vaul": "^0.9.9",
    "zod": "^3.25.76"
  },
  "devDependencies": {
    "@eslint/js": "^9.32.0",
    "@tailwindcss/typography": "^0.5.16",
    "@testing-library/jest-dom": "^6.6.0",
    "@testing-library/react": "^16.0.0",
    "@types/node": "^22.16.5",
    "@types/react": "^18.3.23",
    "@types/react-dom": "^18.3.7",
    "@vitejs/plugin-react-swc": "^3.11.0",
    "autoprefixer": "^10.4.21",
    "eslint": "^9.32.0",
    "eslint-plugin-react-hooks": "^5.2.0",
    "eslint-plugin-react-refresh": "^0.4.20",
    "globals": "^15.15.0",
    "jsdom": "^20.0.3",
    "postcss": "^8.5.6",
    "tailwindcss": "^3.4.17",
    "typescript": "^5.8.3",
    "typescript-eslint": "^8.38.0",
    "vite": "^5.4.19",
    "vitest": "^3.2.4"
  }
}
```

> **Note**: Remove `lovable-tagger` from devDependencies in the new repo — it's Lovable-specific. Also remove `@lovable.dev/cloud-auth-js` if you're not using Lovable Cloud for OAuth; replace the Google OAuth call with your own Supabase OAuth setup.

### components.json (shadcn/ui config)

```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "default",
  "rsc": false,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.ts",
    "css": "src/index.css",
    "baseColor": "slate",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "hooks": "@/hooks"
  }
}
```

### postcss.config.js

```js
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
```

### vite.config.ts

```ts
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";

export default defineConfig(({ mode }) => ({
  server: {
    host: "::",
    port: 8080,
  },
  plugins: [react()],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
}));
```

> **Note**: The `lovable-tagger` plugin and HMR overlay config have been removed — they're Lovable-specific.

### tsconfig.app.json

```json
{
  "compilerOptions": {
    "allowImportingTsExtensions": true,
    "isolatedModules": true,
    "jsx": "react-jsx",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleDetection": "force",
    "moduleResolution": "bundler",
    "noEmit": true,
    "noFallthroughCasesInSwitch": false,
    "noImplicitAny": false,
    "noUnusedLocals": false,
    "noUnusedParameters": false,
    "paths": {
      "@/*": ["./src/*"]
    },
    "skipLibCheck": true,
    "strict": false,
    "target": "ES2020",
    "types": ["vitest/globals"],
    "useDefineForClassFields": true
  },
  "include": ["src"]
}
```

### index.html

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>marketplacegrowth.nl</title>
    <meta name="description" content="Generate high-converting product content, publish to every marketplace, and optimize performance with sovereign AI.">
    <meta name="author" content="marketplacegrowth.nl" />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

### src/main.tsx

```tsx
import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import "./index.css";

createRoot(document.getElementById("root")!).render(<App />);
```

### src/lib/utils.ts

```ts
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

---

## Setup Instructions for New Repo

1. Copy `package.json`, run `npm install` (or `bun install`)
2. Copy config files: `components.json`, `postcss.config.js`, `tailwind.config.ts`, `tsconfig.app.json`, `vite.config.ts`, `index.html`
3. Copy `src/index.css`, `src/main.tsx`, `src/lib/utils.ts`
4. Initialize shadcn/ui: `npx shadcn-ui@latest init` (select existing config) — or copy all `src/components/ui/` files directly
5. Copy `src/App.tsx` routing structure and all page/component files
6. Set up Supabase project with tables and RLS policies from the Database Schema section
7. Deploy the `generate-content` edge function
8. Set environment variables: `VITE_SUPABASE_URL`, `VITE_SUPABASE_PUBLISHABLE_KEY`
9. For Google OAuth: configure via Supabase dashboard or replace `lovable.auth.signInWithOAuth` with `supabase.auth.signInWithOAuth({ provider: 'google' })`
