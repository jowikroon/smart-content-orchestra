<#
.SYNOPSIS
  HansOS Toegang: 1 script dat de toegang voor alle AI-systemen herstelt en controleert.

.DESCRIPTION
  Stappen (allemaal omkeerbaar, met .bak-kopie voor elke wijziging):
   1. Antigravity: verplaatst de falende plugin googlecloudtools.datacloud_telemetry
      naar %USERPROFILE%\.gemini\plugins-uitgeschakeld (terug te zetten).
   2. Zet HANSOS-TOEGANG.md in de vault-root.
   3. Zet 1 verwijsregel bovenaan AGENTS.md en claude.md, en maakt GEMINI.md aan.
   4. Maakt inbox-mappen voor antigravity, gemini, codex en drive.
   5. Plaatst de Obsidian Bases in _meta\ als ze er nog niet staan.
   6. Optioneel: verwerkt een gedownloade _vault-inbox.zip uit Drive naar de juiste inbox.
   7. Optioneel: ververst de wiki-leeskopie in Google Drive voor web-AI.
   8. Draait de toegangscheck, zet het rapport op het bureaublad en op het klembord.
   9. Opent Obsidian en de Notion Hub.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\Install-HansOS-Toegang.ps1
  powershell -ExecutionPolicy Bypass -File .\Install-HansOS-Toegang.ps1 -AlleenTest
  powershell -ExecutionPolicy Bypass -File .\Install-HansOS-Toegang.ps1 -Leeskopie -RegistreerTaak
#>
[CmdletBinding()]
param(
  [string]$Vault = (Join-Path $env:USERPROFILE 'Documents\SecondBrainVault'),
  [switch]$AlleenTest,
  [string]$InboxZip,
  [switch]$Leeskopie,
  [string]$LeeskopieDoel,
  [switch]$AlleenLeeskopie,
  [switch]$RegistreerTaak,
  [switch]$NietOpenen
)

$ErrorActionPreference = 'Stop'
$stamp  = Get-Date -Format 'yyyyMMdd-HHmmss'
$today  = Get-Date -Format 'yyyy-MM-dd'
$utf8   = New-Object System.Text.UTF8Encoding($false)
$script:Wijzigingen = New-Object System.Collections.Generic.List[string]
$NotionHub = 'https://app.notion.com/p/3f9bafaba5018154b20dff43e742fc47'
$Pointer   = '> Toegang en schrijfpaden: lees eerst HANSOS-TOEGANG.md in deze map. Bij tegenspraak over toegang wint dat bestand.'
$SecretNamePattern    = '(\.env$|\.env\.(?!example)|_ed25519|\.pem$|\.key$|\.pfx$|\.rdp$|pass\.txt$|\.mcp\.json|everything\.env|CREDENTIAL|SECRETS)'
$SecretFilePattern    = '(\.env$|_ed25519$|\.pem$|\.key$|\.pfx$|\.rdp$|pass\.txt$|\.mcp\.json(\.bak[^/]*)?$|everything\.env$)'
$SecretContentPattern = '(?i)(api[_-]?key|secret[_-]?key|service[_-]?role|access[_-]?token|refresh[_-]?token|client[_-]?secret)\s*[:=]\s*\S{8,}|sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{30,}|xox[baprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{30,}|-----BEGIN [A-Z ]*PRIVATE KEY-----'

function Write-Utf8([string]$Path, [string]$Text) {
  $dir = Split-Path -Parent $Path
  if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  [System.IO.File]::WriteAllText($Path, $Text, $utf8)
}
function Read-Utf8([string]$Path) { [System.IO.File]::ReadAllText($Path, $utf8) }
function Backup-File([string]$Path) {
  if (Test-Path -LiteralPath $Path) { Copy-Item -LiteralPath $Path -Destination "$Path.bak-$stamp" -Force }
}
function Note([string]$t) { $script:Wijzigingen.Add($t); Write-Host "  + $t" -ForegroundColor Green }

