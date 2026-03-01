

# Add User Menu to App Header

## Overview
Add a user avatar + name dropdown in the top-right corner of the app header, with profile link, settings, and logout. The user's display name and avatar come from the existing `profiles` table (which already has `display_name` and `avatar_url` columns).

## Changes

### 1. Create UserMenu component
**New file**: `src/components/app/UserMenu.tsx`

- Fetches the current user's profile (`display_name`, `avatar_url`) from the `profiles` table on mount
- Renders an Avatar (with image or initials fallback) + display name (or email fallback)
- Uses shadcn `DropdownMenu` with items:
  - **Profile Settings** -- navigates to `/app/settings/profile`
  - **Help** -- navigates to `/app/help`
  - Separator
  - **Log Out** -- calls `supabase.auth.signOut()` and navigates to `/`
- Subscribes to `onAuthStateChange` so the avatar updates if the user re-authenticates

### 2. Update AppShell header
**Edit**: `src/components/layouts/AppShell.tsx`

- Import and render `<UserMenu />` in the header, pushed to the right with `ml-auto`
- The header becomes: `SidebarTrigger | Logo | Divider | WorkspaceSwitcher | ... spacer ... | UserMenu`

### 3. Enhance ProfileSettingsPage
**Edit**: `src/pages/app/ProfileSettingsPage.tsx`

- Replace the "coming soon" stub with a working form
- Fields: Display Name, Avatar URL (text input for now)
- Loads current profile on mount, saves via `supabase.from('profiles').update()`
- Success toast on save

## Technical Notes
- No database changes needed -- `profiles.display_name` and `profiles.avatar_url` already exist
- No new dependencies -- uses existing shadcn Avatar, DropdownMenu components
- The user object is available from `supabase.auth.getUser()` (already used elsewhere)
- Persistent login is already handled by `RequireAuth` + Supabase's `persistSession: true` config
