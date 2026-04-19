import { useEffect, useMemo, useState } from "react";
import { Link } from "react-router-dom";
import {
  Area,
  AreaChart,
  CartesianGrid,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from "recharts";
import {
  ArrowUpRight,
  BadgeEuro,
  CheckCircle2,
  Clock4,
  Download,
  FileText,
  Gauge,
  RefreshCw,
  Sparkles,
  TrendingUp,
  TriangleAlert,
  UserPlus,
  Wand2,
} from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useWorkspace } from "@/hooks/use-workspace";

/* ------------------------------------------------------------------ */
/*  Design tokens — scoped to this page                               */
/* ------------------------------------------------------------------ */
const tone = {
  page: "bg-[#faf9f6] text-[#0a0a0a]",
  card: "bg-white border border-[#ececea] rounded-xl",
  muted: "text-[#71717a]",
  faint: "text-[#a1a1aa]",
  green: "#16a34a",
  greenSoft: "#22c55e",
  greenTint: "#dcfce7",
  greenInk: "#166534",
  redTint: "#fee2e2",
  redInk: "#991b1b",
  grayTint: "#f4f4f5",
  grayInk: "#52525b",
};

/* ------------------------------------------------------------------ */
/*  Mock data — swap for profit_snapshot / marketplace_fees RPCs      */
/* ------------------------------------------------------------------ */
const buildSeries = (base: number, variance: number, trend: number) =>
  Array.from({ length: 30 }).map((_, i) => {
    const noise = (Math.sin(i * 1.3) + Math.cos(i * 0.7)) * variance;
    return Math.round(base + trend * i + noise);
  });

const revenueSeries = buildSeries(480, 55, 5);
const profitSeries = buildSeries(150, 18, 1.4);

const chartData = revenueSeries.map((r, i) => ({
  day: i + 1,
  Revenue: r,
  Profit: profitSeries[i],
}));

const kpis = [
  {
    label: "Revenue (30d)",
    value: "€18,420",
    delta: "+12.4%",
    icon: BadgeEuro,
    series: revenueSeries.slice(-16),
  },
  {
    label: "Gross Profit",
    value: "€6,127",
    delta: "+8.1%",
    icon: TrendingUp,
    series: profitSeries.slice(-16),
  },
  {
    label: "Listings",
    value: "312",
    delta: "24 new",
    icon: FileText,
    series: buildSeries(280, 12, 1).slice(-16),
  },
  {
    label: "Avg Quality",
    value: "87",
    delta: "+3 pts",
    icon: Gauge,
    series: buildSeries(80, 4, 0.25).slice(-16),
  },
];

const topSkus = [
  { code: "BRK-001", name: "ABS Brake Pad Set", profit: 597.05, pct: 92 },
  { code: "BRK-002", name: "ABS Brake Disc", profit: 548.56, pct: 84 },
  { code: "LED-099", name: "LED Headlight H7", profit: 425.16, pct: 66 },
  { code: "SPK-033", name: "Spark Plug Iridium", profit: 348.41, pct: 54 },
];

const activity = [
  {
    icon: CheckCircle2,
    iconColor: tone.green,
    iconBg: tone.greenTint,
    title: "8 listings published to Amazon DE",
    meta: "2 minutes ago · BRK-001  +7",
  },
  {
    icon: Sparkles,
    iconColor: "#7c3aed",
    iconBg: "#ede9fe",
    title: "Content Builder generated 12 titles",
    meta: "14 minutes ago",
  },
  {
    icon: TriangleAlert,
    iconColor: "#d97706",
    iconBg: "#fef3c7",
    title: "Bol.com sync: 2 SKUs rejected (missing EAN)",
    meta: "1 hour ago",
  },
  {
    icon: RefreshCw,
    iconColor: "#2563eb",
    iconBg: "#dbeafe",
    title: "Amazon fee refresh completed",
    meta: "3 hours ago",
  },
  {
    icon: UserPlus,
    iconColor: "#0f766e",
    iconBg: "#ccfbf1",
    title: "Lisa joined the workspace",
    meta: "Yesterday",
  },
];

