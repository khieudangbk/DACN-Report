# Compile the report without latexmk/Perl.
$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
    $steps = @(
        @{ Tool = 'xelatex'; Arguments = @('-interaction=nonstopmode', '-halt-on-error', '-synctex=1', 'main.tex') },
        @{ Tool = 'biber'; Arguments = @('main') },
        @{ Tool = 'xelatex'; Arguments = @('-interaction=nonstopmode', '-halt-on-error', '-synctex=1', 'main.tex') },
        @{ Tool = 'xelatex'; Arguments = @('-interaction=nonstopmode', '-halt-on-error', '-synctex=1', 'main.tex') }
    )
    foreach ($step in $steps) {
        $compiler = Get-Command $step.Tool -ErrorAction Stop
        & $compiler.Source @($step.Arguments)
        if ($LASTEXITCODE -ne 0) {
            throw "$($step.Tool) failed with exit code $LASTEXITCODE."
        }
    }
    Write-Host "PDF: $(Join-Path $PSScriptRoot 'main.pdf')"
}
finally {
    Pop-Location
}
