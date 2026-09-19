# Statistics: original table presentation

The GUI delegates to `UpdateExperimentStatistics`. Edit numerical methods in
`ComputeFriedmanHolm`, `ComputeWilcoxonTest`, and `HolmAdjust`. The mlapp and .m
entry points already call the external helper; these helper edits take effect
without modifying the component layout or repacking mlapp.

## Table (preserved original format)

- Friedman: `Ranking` (two decimal places), `p-value` (four decimal places,
  `*` for significance), and `Base` in the reference column. No annotations
  or parenthesized text added to table labels. Small p values may display
  `0.0000` due to the original four-decimal format, not an exact zero.
- Wilcoxon: append only `+`, `-`, `=` to performance cells. The summary is
  `+ / - / =`, with three counts and `Base` for the reference algorithm.
- Undefined comparisons are blank, never reported as equality.
- Overall Friedman p is printed to the command window, not the table.
  Baseline and display-format changes do not repeat that output.

## Calculation

- Display Mean/Mean&Std/Std uses omitnan: statistics of successful runs.
  An entirely failed cell remains NaN. Median also uses omitnan.
- Friedman mean calculates mean(raw,3,'omitnan') independently of the selected
  display statistic. All-failed cells rank worst. Partial failure does not
  penalize this conditional-mean comparison, which is not a success-rate test.
- Friedman all reps retains the original row definition: each problem/run
  compares all k algorithms, then averages ranks across those rows. Ranking
  lies in [1,k] and uses the same rows as the Friedman test with reps=1.
  These rows are assumed independent for inference; repeated runs or related
  stream tasks are not automatically independent benchmark problems.
- NaN means no feasible solution. For per-run comparisons, orient objectives
  to minimization first, then replace NaN with +Inf. Failures tie for worst.
  All-failed rows remain tied. All-tied datasets produce p=1.
- Friedman p-value cells contain Holm-adjusted post-hoc comparisons against
  the baseline. Raw p values use MATLAB's tied-rank variance stats.sigma.
  Stars require both overall p<0.05 and adjusted p<0.05.
- Wilcoxon retains its original unadjusted per-problem tests (no Holm).
  Differences are oriented correctly for min/max. Signed-rank equal failures
  have zero difference; a failure versus success has infinite difference.
  Direction comes from the rank effect, independent of the display statistic.
  ComputeWilcoxonHolm remains only as a compatibility wrapper; it does not
  apply correction. AdjustedP is a compatibility alias for RawP in this test.