type MarketplaceStatus = "synced" | "errors" | "disconnected";
const marketplaces: {
  code: string;
  name: string;
  region: string;
  sync: string;
  status: MarketplaceStatus;
  errors?: number;
}[] = [
  { code: "Az", name: "Amazon", region: "DE", sync: "Just now", status: "synced" },
  { code: "Az", name: "Amazon", region: "NL", sync: "12m ago", status: "synced" },
  { code: "Bc", name: "Bol.com", region: "NL", sync: "2h ago", status: "errors", errors: 2 },
  { code: "Sh", name: "Shopify", region: "", sync: "—", status: "disconnected" },
];

/* ------------------------------------------------------------------ */
/*  Helpers                                                           */
/* ------------------------------------------------------------------ */
function greet() {
  const h = new Date().getHours();
  if (h < 12) return "Good morning";
  if (h < 18) return "Good afternoon";
  return "Good evening";
}

/* Minimal sparkline for KPI cards */
function Sparkbars({ values, color = tone.green }: { values: number[]; color?: string }) {
  const max = Math.max(...values);
  const min = Math.min(...values);
  const range = max - min || 1;
  return (
    <div className="flex items-end gap-[2px] h-7 w-full">
      {values.map((v, i) => {
        const h = 6 + ((v - min) / range) * 22;
        return (
          <div
            key={i}
            className="flex-1 rounded-[1px]"
            style={{
              height: `${h}px`,
              background: color,
              opacity: 0.35 + (i / values.length) * 0.65,
            }}
          />
        );
      })}
    </div>
  );
}

function StatusChip({ status, errors }: { status: MarketplaceStatus; errors?: number }) {
  if (status === "synced") {
    return (
      <span
        className="text-xs font-medium px-2.5 py-1 rounded-full"
        style={{ background: tone.greenTint, color: tone.greenInk }}
      >
        Synced
      </span>
    );
  }
  if (status === "errors") {
    return (
      <span
        className="text-xs font-medium px-2.5 py-1 rounded-full"
        style={{ background: tone.redTint, color: tone.redInk }}
      >
        {errors} errors
      </span>
    );
  }
  return (
    <span
      className="text-xs font-medium px-2.5 py-1 rounded-full"
      style={{ background: tone.grayTint, color: tone.grayInk }}
    >
      Not connected
    </span>
  );
}

function Toggle({
  options,
  value,
  onChange,
}: {
  options: string[];
  value: string;
  onChange: (v: string) => void;
}) {
  return (
    <div className="inline-flex items-center rounded-full bg-[#f4f4f5] p-1 text-xs">
      {options.map((o) => {
        const active = o === value;
        return (
          <button
            key={o}
            onClick={() => onChange(o)}
            className={`px-3 py-1 rounded-full transition-all ${
              active
                ? "bg-[#0a0a0a] text-white shadow-sm"
                : "text-[#52525b] hover:text-[#0a0a0a]"
            }`}
          >
            {o}
          </button>
        );
      })}
    </div>
  );
}