$ToegangMd = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('LS0tCnRpdGxlOiAiSGFuc09TIFRvZWdhbmc6IHdhYXIgc3RhYXQgd2F0IGVuIGhvZSBrb20gamUgZXJiaWoiCnR5cGU6IG1ldGEKc2NvcGU6IFtDQ1AsIEhWTCwgTVBHLCBIYW5zT1NdCnN0YXR1czogYWN0aXZlCmNyZWF0ZWQ6IDIwMjYtMTAtMTYKbGFzdF9yZXZpZXdlZDogMjAyNi0xMC0xNgphbGlhc2VzOiBbSEFOU09TLVRPRUdBTkcsIHRvZWdhbmcsIHN0YXJ0cHVudF0KdGFnczogW2hhbnNvcywgdG9lZ2FuZywgYWdlbnRzLCBvYnNpZGlhbiwgbm90aW9uLCBkcml2ZV0Kc291cmNlczogWyJbWzIwMjYtMTAtMTQtc2Vjb25kYnJhaW4tbmV4dC1zdGVwXV0iLCAiW1syMDI2LTEwLTE0LW1ldGEtd3JpdGVyc11dIiwgIltbMjAyNi0xMC0xNC1tZXRhLWRlbnlsaXN0XV0iXQpoYW5zb3MuaWQ6IG1ldGEtMjAyNi0xMC0xNi1oYW5zb3MtdG9lZ2FuZwpyZWNvcmRfa2luZDogbWV0YQpza2lsbF9pZHM6IFtdCmNhc2VfaWRzOiBbY2FzZS0yMDI2LTEwLWhhbnNvcy1uZXh0LXN0ZXBdCmNvbnRyYWN0X3ZlcnNpb246IDAuMi1kcmFmdApjbGFzc2lmaWNhdGlvbjogaW50ZXJuYWwKLS0tCgojIEhhbnNPUyBUb2VnYW5nCgpFw6luIHN0YXJ0cHVudCB2b29yIEhhbnMgZW4gdm9vciBlbGsgQUktc3lzdGVlbSwgd2ViIGVuIGxva2FhbC4gT3ZlciB0b2VnYW5nIGVuIHNjaHJpamZwYWRlbiB3aW50IGRpdCBiZXN0YW5kIGJpaiB0ZWdlbnNwcmFhayBtZXQgQUdFTlRTLm1kLCBjbGF1ZGUubWQgb2YgR0VNSU5JLm1kLiBWb29yIHdpa2ktY29udmVudGllcyBibGlqZnQgY2xhdWRlLm1kIGxlaWRlbmQuCgojIyAxLiBXYWFyIHN0YWF0IHdhdAoKfCBXYXQgfCBXYWFyIHwgWm8gb3BlbiBqZSBoZXQgfAp8LS0tfC0tLXwtLS18CnwgVmF1bHQgKGVuaWdlIHdhYXJoZWlkKSB8IGBDOlxVc2Vyc1xNYWxsZSBGbGFwcGllXERvY3VtZW50c1xTZWNvbmRCcmFpblZhdWx0YCBvcCBHYW5kYWxmIHwgVmVya2VubmVyIHwKfCBPYnNpZGlhbiB8IGRlemVsZmRlIG1hcCB8IER1YmJlbGtsaWsgYE9wZW4tVmF1bHQtaW4tT2JzaWRpYW4uYmF0YCBpbiBkZSB2YXVsdC1yb290LiBFZXJzdGUga2VlcjogT2JzaWRpYW4gc3RhcnRlbiwgIk9wZW4gZm9sZGVyIGFzIHZhdWx0Iiwga2llcyBkZSB2YXVsdC1tYXAuIEdlZW4gT2JzaWRpYW4/IEluc3RhbGxlZXIgdmlhIG9ic2lkaWFuLm1kLiB8CnwgQnJlaW4gb3ZlciB0aWpkIHwgYF9tZXRhL2JyZWluLW92ZXItdGlqZC5iYXNlYCBlbiBHcmFwaCB2aWV3IHwgSW4gT2JzaWRpYW4gaGV0IGJlc3RhbmQgb3BlbmVuLiBHcmFwaDogQ3RybCtHLCB0YW5kd2llbCwgQW5pbWF0ZSBhYW4uIHwKfCBSZXZpZXctYWNodGVyc3RhbmQgfCBgX21ldGEvcmV2aWV3LWFjaHRlcnN0YW5kLmJhc2VgIHwgSW4gT2JzaWRpYW4gb3BlbmVuIHwKfCBOb3Rpb24gSGFuc09TIEh1YiB8IGh0dHBzOi8vYXBwLm5vdGlvbi5jb20vcC8zZjliYWZhYmE1MDE4MTU0YjIwZGZmNDNlNzQyZmM0NyB8IE5vdGlvbiwgbGlua2VyYmFsaywgUHJpdmF0ZSwgSGFuc09TIEh1YiB8CnwgV2lraS1sZWVza29waWUgKHZvb3Igd2ViLUFJKSB8IEdvb2dsZSBEcml2ZTogYE1pam4gRHJpdmUvSGFuc09TLXdpa2ktbGVlc2AgfCBBbGxlZW4gd2lraS8sIGluZGV4Lm1kLCBIQU5TT1MubWQsIFNUQVJULUhFUkUubWQgZW4gZGl0IGJlc3RhbmQuIFpvbmRlciBjb25maWRlbnRpYWwgZW4gc2VjcmV0cy4gRGFnZWxpamtzIHZlcnZlcnN0LiB8CnwgSW50YWtlIHZvb3Igd2ViLUFJIHwgRHJpdmUgYEFJLWVuLWF1dG9tYXRpc2VyaW5nL192YXVsdC1pbmJveGAgfCBodHRwczovL2RyaXZlLmdvb2dsZS5jb20vZHJpdmUvZm9sZGVycy8xSjNxUDY5aUx6Q1ZjM2JtSzFGUlUtcFNOdVlnam00Q2sgfAp8IFZlcnNpZSBlbiBiYWNrdXAgfCBHaXRIdWIgYGpvd2lrcm9vbi9oYW5zb3MtdmF1bHQtYmFja3VwYCAocHJpdsOpKSB8IEFsbGVlbiBsZXplbiwgZGFnZWxpamtzIGJpamdld2Vya3QgfAp8IFRha2VuIGVuIGlzc3VlcyB8IExpbmVhciBIQU4tMTk0IHwgaHR0cHM6Ly9saW5lYXIuYXBwL2hhbnN2YW5sZWV1d2VuL2lzc3VlL0hBTi0xOTQgfAp8IFZvb3JzdGVsIGVuIGJyaWRnZS1kcm9wcyB8IEdpdEh1YiBQUiBzbWFydC1jb250ZW50LW9yY2hlc3RyYSAjNiB8IGh0dHBzOi8vZ2l0aHViLmNvbS9qb3dpa3Jvb24vc21hcnQtY29udGVudC1vcmNoZXN0cmEvcHVsbC82IHwKCiMjIDIuIFBlciBzeXN0ZWVtOiBsZXplbiwgc2NocmlqdmVuLCBzdGFydGJlc3RhbmQKCnwgU3lzdGVlbSB8IExlZXN0IHwgU2NocmlqZnQgbmlldXdlIGtlbm5pcyBuYWFyIHwgU3RhcnRiZXN0YW5kIHwKfC0tLXwtLS18LS0tfC0tLXwKfCBDbGF1ZGUgQ29kZSBlbiBDb3dvcmsgb3AgR2FuZGFsZiB8IHZhdWx0IChtb3VudCkgfCBgX2Nvbm5lY3Rvci9icmlkZ2UvaW5ib3gvY293b3JrL2A7IGB3aWtpL2AgYWxsZWVuIGFscyBXaWtpIEFnZW50IChjbGF1ZGUubWQgTW9kZSBBIGVuIEIpIHwgY2xhdWRlLm1kLCBkYWFybmEgU1RBUlQtSEVSRS5tZCB8CnwgQW50aWdyYXZpdHkgKFBDKSB8IHZhdWx0IGFscyB3b3Jrc3BhY2UgfCBgX2Nvbm5lY3Rvci9icmlkZ2UvaW5ib3gvYW50aWdyYXZpdHkvYCB8IEFHRU5UUy5tZCB8CnwgR2VtaW5pIENMSSAoUEMpIHwgdmF1bHQgfCBgX2Nvbm5lY3Rvci9icmlkZ2UvaW5ib3gvZ2VtaW5pL2AgfCBHRU1JTkkubWQgfAp8IENvZGV4IChQQykgfCB2YXVsdCB8IGBfY29ubmVjdG9yL2JyaWRnZS9pbmJveC9jb2RleC9gIHwgQUdFTlRTLm1kIHwKfCBDbGF1ZGUgd2ViLCBDbGF1ZGUgYXBwLCBDbGF1ZGUgQ29kZSBjbG91ZCB8IEdpdEh1Yi1iYWNrdXAsIE5vdGlvbiwgRHJpdmUtbGVlc2tvcGllIHwgRHJpdmUgYF92YXVsdC1pbmJveGAgfCBOb3Rpb24tcGFnaW5hICJIYW5zT1MgVG9lZ2FuZyIgfAp8IEdlbWluaSB3ZWIgZW4gYXBwLCBOb3RlYm9va0xNIHwgRHJpdmUgYEhhbnNPUy13aWtpLWxlZXNgIHwgRHJpdmUgYF92YXVsdC1pbmJveGAgfCBgSGFuc09TLXdpa2ktbGVlcy9IQU5TT1MtVE9FR0FORy5tZGAgfAp8IENoYXRHUFQgfCBEcml2ZSBgSGFuc09TLXdpa2ktbGVlc2AsIE5vdGlvbiB8IERyaXZlIGBfdmF1bHQtaW5ib3hgIHwgYEhhbnNPUy13aWtpLWxlZXMvSEFOU09TLVRPRUdBTkcubWRgIHwKfCBTYW1hbnRoYSBlbiBPcGVuQ2xhdyAoUGkpIHwgU3luY3RoaW5nLW1pcnJvciwgYWxsZWVuIGxlemVuIHwgbmlldHMgaW4gZGUgdmF1bHQgfCBkaXQgYmVzdGFuZCBpbiBkZSBtaXJyb3IgfAp8IG44biAoVlBTKSB8IFZQUzItbWlycm9yIFt1bnZlcmlmaWVkXSB8IG5pZXRzIGluIGB3aWtpL2AgfCBuLnYudC4gfAoKRGUgcm91dGluZSAiVmF1bHQgYnJpZGdlIGRyYWluICsgaW5nZXN0IiAoZGFnZWxpamtzIDIyOjQ4KSBoYWFsdCBlbGtlIG1hcCBvbmRlciBgX2Nvbm5lY3Rvci9icmlkZ2UvaW5ib3gvYCBsZWVnIG5hYXIgcmF3LyBlbiBpbmdlc3QgbmFhciB3aWtpLy4KCioqVmVydmFsbGVuIHJvdXRlLioqIERlIERyaXZlLWtvcGllw6tuIGBNeSBDb21wdXRlci9TZWNvbmRCcmFpblZhdWx0YCBlbiBgRmxhcHBpZS9Eb2N1bWVudHMvU2Vjb25kQnJhaW5WYXVsdGAgemlqbiBnZWVuIGJyb24gbWVlci4gWmUgYmV2YXR0ZW4gc2VjcmV0cy4gV2llIGRhYXIgbGFzLCBsZWVzdCBudSBgSGFuc09TLXdpa2ktbGVlc2AuCgojIyAzLiBSZWdlbHMgdm9vciBlbGsgc3lzdGVlbQoKMS4gRGUgdmF1bHQgb3AgR2FuZGFsZiBpcyBkZSB3YWFyaGVpZC4gRWxrZSBhbmRlcmUgcGxlayBpcyBlZW4ga29waWUuCjIuIFNjaHJpamYgbmlldCBkaXJlY3QgaW4gYHdpa2kvYCwgdGVuemlqIGplIGRlIFdpa2kgQWdlbnQgYmVudC4gTmlldXdlIGtlbm5pcyBnYWF0IG5hYXIgZWVuIGluYm94LgozLiBMZWVzLCBrb3BpZWVyIG9mIGNpdGVlciBub29pdCBzZWNyZXRzLiBMYWFkIGV2ZXJ5dGhpbmcuZW52IGFsbGVlbiBsb2thYWwgZW4gYWxsZWVuIGFscyBkZSB0YWFrIGhldCB2cmFhZ3QuCjQuIGBsb2cubWRgIGVuIGBDT1dPUktfTUFTVEVSLm1kYCB2dWwgamUgYWxsZWVuIGFhbiwgbm9vaXQgYmV3ZXJrZW4uCjUuIENvbmZpZGVudGlhbCBnYWF0IG5vb2l0IG5hYXIgd2ViLUFJIG9mIGVlbiBwdWJsaWVrIGVuZHBvaW50LiBEZSBjbGFzc2lmaWVyIGJlc2xpc3QuCjYuIEhhbnMgYmVvb3JkZWVsdC4gR2VlbiBBSSBrZXVydCBpZXRzIGdvZWQgbmFtZW5zIEhhbnMuCgojIyA0LiBEZSBlbmUgcHJvbXB0ICh3ZXJrdCBpbiBlbGsgc3lzdGVlbSkKCmBgYApMZWVzIEhBTlNPUy1UT0VHQU5HOiBoZXQgYmVzdGFuZCBIQU5TT1MtVE9FR0FORy5tZCBpbiBkZSB2YXVsdC1yb290LCBvZiBkZSBOb3Rpb24tcGFnaW5hICJIYW5zT1MgVG9lZ2FuZyIsIG9mIEdvb2dsZSBEcml2ZSBIYW5zT1Mtd2lraS1sZWVzL0hBTlNPUy1UT0VHQU5HLm1kIChkZSBlZXJzdGUgZGllIGplIGt1bnQgb3BlbmVuKS4gRG9lIGRhYXJuYSBkZSB0b2VnYW5nc2NoZWNrIHVpdCBzZWN0aWUgNSBlbiBhbnR3b29yZCBhbGxlZW4gbWV0IGRlIHRhYmVsLgpgYGAKCiMjIDUuIFRvZWdhbmdzY2hlY2sKCkFudHdvb3JkIGFscyB0YWJlbCBtZXQgMyBrb2xvbW1lbjogY2hlY2ssIE9LIG9mIE5FRSwgYmV3aWpzLgoKMS4gKipCcm9uLioqIFdlbGtlIHBsZWsga29uIGplIG9wZW5lbj8gQmV3aWpzOiBoZXQgcGFkIG9mIGRlIGxpbmsuCjIuICoqTGV6ZW4uKiogTm9lbSBkZSBkYXR1bSB2YW4gZGUgbGFhdHN0ZSByZWdlbCBpbiBsb2cubWQuIFpvbmRlciB2YXVsdHRvZWdhbmc6IG5vZW0gZGUgdGl0ZWwgdmFuIDEgYmVzdGFuZCBpbiBgSGFuc09TLXdpa2ktbGVlc2AuCjMuICoqTm90aW9uLioqIE5vZW0gZGUgMyBkYXRhYmFzZXMgaW4gZGUgSGFuc09TIEh1Yi4KNC4gKipEcml2ZS4qKiBIb2V2ZWVsIGJlc3RhbmRlbiBzdGFhbiBlciBpbiBgX3ZhdWx0LWluYm94YD8KNS4gKipTY2hyaWpmcGFkLioqIEluIHdlbGtlIG1hcCB6ZXQgamlqIG5pZXV3ZSBrZW5uaXM/IEhldCBhbnR3b29yZCBtb2V0IHVpdCBzZWN0aWUgMiBrb21lbi4KNi4gKipHcmVuemVuLioqIE5vZW0gMiBkaW5nZW4gZGllIGplIG5vb2l0IGRvZXQsIHVpdCBzZWN0aWUgMy4KCjYga2VlciBPSyBiZXRla2VudCBkYXQgaGV0IHN5c3RlZW0ga2xhYXIgaXMuIEdlZWYgYmlqIGVsa2UgTkVFIGRlIGxldHRlcmxpamtlIHJlZGVuLCB6b2FscyBnZWVuIGNvbm5lY3RvciwgZ2VlbiBiZXN0YW5kc3RvZWdhbmcgb2YgbWFwIG9udGJyZWVrdC4KCiMjIDYuIFRlcnVna29wcGVscmVnZWwKCkVsa2Ugc2Vzc2llIGRpZSBpZXRzIG1hYWt0IG9mIHdpanppZ3QsIGVpbmRpZ3QgbWV0IGhldCBibG9rICoqIldhYXIgc3RhYXQgaGV0IioqLiBEYWFyaW4gc3RhYW4gcGVyIGFydGVmYWN0IGhldCBwYWQgb2YgZGUgbGluaywgaG9lIGplIGhldCBvcGVudCBlbiBkZSBzdGF0dXMgKGNvbmNlcHQgb2YgbGl2ZSkuIFpvbmRlciBsaW5rIGlzIGVlbiB0YWFrIG5pZXQgYWYuCgojIyA3LiBPbmRlcmhvdWQKCi0gTG9rYWxlIGNoZWNrIGVuIHJlcGFyYXRpZTogYEluc3RhbGwtSGFuc09TLVRvZWdhbmcucHMxYCBpbiBkZSB2YXVsdC1yb290LiBIZXQgc2NyaXB0IGlzIG9wbmlldXcgdGUgZHJhYWllbiBlbiBhbGxlZW4tbGV6ZW4gbWV0IGAtQWxsZWVuVGVzdGAuCi0gQW50aWdyYXZpdHktaG9va2ZvdXQgKGBnb29nbGVjbG91ZHRvb2xzLmRhdGFjbG91ZF90ZWxlbWV0cnlgKTogaGV0IHNjcmlwdCB2ZXJwbGFhdHN0IGRpZSBwbHVnaW4gbmFhciBgLmdlbWluaVxwbHVnaW5zLXVpdGdlc2NoYWtlbGRgLiBUZXJ1Z3pldHRlbiBrYW4gZG9vciBkZSBtYXAgdGVydWcgdGUgdmVycGxhYXRzZW4uCi0gU2VjcmV0cyBpbiBkZSBHaXRIdWItYmFja3VwOiB6aWUgTGluZWFyIEhBTi0xMzIu'))
$BaseBrein = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('IyBCZXN0ZW1taW5nOiBfbWV0YS9icmVpbi1vdmVyLXRpamQuYmFzZSAgKE9ic2lkaWFuIEJhc2VzLCBrZXJuLXBsdWdpbiwgMS4xNCspCiMgUmVjb3JkIHZhbiBoZXQgYnJlaW4gb3ZlciB0aWpkOiBlbGtlIHdpa2ktcGFnaW5hIG9wIGZyb250bWF0dGVyIGBjcmVhdGVkYC4KIyBQYWdpbmEncyB6b25kZXIgYGNyZWF0ZWRgIHZhbGxlbiBvbmRlcmFhbiBlbiB6aWpuIHpvIHppY2h0YmFhciBhbHMgaGVhZGVyLWdhcC4KZmlsdGVyczoKICBhbmQ6CiAgICAtIGZpbGUuaW5Gb2xkZXIoIndpa2kiKQogICAgLSBmaWxlLmV4dCA9PSAibWQiCmZvcm11bGFzOgogIGxlZWZ0aWpkX2RhZ2VuOiAnaWYobm90ZS5jcmVhdGVkLCAodG9kYXkoKSAtIGRhdGUobm90ZS5jcmVhdGVkKSkuZGF5cywgIiIpJwogIHdlZWs6ICdpZihub3RlLmNyZWF0ZWQsIGRhdGUobm90ZS5jcmVhdGVkKS5mb3JtYXQoIllZWVktW1ddV1ciKSwgInpvbmRlciBjcmVhdGVkIiknCnByb3BlcnRpZXM6CiAgbm90ZS5jcmVhdGVkOgogICAgZGlzcGxheU5hbWU6IEFhbmdlbWFha3QKICBub3RlLmxhc3RfcmV2aWV3ZWQ6CiAgICBkaXNwbGF5TmFtZTogTGFhdHN0IGJlb29yZGVlbGQKICBub3RlLnJlY29yZF9raW5kOgogICAgZGlzcGxheU5hbWU6IFNvb3J0CiAgbm90ZS5zY29wZToKICAgIGRpc3BsYXlOYW1lOiBTY29wZQogIG5vdGUuc3RhdHVzOgogICAgZGlzcGxheU5hbWU6IFN0YXR1cwogIG5vdGUuYWlfZ2VuZXJhdG9yOgogICAgZGlzcGxheU5hbWU6IEdlbmVyYXRvcgogIGZvcm11bGEubGVlZnRpamRfZGFnZW46CiAgICBkaXNwbGF5TmFtZTogRGFnZW4gb3VkCiAgZm9ybXVsYS53ZWVrOgogICAgZGlzcGxheU5hbWU6IFdlZWsKdmlld3M6CiAgLSB0eXBlOiB0YWJsZQogICAgbmFtZTogVGlqZGxpam4KICAgIG9yZGVyOgogICAgICAtIGZpbGUubmFtZQogICAgICAtIG5vdGUuY3JlYXRlZAogICAgICAtIG5vdGUudHlwZQogICAgICAtIG5vdGUucmVjb3JkX2tpbmQKICAgICAgLSBub3RlLnNjb3BlCiAgICAgIC0gbm90ZS5zdGF0dXMKICAgICAgLSBub3RlLmxhc3RfcmV2aWV3ZWQKICAgICAgLSBmb3JtdWxhLmxlZWZ0aWpkX2RhZ2VuCiAgICBzb3J0OgogICAgICAtIHByb3BlcnR5OiBub3RlLmNyZWF0ZWQKICAgICAgICBkaXJlY3Rpb246IERFU0MKICAtIHR5cGU6IGNhcmRzCiAgICBuYW1lOiBMYWF0c3RlIDMwIGRhZ2VuCiAgICBmaWx0ZXJzOgogICAgICBhbmQ6CiAgICAgICAgLSAnZGF0ZShub3RlLmNyZWF0ZWQpID49IHRvZGF5KCkgLSBkdXJhdGlvbigiMzBkIiknCiAgICBvcmRlcjoKICAgICAgLSBmaWxlLm5hbWUKICAgICAgLSBub3RlLmNyZWF0ZWQKICAgICAgLSBub3RlLnNjb3BlCiAgICAgIC0gbm90ZS5haV9nZW5lcmF0b3IKICAgIHNvcnQ6CiAgICAgIC0gcHJvcGVydHk6IG5vdGUuY3JlYXRlZAogICAgICAgIGRpcmVjdGlvbjogREVTQwogICAgY2FyZFNpemU6IDIyMAogIC0gdHlwZTogdGFibGUKICAgIG5hbWU6IFBlciB3ZWVrCiAgICBncm91cEJ5OgogICAgICBwcm9wZXJ0eTogZm9ybXVsYS53ZWVrCiAgICAgIGRpcmVjdGlvbjogREVTQwogICAgb3JkZXI6CiAgICAgIC0gZmlsZS5uYW1lCiAgICAgIC0gbm90ZS5jcmVhdGVkCiAgICAgIC0gbm90ZS5yZWNvcmRfa2luZAogICAgc29ydDoKICAgICAgLSBwcm9wZXJ0eTogbm90ZS5jcmVhdGVkCiAgICAgICAgZGlyZWN0aW9uOiBERVNDCiAgLSB0eXBlOiBrYW5iYW4KICAgIG5hbWU6IFN0YXR1cwogICAgZ3JvdXBCeToKICAgICAgcHJvcGVydHk6IG5vdGUuc3RhdHVzCiAgICBvcmRlcjoKICAgICAgLSBmaWxlLm5hbWUKICAgICAgLSBub3RlLmNyZWF0ZWQKICAgICAgLSBub3RlLnNjb3BlCiAgICBzb3J0OgogICAgICAtIHByb3BlcnR5OiBub3RlLmNyZWF0ZWQKICAgICAgICBkaXJlY3Rpb246IERFU0M='))
$BaseReview = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('IyBCZXN0ZW1taW5nOiBfbWV0YS9yZXZpZXctYWNodGVyc3RhbmQuYmFzZSAgKE9ic2lkaWFuIEJhc2VzLCBrZXJuLXBsdWdpbiwgMS4xNCspCiMgQ3VyYXRlLWxpanN0OiB3YXQgd2FjaHQgb3AgSGFucy4gQnJvbm5lbiB6b25kZXIgcmV2aWV3LCBwYWdpbmEncyA+NjAgZGFnZW4gbmlldCBiZW9vcmRlZWxkLCBoZWFkZXItZ2Fwcy4KZmlsdGVyczoKICBhbmQ6CiAgICAtIGZpbGUuaW5Gb2xkZXIoIndpa2kiKQogICAgLSBmaWxlLmV4dCA9PSAibWQiCmZvcm11bGFzOgogIGRhZ2VuX3NpbmRzX3JldmlldzogJ2lmKG5vdGUubGFzdF9yZXZpZXdlZCwgKHRvZGF5KCkgLSBkYXRlKG5vdGUubGFzdF9yZXZpZXdlZCkpLmRheXMsICIiKScKICBoZWFkZXJfZ2FwOiAnaWYoIW5vdGUuY3JlYXRlZCB8fCAhbm90ZS5zdGF0dXMgfHwgIW5vdGUudHlwZSwgImphIiwgIiIpJwpwcm9wZXJ0aWVzOgogIG5vdGUuY3JlYXRlZDoKICAgIGRpc3BsYXlOYW1lOiBBYW5nZW1hYWt0CiAgbm90ZS5sYXN0X3Jldmlld2VkOgogICAgZGlzcGxheU5hbWU6IExhYXRzdCBiZW9vcmRlZWxkCiAgZm9ybXVsYS5kYWdlbl9zaW5kc19yZXZpZXc6CiAgICBkaXNwbGF5TmFtZTogRGFnZW4gc2luZHMgcmV2aWV3CiAgZm9ybXVsYS5oZWFkZXJfZ2FwOgogICAgZGlzcGxheU5hbWU6IEhlYWRlci1nYXAKdmlld3M6CiAgLSB0eXBlOiB0YWJsZQogICAgbmFtZTogQnJvbm5lbiB6b25kZXIgcmV2aWV3CiAgICBmaWx0ZXJzOgogICAgICBhbmQ6CiAgICAgICAgLSBub3RlLnR5cGUgPT0gInNvdXJjZSIKICAgICAgICAtICdub3RlLnN0YXR1cyA9PSAiZHJhZnQiIHx8ICFub3RlLmxhc3RfcmV2aWV3ZWQnCiAgICBvcmRlcjoKICAgICAgLSBmaWxlLm5hbWUKICAgICAgLSBub3RlLmNyZWF0ZWQKICAgICAgLSBub3RlLmFpX2dlbmVyYXRvcgogICAgICAtIG5vdGUuc291cmNlX2tpbmQKICAgICAgLSBub3RlLnN0YXR1cwogICAgc29ydDoKICAgICAgLSBwcm9wZXJ0eTogbm90ZS5jcmVhdGVkCiAgICAgICAgZGlyZWN0aW9uOiBBU0MKICAtIHR5cGU6IHRhYmxlCiAgICBuYW1lOiBPdWRlciBkYW4gNjAgZGFnZW4KICAgIGZpbHRlcnM6CiAgICAgIGFuZDoKICAgICAgICAtICdkYXRlKG5vdGUubGFzdF9yZXZpZXdlZCkgPCB0b2RheSgpIC0gZHVyYXRpb24oIjYwZCIpJwogICAgb3JkZXI6CiAgICAgIC0gZmlsZS5uYW1lCiAgICAgIC0gbm90ZS5sYXN0X3Jldmlld2VkCiAgICAgIC0gZm9ybXVsYS5kYWdlbl9zaW5kc19yZXZpZXcKICAgICAgLSBub3RlLnR5cGUKICAgIHNvcnQ6CiAgICAgIC0gcHJvcGVydHk6IG5vdGUubGFzdF9yZXZpZXdlZAogICAgICAgIGRpcmVjdGlvbjogQVNDCiAgLSB0eXBlOiB0YWJsZQogICAgbmFtZTogSGVhZGVyLWdhcHMKICAgIGZpbHRlcnM6CiAgICAgIGFuZDoKICAgICAgICAtICdmb3JtdWxhLmhlYWRlcl9nYXAgPT0gImphIicKICAgIG9yZGVyOgogICAgICAtIGZpbGUubmFtZQogICAgICAtIG5vdGUuY3JlYXRlZAogICAgICAtIG5vdGUuc3RhdHVzCiAgICAgIC0gbm90ZS50eXBlCiAgICBzb3J0OgogICAgICAtIHByb3BlcnR5OiBmaWxlLm5hbWUKICAgICAgICBkaXJlY3Rpb246IEFTQwogIC0gdHlwZTogdGFibGUKICAgIG5hbWU6IFJldmlld3MKICAgIGZpbHRlcnM6CiAgICAgIGFuZDoKICAgICAgICAtIG5vdGUucmVjb3JkX2tpbmQgPT0gInJldmlldyIKICAgIG9yZGVyOgogICAgICAtIGZpbGUubmFtZQogICAgICAtIG5vdGUuY3JlYXRlZAogICAgICAtIG5vdGUuY2FzZV9pZHMKICAgICAgLSBub3RlLnNraWxsX2lkcwogICAgc29ydDoKICAgICAgLSBwcm9wZXJ0eTogbm90ZS5jcmVhdGVkCiAgICAgICAgZGlyZWN0aW9uOiBERVND'))

