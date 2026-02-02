motclean
=========

![example workflow](https://github.com/phewson/motclean/actions/workflows/R-CMD-check.yaml/badge.svg)


`motclean` provides tools for identifying and standardising vehicle makes and models from messy free-text sources such as MOT records.

The package is designed for high-volume, low-quality data, where perfect recall is impossible and explicit uncertainty handling is required.

## Features

- Robust matching of vehicle makes and models from inconsistent text
- Conservative, explainable matching logic
- Explicit accept / review / reject outcomes
- Handles spelling variation, spacing errors, punctuation, and initials
- Uses authoritative reference data derived from UK vehicle registrations
- Designed for reproducibility and auditability

## Motivation

Vehicle data collected in operational systems often contains:

- inconsistent spelling (**ALFA RAMEO**, **ALFA RAMAO**)
- punctuation and spacing errors (**A C COBRA**, **ALFA-ROMEO**)
- embedded model or engine information
- rare vehicles, imports, kit cars, and one-off entries

Attempting to "force" all records into known categories produces unreliable results.
Instead, this package prioritises:

- High confidence matches first, with uncertainty made explicit.

## Approach

Matching is performed in two stages:

### Make resolution

- Text is standardised (case, punctuation, whitespace)
- Candidate make prefixes are extracted

Approximate matching is performed against reference data

Matches are classified as:

- `accept` – high confidence
- `review` – plausible but uncertain
- `reject` – insufficient evidence

### Model resolution

- Performed only for accepted makes
- Uses make-specific reference data
- Applies stricter thresholds

Low-frequency and ambiguous vehicles (e.g. imports, kit cars, motorcycles) are intentionally routed to review or reject.

### Reference data

The package uses internal reference tables derived from official UK vehicle licensing statistics published by the Driver and Vehicle Licensing Agency (DVLA):

<https://www.gov.uk/government/statistical-data-sets/vehicle-licensing-statistics-data-tables>

The data have been transformed and reduced for matching purposes and should not be treated as authoritative counts.

Example

```
library(vehicleresolve)

match_make("ALFA RAMEO GIULIETTA LUSSO VELOCE 1.4")
#> $make
#> [1] "ALFA ROMEO"
#>
#> $status
#> [1] "accept"

match_make("A C COBRA")
#> $make
#> [1] "AC"
#>
#> $status
#> [1] "accept"

match_make("JOHN SMITH SPECIAL")
#> $make
#> [1] NA
#>
#> $status
#> [1] "reject"
```

## Design principles

Conservative by default
When in doubt, do not guess.

Explainable outcomes
Every match has a clear acceptance status.

Data-driven thresholds
Frequency in authoritative sources informs confidence.

Explicit technical debt
Rare edge cases (<1% of records) are documented rather than over-engineered.

What this package does not do

- It does not guarantee full recall
- It does not attempt to classify all possible vehicles
- It does not silently coerce unknown entries into known makes
- It is not intended for real-time VIN decoding