/* ------------------------------------------------------------------ */
/*  Page                                                              */
/* ------------------------------------------------------------------ */
export default function OverviewPage() {
  const { currentWorkspace } = useWorkspace();
  const [displayName, setDisplayName] = useState<string>("");
  const [range, setRange] = useState("30d");

  useEffect(() => {
    (async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) return;
      const { data } = await supabase
        .from("profiles")
        .select("display_name")
        .eq("user_id", user.id)
        .single();
      const raw =
        data?.display_name?.split(" ")[0] ??
        user.email?.split("@")[0]?.replace(/[^a-z]/gi, "") ??
        "";
      setDisplayName(raw.charAt(0).toUpperCase() + raw.slice(1));
    })();
  }, []);

  const greeting = useMemo(() => greet(), []);
  const workspaceName = currentWorkspace?.name ?? "Your workspace";

  return (
    <div className={`${tone.page} -m-6 p-6 min-h-[calc(100vh-3.5rem)]`}>
      {/* Header */}
      <div className="flex flex-wrap items-start justify-between gap-4 mb-8">
        <div>
          <p className="text-xs font-medium text-[#52525b] mb-1">{workspaceName}</p>
          <h1 className="text-[28px] font-semibold tracking-tight leading-tight">
            {greeting}
            {displayName ? `, ${displayName}` : ""}
          </h1>
          <p className={`${tone.muted} text-sm mt-1`}>
            Here's what's happening across your marketplaces today.
          </p>
        </div>

        <div className="flex items-center gap-2">
          <button className="inline-flex items-center gap-2 text-sm font-medium px-3.5 py-2 rounded-lg bg-white border border-[#ececea] hover:bg-[#fafafa] transition-colors">
            <Download className="h-4 w-4" />
            Export
          </button>
          <Link
            to="../create"
            className="inline-flex items-center gap-2 text-sm font-medium px-3.5 py-2 rounded-lg text-white shadow-sm hover:brightness-110 transition-all"
            style={{ background: tone.green }}
          >
            <Wand2 className="h-4 w-4" />
            Generate listings
          </Link>
        </div>
      </div>

      {/* KPI row */}
      <div className="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4 mb-6">
        {kpis.map((k) => (
          <div key={k.label} className={`${tone.card} p-5`}>
            <div className="flex items-center justify-between mb-3">
              <p className="text-[11px] font-medium uppercase tracking-wider text-[#71717a]">
                {k.label}
              </p>
              <div
                className="h-7 w-7 rounded-full flex items-center justify-center"
                style={{ background: tone.grayTint }}
              >
                <k.icon className="h-3.5 w-3.5 text-[#52525b]" />
              </div>
            </div>
            <p className="text-[28px] font-semibold leading-none tracking-tight">{k.value}</p>
            <div className="flex items-end justify-between gap-3 mt-3">
              <div
                className="inline-flex items-center gap-1 text-xs font-medium"
                style={{ color: tone.greenInk }}
              >
                <ArrowUpRight className="h-3 w-3" />
                {k.delta}
              </div>
              <div className="w-[60%]">
                <Sparkbars values={k.series} />
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Chart + Top SKUs */}
      <div className="grid grid-cols-1 xl:grid-cols-3 gap-4 mb-6">
        <div className={`${tone.card} p-5 xl:col-span-2`}>
          <div className="flex items-start justify-between mb-4">
            <div>
              <h2 className="text-sm font-semibold">Revenue vs profit — last 30 days</h2>
              <p className={`${tone.faint} text-xs mt-0.5`}>Amazon DE, Bol.com NL</p>
            </div>
            <Toggle options={["30d", "90d", "YTD"]} value={range} onChange={setRange} />
          </div>

          <div className="h-[240px] -mx-2">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={chartData} margin={{ top: 6, right: 12, left: 0, bottom: 0 }}>
                <defs>
                  <linearGradient id="revFill" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor={tone.greenSoft} stopOpacity={0.25} />
                    <stop offset="100%" stopColor={tone.greenSoft} stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid stroke="#f0f0ee" strokeDasharray="3 3" vertical={false} />
                <XAxis dataKey="day" hide />
                <YAxis hide domain={["dataMin - 40", "dataMax + 40"]} />
                <Tooltip
                  cursor={{ stroke: "#d4d4d8", strokeDasharray: "3 3" }}
                  contentStyle={{
                    background: "#fff",
                    border: "1px solid #ececea",
                    borderRadius: 8,
                    fontSize: 12,
                  }}
                  formatter={(v: number, name: string) => [`€${v}`, name]}
                  labelFormatter={(l) => `Day ${l}`}
                />
                <Area
                  type="monotone"
                  dataKey="Revenue"
                  stroke={tone.greenSoft}
                  strokeWidth={2.5}
                  fill="url(#revFill)"
                />
                <Area
                  type="monotone"
                  dataKey="Profit"
                  stroke="#a1a1aa"
                  strokeWidth={1.5}
                  strokeDasharray="4 4"
                  fill="transparent"
                />
              </AreaChart>
            </ResponsiveContainer>
          </div>

          <div className="flex items-center gap-5 mt-3 text-xs">
            <span className="inline-flex items-center gap-1.5">
              <span
                className="h-2.5 w-2.5 rounded-sm"
                style={{ background: tone.greenSoft }}
              />
              Revenue
            </span>
            <span className="inline-flex items-center gap-1.5 text-[#71717a]">
              <span className="h-[2px] w-3" style={{ background: "#a1a1aa" }} />
              Profit
            </span>
          </div>
        </div>

        <div className={`${tone.card} p-5`}>
          <h2 className="text-sm font-semibold mb-4">Top SKUs by profit</h2>
          <div className="space-y-4">
            {topSkus.map((s) => (
              <div key={s.code} className="grid grid-cols-[52px_1fr_auto] items-center gap-3">
                <span className="text-[11px] font-mono text-[#a1a1aa]">{s.code}</span>
                <div>
                  <p className="text-sm font-medium truncate">{s.name}</p>
                  <div className="h-1.5 rounded-full bg-[#f4f4f5] mt-1.5 overflow-hidden">
                    <div
                      className="h-full rounded-full"
                      style={{ width: `${s.pct}%`, background: tone.green }}
                    />
                  </div>
                </div>
                <span className="text-xs font-mono text-[#71717a] tabular-nums">
                  €{s.profit.toFixed(2)}
                </span>
              </div>
            ))}
          </div>
          <Link
            to="../profitability"
            className="inline-flex items-center gap-1 text-xs font-medium mt-5 hover:underline"
            style={{ color: tone.green }}
          >
            View full profitability <ArrowUpRight className="h-3 w-3" />
          </Link>
        </div>
      </div>

      {/* Activity + Health */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 mb-2">
        <div className={`${tone.card} p-5`}>
          <h2 className="text-sm font-semibold mb-4">Recent activity</h2>
          <ul className="space-y-3">
            {activity.map((a, i) => (
              <li key={i} className="flex items-start gap-3">
                <div
                  className="h-8 w-8 rounded-full flex items-center justify-center shrink-0 mt-0.5"
                  style={{ background: a.iconBg }}
                >
                  <a.icon className="h-4 w-4" style={{ color: a.iconColor }} />
                </div>
                <div className="min-w-0 flex-1">
                  <p className="text-sm font-medium text-[#18181b]">{a.title}</p>
                  <p className="text-xs text-[#a1a1aa] mt-0.5">{a.meta}</p>
                </div>
              </li>
            ))}
          </ul>
        </div>

        <div className={`${tone.card} p-5`}>
          <h2 className="text-sm font-semibold mb-4">Marketplace health</h2>
          <ul className="space-y-3">
            {marketplaces.map((m, i) => (
              <li key={i} className="flex items-center gap-3">
                <div
                  className="h-9 w-9 rounded-full flex items-center justify-center shrink-0 text-xs font-semibold"
                  style={{
                    background:
                      m.status === "synced"
                        ? tone.greenTint
                        : m.status === "errors"
                        ? tone.redTint
                        : tone.grayTint,
                    color:
                      m.status === "synced"
                        ? tone.greenInk
                        : m.status === "errors"
                        ? tone.redInk
                        : tone.grayInk,
                  }}
                >
                  {m.code}
                </div>
                <div className="min-w-0 flex-1">
                  <p className="text-sm font-medium">
                    {m.name}
                    {m.region && <span className="text-[#a1a1aa]"> · {m.region}</span>}
                  </p>
                  <p className="text-xs text-[#a1a1aa] mt-0.5 inline-flex items-center gap-1">
                    <Clock4 className="h-3 w-3" />
                    Last sync {m.sync}
                  </p>
                </div>
                <StatusChip status={m.status} errors={m.errors} />
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
}