if (-not (Test-Path -LiteralPath $Vault)) { throw "Vault niet gevonden: $Vault. Geef het juiste pad mee met -Vault." }

function Find-DriveRoot {
  $cands = @()
  foreach ($d in (Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue)) {
    foreach ($n in @('Mijn Drive','My Drive')) {
      $p = Join-Path $d.Root $n
      if (Test-Path -LiteralPath $p) { $cands += $p }
    }
  }
  foreach ($n in @('Google Drive\Mijn Drive','Google Drive\My Drive','Mijn Drive','My Drive')) {
    $p = Join-Path $env:USERPROFILE $n
    if (Test-Path -LiteralPath $p) { $cands += $p }
  }
  if ($cands.Count -gt 0) { return $cands[0] } else { return $null }
}

function Sync-Leeskopie([string]$Doel) {
  if (-not $Doel) {
    $root = Find-DriveRoot
    if (-not $root) { Write-Warning 'Google Drive-map niet gevonden. Geef -LeeskopieDoel "G:\Mijn Drive\HansOS-wiki-lees" mee.'; return }
    $Doel = Join-Path $root 'HansOS-wiki-lees'
  }
  if (-not (Test-Path -LiteralPath $Doel)) { New-Item -ItemType Directory -Force -Path $Doel | Out-Null }
  $bronnen = @()
  $bronnen += Get-ChildItem -LiteralPath (Join-Path $Vault 'wiki') -Recurse -File -Filter *.md -ErrorAction SilentlyContinue
  foreach ($f in @('index.md','HANSOS.md','START-HERE.md','HANSOS-TOEGANG.md')) {
    $p = Join-Path $Vault $f; if (Test-Path -LiteralPath $p) { $bronnen += Get-Item -LiteralPath $p }
  }
  $toegestaan = @{}; $gekopieerd = 0; $overgeslagen = 0
  foreach ($b in $bronnen) {
    $rel = $b.FullName.Substring($Vault.Length).TrimStart('\','/')
    if ($rel -match $SecretNamePattern) { $overgeslagen++; continue }
    $txt = Read-Utf8 $b.FullName
    if ($txt -match '(?m)^classification:\s*confidential' -or $txt -match $SecretContentPattern) { $overgeslagen++; continue }
    $dst = Join-Path $Doel $rel
    $toegestaan[$dst.ToLowerInvariant()] = $true
    $nieuw = $true
    if (Test-Path -LiteralPath $dst) {
      $nieuw = (Get-FileHash -LiteralPath $dst).Hash -ne (Get-FileHash -LiteralPath $b.FullName).Hash
    }
    if ($nieuw) {
      $dd = Split-Path -Parent $dst
      if (-not (Test-Path -LiteralPath $dd)) { New-Item -ItemType Directory -Force -Path $dd | Out-Null }
      Copy-Item -LiteralPath $b.FullName -Destination $dst -Force; $gekopieerd++
    }
  }
  $verwijderd = 0
  foreach ($x in (Get-ChildItem -LiteralPath $Doel -Recurse -File -Filter *.md -ErrorAction SilentlyContinue)) {
    if (-not $toegestaan.ContainsKey($x.FullName.ToLowerInvariant())) { Remove-Item -LiteralPath $x.FullName -Force; $verwijderd++ }
  }
  Write-Utf8 (Join-Path $Doel 'LEESKOPIE-INFO.txt') ("HansOS wiki-leeskopie. Alleen lezen. Bron: $Vault`r`nBijgewerkt: $(Get-Date -Format s)`r`nBestanden: $($toegestaan.Count), overgeslagen (confidential of secret): $overgeslagen`r`nNieuwe kennis gaat naar Drive AI-en-automatisering/_vault-inbox, niet hierheen.`r`n")
  Note "Leeskopie $Doel bijgewerkt: $gekopieerd gekopieerd, $verwijderd verwijderd, $overgeslagen overgeslagen"
  if ($RegistreerTaak) {
    $self = $PSCommandPath
    $arg  = "-NoProfile -ExecutionPolicy Bypass -File `"$self`" -AlleenLeeskopie -NietOpenen -Vault `"$Vault`" -LeeskopieDoel `"$Doel`""
    $act  = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument $arg
    $trg  = New-ScheduledTaskTrigger -Daily -At 07:10
    Register-ScheduledTask -TaskName 'HansOS wiki-leeskopie' -Action $act -Trigger $trg -Description 'Ververst Drive HansOS-wiki-lees uit de vault (zonder confidential en secrets).' -Force | Out-Null
    Note 'Taak "HansOS wiki-leeskopie" geregistreerd (dagelijks 07:10)'
  }
}

if ($AlleenLeeskopie) { Sync-Leeskopie $LeeskopieDoel; exit 0 }

if (-not $AlleenTest) {
  Write-Host "`n[1] Antigravity-plugin" -ForegroundColor Cyan
  $plugin = Join-Path $env:USERPROFILE '.gemini\config\plugins\googlecloudtools.datacloud_telemetry'
  if (Test-Path -LiteralPath $plugin) {
    $park = Join-Path $env:USERPROFILE '.gemini\plugins-uitgeschakeld'
    New-Item -ItemType Directory -Force -Path $park | Out-Null
    Move-Item -LiteralPath $plugin -Destination (Join-Path $park "googlecloudtools.datacloud_telemetry-$stamp")
    Note "Antigravity-plugin verplaatst naar $park (herstart Antigravity)"
  } else { Write-Host '  plugin staat niet (meer) in config\plugins' }

  Write-Host "`n[2] HANSOS-TOEGANG.md" -ForegroundColor Cyan
  $tPath = Join-Path $Vault 'HANSOS-TOEGANG.md'
  $tNew  = $ToegangMd.Trim() + "`n"
  if (-not (Test-Path -LiteralPath $tPath) -or (Read-Utf8 $tPath) -ne $tNew) { Backup-File $tPath; Write-Utf8 $tPath $tNew; Note 'HANSOS-TOEGANG.md geschreven' } else { Write-Host '  al actueel' }

  Write-Host "`n[3] Verwijsregels" -ForegroundColor Cyan
  foreach ($f in @('AGENTS.md','claude.md')) {
    $p = Join-Path $Vault $f
    if (Test-Path -LiteralPath $p) {
      $t = Read-Utf8 $p
      if ($t -notmatch 'HANSOS-TOEGANG\.md') { Backup-File $p; Write-Utf8 $p ($Pointer + "`n`n" + $t); Note "Verwijsregel bovenaan $f" } else { Write-Host "  $f heeft al een verwijsregel" }
    } else { Write-Warning "$f ontbreekt in de vault" }
  }
  $g = Join-Path $Vault 'GEMINI.md'
  if (-not (Test-Path -LiteralPath $g)) {
    Write-Utf8 $g ("# GEMINI.md`n`n$Pointer`n`nVolg daarna AGENTS.md voor werkregels en claude.md voor wiki-conventies. Nieuwe kennis gaat naar _connector/bridge/inbox/gemini/.`n")
    Note 'GEMINI.md aangemaakt'
  } elseif ((Read-Utf8 $g) -notmatch 'HANSOS-TOEGANG\.md') { Backup-File $g; Write-Utf8 $g ($Pointer + "`n`n" + (Read-Utf8 $g)); Note 'Verwijsregel bovenaan GEMINI.md' }

  Write-Host "`n[4] Inbox-mappen" -ForegroundColor Cyan
  foreach ($b in @('antigravity','gemini','codex','drive','cowork')) {
    $p = Join-Path $Vault "_connector\bridge\inbox\$b"
    if (-not (Test-Path -LiteralPath $p)) { New-Item -ItemType Directory -Force -Path $p | Out-Null; Note "Inbox $b aangemaakt" }
  }

  Write-Host "`n[5] Obsidian Bases" -ForegroundColor Cyan
  foreach ($pair in @(@('brein-over-tijd.base',$BaseBrein), @('review-achterstand.base',$BaseReview))) {
    $p = Join-Path $Vault ("_meta\" + $pair[0])
    if (-not (Test-Path -LiteralPath $p)) { Write-Utf8 $p ($pair[1].Trim() + "`n"); Note "_meta\$($pair[0]) geplaatst" } else { Write-Host "  _meta\$($pair[0]) bestaat al" }
  }

  Write-Host "`n[6] Drive _vault-inbox zip" -ForegroundColor Cyan
  if (-not $InboxZip) {
    $dl = Join-Path $env:USERPROFILE 'Downloads'
    $z = Get-ChildItem -LiteralPath $dl -Filter '_vault-inbox*.zip' -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($z) { $InboxZip = $z.FullName }
  }
  if ($InboxZip -and (Test-Path -LiteralPath $InboxZip)) {
    $tmp = Join-Path $env:TEMP "vault-inbox-$stamp"
    Expand-Archive -LiteralPath $InboxZip -DestinationPath $tmp -Force
    foreach ($f in (Get-ChildItem -LiteralPath $tmp -Recurse -File)) {
      $n = $f.Name; $dst = $null
      if ($n -match $SecretNamePattern) { continue }
      if ($n -match '^\d{4}-\d{2}-\d{2}_(ai|hvl|ccp|mpg)_.+\.md$' -and $n -notmatch 'labelcontract') { $dst = "_connector\bridge\inbox\drive\$n" }
      elseif ($n -match '\.md$' -and $n -notmatch 'log-regels-voorstel') { $dst = "_connector\bridge\inbox\cowork\$n" }
      elseif ($n -match '\.base$' -or $n -match 'header-gap-manifest\.csv$') { $dst = "_meta\$n" }
      if (-not $dst) { continue }
      $full = Join-Path $Vault $dst
      $rawDup = (Test-Path -LiteralPath (Join-Path $Vault "raw\$n")) -or (Test-Path -LiteralPath (Join-Path $Vault "raw\_archive\$n"))
      if ((Test-Path -LiteralPath $full) -or $rawDup) { Write-Host "  overgeslagen (bestaat al): $n"; continue }
      Copy-Item -LiteralPath $f.FullName -Destination $full
      Note "Inbox: $dst"
    }
    Remove-Item -LiteralPath $tmp -Recurse -Force
  } else { Write-Host '  geen _vault-inbox*.zip gevonden in Downloads (Drive: map _vault-inbox, rechtsklik, Downloaden)' }

  if ($Leeskopie -or $LeeskopieDoel) { Write-Host "`n[7] Wiki-leeskopie" -ForegroundColor Cyan; Sync-Leeskopie $LeeskopieDoel }
}

Write-Host "`n[8] Toegangscheck" -ForegroundColor Cyan
$res = New-Object System.Collections.Generic.List[object]
function Add-Check([string]$c, [bool]$ok, [string]$d) { $res.Add([pscustomobject]@{ Check = $c; Status = $(if ($ok) { 'OK' } else { 'NEE' }); Detail = $d }) }

Add-Check 'Vault aanwezig' $true $Vault
$missing = @('claude.md','index.md','HANSOS.md','START-HERE.md','AGENTS.md','HANSOS-TOEGANG.md','GEMINI.md') | Where-Object { -not (Test-Path -LiteralPath (Join-Path $Vault $_)) }
Add-Check 'Startbestanden' ($missing.Count -eq 0) $(if ($missing.Count) { 'ontbreekt: ' + ($missing -join ', ') } else { 'alle 7 aanwezig' })
$ptrMiss = @('AGENTS.md','claude.md','GEMINI.md') | Where-Object { $p = Join-Path $Vault $_; -not ((Test-Path -LiteralPath $p) -and ((Read-Utf8 $p) -match 'HANSOS-TOEGANG\.md')) }
Add-Check 'Verwijsregels' ($ptrMiss.Count -eq 0) $(if ($ptrMiss.Count) { 'mist in: ' + ($ptrMiss -join ', ') } else { 'AGENTS.md, claude.md, GEMINI.md' })
$obsExe = @((Join-Path $env:LOCALAPPDATA 'Programs\obsidian\Obsidian.exe'), (Join-Path $env:LOCALAPPDATA 'Obsidian\Obsidian.exe')) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
$obsUri = Test-Path -LiteralPath 'Registry::HKEY_CLASSES_ROOT\obsidian'
Add-Check 'Obsidian geinstalleerd' ([bool]$obsExe -or $obsUri) $(if ($obsExe) { $obsExe } elseif ($obsUri) { 'obsidian:// geregistreerd' } else { 'niet gevonden: installeer via https://obsidian.md' })
Add-Check 'Vault is Obsidian-vault' (Test-Path -LiteralPath (Join-Path $Vault '.obsidian')) '.obsidian-map'
$bases = @('brein-over-tijd.base','review-achterstand.base') | Where-Object { Test-Path -LiteralPath (Join-Path $Vault "_meta\$_") }
Add-Check 'Bases in _meta' ($bases.Count -eq 2) ("$($bases.Count) van 2")
$plg = Test-Path -LiteralPath (Join-Path $env:USERPROFILE '.gemini\config\plugins\googlecloudtools.datacloud_telemetry')
Add-Check 'Antigravity-hook' (-not $plg) $(if ($plg) { 'plugin staat nog in config\plugins' } else { 'falende plugin niet actief' })
$inboxRoot = Join-Path $Vault '_connector\bridge\inbox'
$pending = 0; if (Test-Path -LiteralPath $inboxRoot) { $pending = (Get-ChildItem -LiteralPath $inboxRoot -Directory | ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -File -Filter *.md -ErrorAction SilentlyContinue } | Measure-Object).Count }
Add-Check 'Inbox wachtrij' $true "$pending bestanden wachten op de routine van 22:48"
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git -and (Test-Path -LiteralPath (Join-Path $Vault '.git'))) {
  $last = & git -C $Vault log -1 --format=%cI 2>$null
  $age = if ($last) { [math]::Round(((Get-Date) - [datetime]$last).TotalHours, 1) } else { 999 }
  Add-Check 'Backup naar GitHub' ($age -lt 36) "laatste commit $age uur geleden"
  $tracked = & git -C $Vault ls-files 2>$null | Where-Object { $_ -match $SecretFilePattern }
  Add-Check 'Geen secrets in backup' ($tracked.Count -eq 0) $(if ($tracked.Count) { "$($tracked.Count) secret-bestanden staan in git (zie HAN-132): " + (($tracked | Select-Object -First 6) -join ', ') } else { 'schoon' })
} else { Add-Check 'Backup naar GitHub' $false 'git of .git niet gevonden' }
$root = Find-DriveRoot
if ($root) {
  $info = Join-Path $root 'HansOS-wiki-lees\LEESKOPIE-INFO.txt'
  if (Test-Path -LiteralPath $info) { $h = [math]::Round(((Get-Date) - (Get-Item -LiteralPath $info).LastWriteTime).TotalHours, 1); Add-Check 'Wiki-leeskopie (web-AI)' ($h -lt 30) "$h uur oud" }
  else { Add-Check 'Wiki-leeskopie (web-AI)' $false 'nog niet aangemaakt: draai met -Leeskopie -RegistreerTaak' }
  $old = Join-Path $root 'SecondBrainVault'
  Add-Check 'Oude vault-kopie in Mijn Drive' (-not (Test-Path -LiteralPath $old)) $(if (Test-Path -LiteralPath $old) { "$old bestaat nog" } else { 'niet in Mijn Drive-root' })
} else { Add-Check 'Google Drive voor desktop' $false 'geen Mijn Drive-map gevonden' }

