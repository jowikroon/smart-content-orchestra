

# Fix Google Login Redirect and Test Auth Flows

## Problem
Two issues with the current authentication:
1. **Google login gets stuck on loading spinner** -- After the Google OAuth redirect completes and returns to `/auth`, the page has no `onAuthStateChange` listener to detect the new session and redirect to the dashboard. The spinner just keeps spinning.
2. **Console warning** -- React Router tries to pass a ref to `AuthPage` (a plain function component), causing a "Function components cannot be given refs" warning.

## Changes

### 1. Add auth state listener to AuthPage
Add a `useEffect` with `supabase.auth.onAuthStateChange` that:
- Detects `SIGNED_IN` events (which fire after Google OAuth completes)
- Redirects authenticated users to `/dashboard`
- Also handles the case where the user navigates to `/auth` while already logged in

This is the core fix for the "Google login keeps loading" issue. When the OAuth flow redirects back, the auth state change fires `SIGNED_IN`, and the listener navigates to `/dashboard`.

### 2. Reset Google loading state on mount
Add logic to reset `googleLoading` to `false` when the component mounts, so if the user returns to the auth page after a failed OAuth attempt, they don't see a stale spinner.

### 3. Test forgot password flow
After fixing the Google login, manually verify:
- Clicking "Forgot password?" shows the email-only form
- Submitting an email calls the reset password API
- The `/reset-password` page renders correctly

## Technical Details

The key addition to `AuthPage.tsx`:

```typescript
useEffect(() => {
  const { data: { subscription } } = supabase.auth.onAuthStateChange(
    (event, session) => {
      if (event === "SIGNED_IN" && session) {
        navigate("/dashboard");
      }
    }
  );
  // Also check if already logged in
  supabase.auth.getSession().then(({ data: { session } }) => {
    if (session) navigate("/dashboard");
  });
  return () => subscription.unsubscribe();
}, [navigate]);
```

**Important**: The `onAuthStateChange` subscription is set up BEFORE the `getSession()` call, following best practices to avoid race conditions.

### Files to modify
- `src/pages/AuthPage.tsx` -- Add auth state listener and session check

