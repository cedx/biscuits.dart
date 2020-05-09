#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)
pub run build_runner test --delete-conflicting-outputs -- --coverage=var
