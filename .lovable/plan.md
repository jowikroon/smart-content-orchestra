

# Improve Authentication: Forgot Password Flow and Google Login

## Problem
The current auth page has no "Forgot password" option, and the user reports that KeePassXC (a password manager) doesn't work well with Google OAuth login, so they need a reliable email/password alternative with full password reset capability.

## Changes

### 1. Add "Forgot Password" link to the login form
- Add a "Forgot password?" link below the password field on the login view
- Clicking it shows an inline forgot-password form (email input + submit) that calls `supabase.auth.resetPasswordForEmail()` with `redirectTo` pointing to `/reset-password`

### 2. Create a `/reset-password` page
- New file: `src/pages/ResetPasswordPage.tsx`
- Detects the `type=recovery` token in the URL hash (Supabase redirects here after the user clicks the reset email link)
- Shows a "Set new password" form with password + confirm password fields
- Calls `supabase.auth.updateUser({ password })` to save the new password
- On success, redirects to `/dashboard`

### 3. Register the new route
- Add `<Route path="/reset-password" element={<ResetPasswordPage />} />` in `App.tsx`

### 4. Improve Google login UX
- Add a loading state to the Google button so users get feedback when clicked
- Add `prompt: "select_account"` to the Google OAuth params so users can pick which Google account to use (helpful for password managers and multi-account setups)

## Technical Details

- The forgot password form will be a state toggle within `AuthPage.tsx` (login view -> forgot password view) to keep a single page
- The reset password page will listen for `onAuthStateChange` with `PASSWORD_RECOVERY` event to detect when the recovery token is processed
- All styling will match the existing auth page design (same branding panel, same layout)
- No database changes needed -- this uses built-in authentication features

