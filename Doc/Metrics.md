# Metrics in MToP

[← README](../README.md) · [Algorithms](Algorithms.md) · [Problems](Problems.md)

**23 metrics · 2 categories**

## Contents

| Category | Metrics |
| :-- | --: |
| [Single-objective metrics](#single-objective-metrics) | 10 |
| [Multiobjective metrics](#multiobjective-metrics) | 14 |

## Single-objective metrics

<table>
<thead>
<tr><th>Year ↓</th><th>Metric / source</th><th>Task support</th><th>Direction</th><th>Result / constraints</th><th>Description</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2022</td>
<td><a href="../MTO/Metrics/Single-objective/Obj_CMT.m" title="Competitive objective value"><code>Obj_CMT</code></a> (TEVC)</td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Across tasks · absolute<br>competitive</td>
<td>Minimum task objective at each checkpoint; infeasible values are masked.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3141819" title="Evolutionary Competitive Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2022CompetitiveMTO,
  title      = {Evolutionary Competitive Multitasking Optimization},
  author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {278-289},
  doi        = {10.1109/TEVC.2022.3141819},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Metrics/Single-objective/Obj_MTS.m" title="Objective multitask score"><code>Obj_MTS</code></a> (arXiv)</td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Across tasks · relative<br>unconstrained / constrained</td>
<td>Mean per-task objective z-score across algorithms and runs at each checkpoint.</td>
<td><a href="https://arxiv.org/abs/1706.03470" title="Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Da2017CEC2017-MTSO,
  title      = {Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results},
  author     = {Da, Bingshui and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Zhu, Zexuan and Ting, Chuan-Kang and Tang, Ke and Yao, Xin},
  journal    = {arXiv preprint arXiv:1706.03470},
  year       = {2017},
}
```

</details>
</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Single-objective/CV.m" title="Constraint violation"><code>CV</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Minimize ↓</td>
<td>Per task · absolute<br>constrained</td>
<td>Recorded constraint-violation value per task.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Single-objective/FR.m" title="Feasible rate"><code>FR</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Maximize ↑</td>
<td>Per task, across runs · absolute<br>constrained</td>
<td>Fraction of runs with a feasible final result for each task.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Single-objective/Obj.m" title="Objective value"><code>Obj</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Minimize ↓</td>
<td>Per task · absolute<br>unconstrained / constrained</td>
<td>Recorded objective value; infeasible checkpoints are NaN.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Single-objective/Obj_AV.m" title="Average objective value"><code>Obj_AV</code></a></td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Across tasks · absolute<br>unconstrained / constrained</td>
<td>Arithmetic mean across task objectives at each checkpoint; infeasible values are masked.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Single-objective/Obj_NBR.m" title="Number of best results"><code>Obj_NBR</code></a></td>
<td>multitask / many-task</td>
<td>Maximize ↑</td>
<td>Across tasks and runs · relative<br>unconstrained / constrained</td>
<td>Number of tasks with the best mean final feasible objective across algorithms; tied best values count.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Single-objective/Obj_Neg.m" title="Negated objective value"><code>Obj_Neg</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Maximize ↑</td>
<td>Per task · absolute<br>unconstrained / constrained</td>
<td>Negated objective value for maximization reporting; infeasible checkpoints are NaN.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Single-objective/Obj_UV.m" title="Unified objective value"><code>Obj_UV</code></a></td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Across tasks · relative<br>unconstrained / constrained</td>
<td>Mean task objective after per-task min–max normalization over all algorithms, runs and checkpoints.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Run_Time.m" title="Runtime"><code>Run_Time</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Minimize ↓</td>
<td>Per problem · absolute<br>unconstrained / constrained / competitive</td>
<td>Recorded wall-clock runtime in seconds for each problem, algorithm and run.</td>
<td>—</td>
<td>—</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)

## Multiobjective metrics

<table>
<thead>
<tr><th>Year ↓</th><th>Metric / source</th><th>Task support</th><th>Direction</th><th>Result / constraints</th><th>Description</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2022</td>
<td><a href="../MTO/Metrics/Multi-objective/HV_CMT.m" title="Competitive hypervolume"><code>HV_CMT</code></a> (TEVC)</td>
<td>multitask / many-task</td>
<td>Maximize ↑</td>
<td>Pooled task front · relative<br>competitive</td>
<td>Normalized hypervolume of the pooled feasible nondominated task front; bounds use pooled final fronts.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3141819" title="Evolutionary Competitive Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2022CompetitiveMTO,
  title      = {Evolutionary Competitive Multitasking Optimization},
  author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {278-289},
  doi        = {10.1109/TEVC.2022.3141819},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Metrics/Multi-objective/IGD_CMT.m" title="Competitive inverted generational distance"><code>IGD_CMT</code></a> (TEVC)</td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Pooled task front · absolute<br>competitive</td>
<td>Inverted generational distance of the pooled task front against pooled nondominated task optima.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3141819" title="Evolutionary Competitive Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2022CompetitiveMTO,
  title      = {Evolutionary Competitive Multitasking Optimization},
  author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {278-289},
  doi        = {10.1109/TEVC.2022.3141819},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Metrics/Multi-objective/IGDp_CMT.m" title="Competitive inverted generational distance plus"><code>IGDp_CMT</code></a> (TEVC)</td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Pooled task front · absolute<br>competitive</td>
<td>Inverted generational distance plus of the pooled task front against pooled nondominated task optima.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3141819" title="Evolutionary Competitive Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2022CompetitiveMTO,
  title      = {Evolutionary Competitive Multitasking Optimization},
  author     = {Li, Genghui and Zhang, Qingfu and Wang, Zhenkun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {278-289},
  doi        = {10.1109/TEVC.2022.3141819},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Metrics/Multi-objective/HV_MTS.m" title="Hypervolume multitask score"><code>HV_MTS</code></a> (arXiv)</td>
<td>multitask / many-task</td>
<td>Maximize ↑</td>
<td>Across tasks · relative<br>unconstrained / constrained</td>
<td>Mean per-task hypervolume z-score across algorithms and runs at each checkpoint.</td>
<td><a href="https://arxiv.org/abs/1706.03470" title="Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Da2017CEC2017-MTSO,
  title      = {Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results},
  author     = {Da, Bingshui and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Zhu, Zexuan and Ting, Chuan-Kang and Tang, Ke and Yao, Xin},
  journal    = {arXiv preprint arXiv:1706.03470},
  year       = {2017},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Metrics/Multi-objective/IGD_MTS.m" title="Inverted generational distance multitask score"><code>IGD_MTS</code></a> (arXiv)</td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Across tasks · relative<br>unconstrained / constrained</td>
<td>Mean per-task inverted generational distance z-score across algorithms and runs at each checkpoint.</td>
<td><a href="https://arxiv.org/abs/1706.03470" title="Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Da2017CEC2017-MTSO,
  title      = {Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results},
  author     = {Da, Bingshui and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Zhu, Zexuan and Ting, Chuan-Kang and Tang, Ke and Yao, Xin},
  journal    = {arXiv preprint arXiv:1706.03470},
  year       = {2017},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Metrics/Multi-objective/IGDp_MTS.m" title="Inverted generational distance plus multitask score"><code>IGDp_MTS</code></a> (arXiv)</td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Across tasks · relative<br>unconstrained / constrained</td>
<td>Mean per-task inverted generational distance plus z-score across algorithms and runs at each checkpoint.</td>
<td><a href="https://arxiv.org/abs/1706.03470" title="Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Da2017CEC2017-MTSO,
  title      = {Evolutionary Multitasking for Single-objective Continuous Optimization: Benchmark Problems, Performance Metric, and Baseline Results},
  author     = {Da, Bingshui and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Zhu, Zexuan and Ting, Chuan-Kang and Tang, Ke and Yao, Xin},
  journal    = {arXiv preprint arXiv:1706.03470},
  year       = {2017},
}
```

</details>
</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Multi-objective/HV.m" title="Hypervolume"><code>HV</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Maximize ↑</td>
<td>Per task · relative<br>unconstrained / constrained</td>
<td>Normalized hypervolume; bounds come from final feasible nondominated fronts pooled across algorithms and runs.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Multi-objective/HV_RefPoint.m" title="Reference-point hypervolume"><code>HV_RefPoint</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Maximize ↑</td>
<td>Per task · absolute<br>unconstrained / constrained</td>
<td>Unnormalized hypervolume; the reference point is the coordinatewise maximum of the task optimum.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Multi-objective/IGD.m" title="Inverted generational distance"><code>IGD</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Minimize ↓</td>
<td>Per task · absolute<br>unconstrained / constrained</td>
<td>Mean nearest Euclidean distance from the task reference front to its feasible nondominated front.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Multi-objective/IGD_AV.m" title="Average inverted generational distance"><code>IGD_AV</code></a></td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Across tasks · absolute<br>unconstrained / constrained</td>
<td>Arithmetic mean of task inverted generational distance values.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Multi-objective/IGDp.m" title="Inverted generational distance plus"><code>IGDp</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Minimize ↓</td>
<td>Per task · absolute<br>unconstrained / constrained</td>
<td>Mean nearest modified distance from task optima; only positive front-minus-reference deviations contribute.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Run_Time.m" title="Runtime"><code>Run_Time</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Minimize ↓</td>
<td>Per problem · absolute<br>unconstrained / constrained / competitive</td>
<td>Recorded wall-clock runtime in seconds for each problem, algorithm and run.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Multi-objective/Spread.m" title="Generalized spread"><code>Spread</code></a></td>
<td>Single-task / multitask / many-task</td>
<td>Minimize ↓</td>
<td>Per task · relative<br>unconstrained / constrained</td>
<td>Generalized spread using reference extremes from final feasible nondominated fronts pooled across algorithms and runs.</td>
<td>—</td>
<td>—</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Metrics/Multi-objective/Spread_CMT.m" title="Competitive generalized spread"><code>Spread_CMT</code></a></td>
<td>multitask / many-task</td>
<td>Minimize ↓</td>
<td>Pooled task front · relative<br>competitive</td>
<td>Generalized spread of the pooled task front; reference extremes come from pooled final feasible nondominated fronts.</td>
<td>—</td>
<td>—</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)