$res | Format-Table -AutoSize | Out-String -Width 220 | Write-Host
$ok = ($res | Where-Object { $_.Status -eq 'OK' }).Count
$rep = "# HansOS toegangscheck $today`n`nScore: $ok van $($res.Count) OK`n`n| Check | Status | Detail |`n|---|---|---|`n" + (($res | ForEach-Object { "| $($_.Check) | $($_.Status) | $($_.Detail) |" }) -join "`n") + "`n"
if ($script:Wijzigingen.Count) { $rep += "`n## Gewijzigd deze run`n" + (($script:Wijzigingen | ForEach-Object { "- $_" }) -join "`n") + "`n" }
$rep += "`n## Waar staat het`n- Vault: $Vault`n- Toegang: $Vault\HANSOS-TOEGANG.md`n- Obsidian: dubbelklik Open-Vault-in-Obsidian.bat in de vault-root`n- Notion Hub: $NotionHub`n- Drive intake: https://drive.google.com/drive/folders/1J3qP69iLzCVc3bmK1FRU-pSNuYgjm4Ck`n"
$desk = [Environment]::GetFolderPath('Desktop')
$repPath = Join-Path $desk "HansOS-toegangscheck-$today.md"
Write-Utf8 $repPath $rep
try { Set-Clipboard -Value $rep } catch { }
Write-Host "Rapport: $repPath (ook op het klembord). Score: $ok van $($res.Count)." -ForegroundColor Yellow

if (-not $AlleenTest -and $script:Wijzigingen.Count) {
  $logLine = "- $today TOEGANG Install-HansOS-Toegang.ps1: " + ($script:Wijzigingen -join '; ') + " (check $ok/$($res.Count))"
  [System.IO.File]::AppendAllText((Join-Path $Vault 'log.md'), "`n$logLine`n", $utf8)
}

if (-not $NietOpenen) {
  try { Start-Process ("obsidian://open?path=" + [uri]::EscapeDataString($Vault)) } catch { Write-Warning 'Obsidian kon niet geopend worden.' }
  try { Start-Process $NotionHub } catch { }
}
