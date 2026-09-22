# Metric implementation

Each public metric keeps the existing `result = MetricName(MTOData, varargin)`
interface and catalog labels on the second line. Its file owns the optimization
direction, relative/absolute flag, feasibility policy, formula, normalization,
and choice of reference data. Adding or changing a metric does not require a
new name-based branch in the shared runners.

## Responsibilities

| Location | Responsibility |
| --- | --- |
| `Single-objective/*.m` | Objective/CV selection, feasibility masking, task means/minima, MTS/UV normalization, FR/NBR summaries |
| `Multi-objective/*.m` | Score kernel selection, reference sets or points, HV bounds, MTS/average aggregation |
| `Multi-objective/Utils/get*.m` | Existing numerical kernels for IGD, IGD+, HV and Spread; shared by ordinary and competitive variants |
| `Utils/ComputeObjectiveMetric.m` | Record traversal, double history buffers, task/problem rows and FE budgets |
| `Utils/ComputeParetoMetric.m` | Task grouping, feasible/nondominated front extraction, serial/parallel traversal and Pareto output |
| `Utils/AggregateTaskMetric.m` | Problem slices of cached base histories and storage of callback results |
| Other `Utils/*.m` | Cache lookup, result schema, history storage and front collection/filtering |

## Callback interfaces

Initialize metadata with
`CreateMetricResult(data, direction, relative, perTask)`. `direction` is `Min`
or `Max`; `relative` identifies results that depend on the comparison set.
The runners append histories to this result without choosing metric metadata.

- `ComputeObjectiveMetric(data, result, perTask, readHistory, aggregate)`:
  `readHistory(record)` returns a tasks-by-checkpoints matrix. It owns any
  feasibility masking. The runner collects these into a double array with
  dimensions repetitions × tasks × checkpoints. For problem-level metrics,
  `aggregate(values)` reduces the task axis to one. Per-task metrics omit this
  last callback. See `Obj.m`, `CV.m`, `Obj_AV.m`, and `Obj_CMT.m`.
- `ComputeParetoMetric(data, result, competitive, prepare, varargin{:})`:
  `prepare(data, problemIndex, tasks, reference)` returns a scalar-valued
  `evaluate(front)` function. `reference` is the task optimum, or the pooled
  nondominated optima for competitive metrics. Each metric chooses whether to
  use it, a reference point, or `CollectFinalMetricFront` instead. Preparation
  runs once per task/group, outside the repetitions loop. The first optional
  argument still enables `parfor`. See `IGD.m`, `HV.m`, and `HV_RefPoint.m`.
- `AggregateTaskMetric(data, base, result, aggregate, preserveTaskX)`:
  obtain `base` with `ReadMetricResult(data, baseName, varargin{:})`.
  `aggregate(values)` receives tasks × algorithms × repetitions × checkpoints
  for one problem and returns 1 × algorithms × repetitions × checkpoints.
  `preserveTaskX=true` retains sampled base FE coordinates multiplied by the
  number of tasks; `false` uses uniformly spaced problem FE coordinates.
  See `IGD_AV.m`, `Obj_MTS.m`, and `Obj_UV.m`.
- `ReadFinalMetricData(data, readFinal)` collects task-by-one values from
  `readFinal(record)` into tasks × algorithms × repetitions for summaries.
  See `FR.m` and `Obj_NBR.m`.

For example, a new single-objective task mean can define its arithmetic locally:

```matlab
function result = ExampleMean(MTOData, varargin)
% <Multi-task/Many-task> <Single-objective> <None/Constrained>
result = CreateMetricResult(MTOData, 'Min', false, false);
result = ComputeObjectiveMetric(MTOData, result, false, ...
    @readObjective, @(values) mean(values, 2));
end

function history = readObjective(record)
history = record.Obj;
history(record.CV > 0) = NaN;
end
```

Keep `perTask` consistent between metadata and traversal. For Pareto metrics it
is the inverse of `competitive`. Derived metrics should declare their base
metric dependency in their own file. Removing a base also requires updating
its dependents.

## Preserved behavior

The public result fields, row/column order, array dimensions, task/problem FE
budgets, cache lookup order, parallel option, and numerical kernels are unchanged.
In particular:

- Objective histories mask positive CV with NaN before conversion to the shared
  double buffer. Mean/min retain their existing MATLAB missing-value behavior.
- Obj MTS omits NaNs only for its center; its standard deviation still includes
  them. Other MTS centers include NaNs. A zero scale produces zero scores.
- UV bounds span the complete history of each task. A constant task retains its
  division-by-zero NaN result.
- Relative HV/Spread use final feasible nondominated fronts from all algorithms
  and repetitions. HV retains its empty-reference fallback bounds.
- Competitive metrics pool tasks before nondominated filtering and use the full
  problem budget. Per-task histories use the task budget.
- `IGD_AV` retains sampled base X coordinates; MTS/UV retain their existing
  uniformly reconstructed X coordinates.
