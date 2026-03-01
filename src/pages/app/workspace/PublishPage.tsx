import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Outlet, useLocation } from "react-router-dom";
import PublishingPage from "@/pages/PublishingPage";

export default function PublishPage() {
  const location = useLocation();
  const isIndex = location.pathname.endsWith("/publish");

  if (!isIndex) return <><Breadcrumbs /><Outlet /></>;

  return (
    <div>
      <Breadcrumbs />
      <PublishingPage />
    </div>
  );
}
