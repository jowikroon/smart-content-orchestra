import Breadcrumbs from "@/components/app/Breadcrumbs";
import { Outlet, useLocation } from "react-router-dom";
import ContentGeneration from "@/pages/ContentGeneration";

export default function CreatePage() {
  const location = useLocation();
  const isIndex = location.pathname.endsWith("/create");

  if (!isIndex) return <><Breadcrumbs /><Outlet /></>;

  return (
    <div>
      <Breadcrumbs />
      <ContentGeneration />
    </div>
  );
}
