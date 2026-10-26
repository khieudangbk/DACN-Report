# Compile the report without latexmk/Perl.
param(
    [switch]$Check,
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
    if ($Check -and $Clean) {
        throw 'Use either -Check or -Clean, not both.'
    }
    # Keep platform-specific auxiliary files separate (especially Biber files).
    $buildDir = Join-Path $PSScriptRoot '.build/windows'
    if ($Clean) {
        if (Test-Path -LiteralPath $buildDir) {
            Remove-Item -LiteralPath $buildDir -Recurse -Force
        }
        Write-Host 'Removed Windows intermediates; published main.pdf preserved.'
        return
    }
    foreach ($tool in @('xelatex', 'biber')) {
        if (-not (Get-Command $tool -CommandType Application -ErrorAction SilentlyContinue)) {
            throw "Missing $tool. Install MiKTeX or TeX Live and reopen PowerShell. See README.md."
        }
    }
    if ($Check) {
        Write-Host 'Found xelatex and biber. Ready to compile.'
        return
    }
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
    $texArguments = @('-interaction=nonstopmode', '-halt-on-error', '-file-line-error', '-synctex=1', "-output-directory=$buildDir", 'main.tex')
    $steps = @(
        @{ Tool = 'xelatex'; Arguments = $texArguments },
        @{ Tool = 'biber'; Arguments = @('--input-directory', $buildDir, '--output-directory', $buildDir, 'main') },
        @{ Tool = 'xelatex'; Arguments = $texArguments },
        @{ Tool = 'xelatex'; Arguments = $texArguments }
    )
    foreach ($step in $steps) {
        $compiler = Get-Command $step.Tool -ErrorAction Stop
        & $compiler.Source @($step.Arguments)
        if ($LASTEXITCODE -ne 0) {
            throw "$($step.Tool) failed with exit code $LASTEXITCODE."
        }
    }
    $pdf = Join-Path $buildDir 'main.pdf'
    if (-not (Test-Path -LiteralPath $pdf) -or (Get-Item -LiteralPath $pdf).Length -eq 0) {
        throw "No PDF produced. See $buildDir/main.log."
    }
    Copy-Item -LiteralPath $pdf -Destination (Join-Path $PSScriptRoot 'main.pdf') -Force
    Write-Host "PDF: $(Join-Path $PSScriptRoot 'main.pdf')"
}
finally {
    Pop-Location
}
