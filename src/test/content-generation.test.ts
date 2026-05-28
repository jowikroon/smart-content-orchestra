import { describe, expect, it } from "vitest";
import { dedupeAndLimitFeatures, normalizeCreativeLevel } from "@/lib/content-generation";

describe("content generation helpers", () => {
  it("dedupes case-insensitively and caps list size", () => {
    const input = [
      "Fast shipping",
      "fast shipping",
      "Premium build",
      "",
      "Battery included",
      "Warranty",
      "Gift-ready",
      "Eco-friendly",
      "Scratch-resistant",
      "Waterproof",
      "Compact",
      "Lightweight",
    ];

    expect(dedupeAndLimitFeatures(input, 5)).toEqual([
      "Fast shipping",
      "Premium build",
      "Battery included",
      "Warranty",
      "Gift-ready",
    ]);
  });

  it("normalizes creative level to integers between 1 and 5", () => {
    expect(normalizeCreativeLevel(0)).toBe(1);
    expect(normalizeCreativeLevel(4.4)).toBe(4);
    expect(normalizeCreativeLevel(7)).toBe(5);
    expect(normalizeCreativeLevel(Number.NaN)).toBe(3);
  });
});
