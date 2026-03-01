

# Elevate Smart Content Orchestra: Enhanced IA and UX

## Summary
Add the **AI Hub** section, a **Command Palette** (Cmd+K), and upgrade all stub pages from bare placeholders to structured sub-section cards that preview the platform's depth. No new backend tables needed -- this is purely front-end scaffolding.

## Changes

### 1. AI Hub (new route + sidebar item)
- **New file**: `src/pages/app/workspace/AIHubPage.tsx` with sub-section cards: Multi-Modal Generators, Marketplace API Browser, Custom Model Training, Experimentation Sandbox
- **Route**: `/app/workspace/:workspaceId/ai-hub` added to `App.tsx`
- **Sidebar**: Add "AI Hub" with `Brain` icon between Insights and Integrations in `AppSidebar.tsx`
- **Breadcrumbs**: Add `"ai-hub": "AI Hub"` to `labelMap`

### 2. Command Palette (Cmd+K)
- **New file**: `src/components/app/CommandPalette.tsx` using the already-installed `cmdk` library
- Provides quick-jump to any section (Overview, Brands, Projects, Create, Library, Publish, Insights, AI Hub, Integrations, Members, Settings, etc.)
- Renders inside `AppShell.tsx`, triggered by Cmd+K / Ctrl+K
- Uses the existing `CommandDialog` from `src/components/ui/command.tsx`

### 3. Enhanced Overview Page
Upgrade from 3 simple cards to a richer command center:
- **Stats row**: 4 metric cards (Total Assets, Active Projects, Pending Publishes, AI Credits Used) with placeholder values
- **Quick Actions**: Existing cards (Create, Publish, Library)
- **Activity Feed**: Empty state card with "Recent activity will appear here"

### 4. Richer Stub Pages
Upgrade each stub from a single "coming soon" card to a grid of sub-section preview cards that describe planned capabilities. Pages affected:

| Page | Sub-section cards |
|------|-------------------|
| **Brands** | Keep existing layout, add "Competitor Intelligence" card |
| **Projects** | Add sub-section hints: Kanban Boards, Version Timeline |
| **Library** | Add cards: Approved Content, Drafts, Media Gallery, Metadata Tags |
| **Publish** | Add cards: Scheduling Queue, Approval Workflows, Preview Simulator |
| **Insights** | Add cards: A/B Testing, Conversion Analytics, AI Reports, Custom Reports |
| **Integrations** | Already has sub-section cards -- no change |
| **Members** | Add cards: Invite Users, Role Assignments |
| **Billing** | Add cards: Plan Overview, Invoice History, Credit Usage |
| **Audit Log** | Add cards: Activity Logs, Security Settings, Compliance |
| **Settings** | Add cards: Workspace Preferences, Notifications, Data Export, API Docs |

Each card shows an icon, title, and one-line description. All remain non-functional stubs.

### 5. Sidebar "Logs" link
Currently missing from sidebar. Add `Logs` under Insights with `ScrollText` icon as a sub-item, or add it to the primary nav.

## Files to Create
- `src/pages/app/workspace/AIHubPage.tsx`
- `src/components/app/CommandPalette.tsx`

## Files to Edit
- `src/App.tsx` -- add AI Hub route
- `src/components/app/AppSidebar.tsx` -- add AI Hub nav item + Logs
- `src/components/app/Breadcrumbs.tsx` -- add `ai-hub` and `logs` to labelMap
- `src/components/layouts/AppShell.tsx` -- render CommandPalette
- `src/pages/app/workspace/OverviewPage.tsx` -- stats + activity feed
- `src/pages/app/workspace/LibraryPage.tsx` -- sub-section cards
- `src/pages/app/workspace/InsightsPage.tsx` -- sub-section cards
- `src/pages/app/workspace/MembersPage.tsx` -- sub-section cards
- `src/pages/app/workspace/BillingPage.tsx` -- sub-section cards
- `src/pages/app/workspace/AuditLogPage.tsx` -- sub-section cards
- `src/pages/app/workspace/SettingsPage.tsx` -- sub-section cards
- `src/pages/app/workspace/PublishPage.tsx` -- sub-section cards when at index

## Technical Notes
- `cmdk` is already installed (v1.1.1) and `src/components/ui/command.tsx` wraps it with shadcn styling
- No new dependencies needed
- No database changes needed
- All new content is static placeholder UI -- no API calls added
- The Command Palette uses `useNavigate` to jump to workspace-scoped routes based on `currentWorkspace.id`

