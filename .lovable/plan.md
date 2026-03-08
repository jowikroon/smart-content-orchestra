

# App Pages Export for Claude Desktop

I have thoroughly reviewed every page behind the login wall. Here is the plan:

**Create a single file `docs/app-pages-export.md`** containing a comprehensive specification of every authenticated page in the application. This document will cover:

- **Routing structure** (all `/app/*` routes)
- **Shared infrastructure** (AppShell, Sidebar, Breadcrumbs, CommandPalette, UserMenu, WorkspaceSwitcher, RequireAuth, useWorkspace hook)
- **Every page** with: title, subtitle, route, layout description, UI elements, icons used, data sources, working functionality vs stub status
- **Database schema** for tables used (brands, generated_content, publications, workspaces, workspace_members, profiles)
- **Edge function** (generate-content) specification
- **Auth flow** (AuthPage, ResetPasswordPage, Google OAuth)
- **Onboarding flow** (4-step wizard)

The document explicitly notes: **Do NOT modify any public/marketing pages or the homepage. Only recreate the authenticated app pages.**

Pages covered (30+ pages):
1. **Auth** - AuthPage, ResetPasswordPage
2. **Onboarding** - 4-step wizard (Product, Audience, Voice, Goals)
3. **App Entry** - redirect logic
4. **Workspaces** - list + create
5. **Overview** - stats row, quick actions, activity feed
6. **Brands** - list, create form, detail page with 4 tabs (Overview, Voice, Rules, Templates)
7. **Projects** - list + stub sub-sections
8. **Create** - AI content generation (working, streams from edge function)
9. **Library** - 4 sub-section cards (stub)
10. **Publish** - working publishing flow + capability cards
11. **Insights** - 4 sub-section cards (stub)
12. **Logs** - stub
13. **AI Hub** - 4 sub-section cards (stub)
14. **Integrations** - index with 3 sub-routes (Connectors, Webhooks, API Keys)
15. **Members** - 2 sub-section cards (stub)
16. **Roles** - stub
17. **Billing** - 3 sub-section cards (stub)
18. **Audit Log** - 3 sub-section cards (stub)
19. **Settings** - 4 sub-section cards (stub)
20. **Usage** - stub
21. **Profile Settings** - working form (display name, avatar URL)
22. **Help, Changelog, Status** - stubs
23. **Sub-pages**: CreateBulk, CreateTemplates, AssetDetail, PublishJob, PublishChannels, ChannelDetail, ProjectNew, ProjectDetail

## Files to Create
- `docs/app-pages-export.md` — single comprehensive export file

## Files to Edit
None. This is a documentation-only output.

