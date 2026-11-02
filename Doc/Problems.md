# Problems in MToP

[← README](../README.md) · [Algorithms](Algorithms.md) · [Metrics](Metrics.md)

**435 problem classes · 44 suites / variants · 7 categories**

## Contents

| Category | Suites / variants | Problem classes |
| :-- | --: | --: |
| [Single-objective multitask optimization](#single-objective-multitask-optimization) | 12 | 119 |
| [Single-objective many-task optimization](#single-objective-many-task-optimization) | 9 | 38 |
| [Single-objective stream-task optimization](#single-objective-stream-task-optimization) | 4 | 21 |
| [Single-objective single-task optimization](#single-objective-single-task-optimization) | 8 | 179 |
| [Multiobjective multitask optimization](#multiobjective-multitask-optimization) | 10 | 55 |
| [Multiobjective many-task optimization](#multiobjective-many-task-optimization) | 2 | 16 |
| [Multiobjective single-task optimization](#multiobjective-single-task-optimization) | 1 | 9 |

## Single-objective multitask optimization

<table>
<thead>
<tr><th>Year ↓</th><th>Suite / source</th><th>Classes</th><th>Scale (T tasks; D variables)</th><th>Characteristics</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2025</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Global%20Trajectory%20Optimization/MGA_DSM_GTOP.m">MGA-GTOP / MGA-DSM-GTOP</a> (KBS)</td>
<td><details><summary>2 classes</summary><a href="../MTO/Problems/Real-world%20Applications/Global%20Trajectory%20Optimization/MGA_DSM_GTOP.m" title="Multi-task/Many-task · Single-objective · None"><code>MGA_DSM_GTOP</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Global%20Trajectory%20Optimization/MGA_GTOP.m" title="Multi-task · Single-objective · None"><code>MGA_GTOP</code></a></details></td>
<td>T=2/5; case-dependent D</td>
<td><strong>Application</strong> · unconstrained<br>Spacecraft trajectory optimization, including deep-space maneuvers.</td>
<td><a href="https://doi.org/10.1016/j.knosys.2025.113824" title="Scenario-based self-learning transfer framework for multi-task optimization problems">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Yuan2025Scenario,
  title      = {Scenario-based self-learning transfer framework for multi-task optimization problems},
  author     = {Zhuoming Yuan and Guangming Dai and Lei Peng and Maocai Wang and Zhiming Song and Xiaoyu Chen},
  journal    = {Knowledge-Based Systems},
  year       = {2025},
  volume     = {325},
  pages      = {113824},
  doi        = {10.1016/j.knosys.2025.113824},
  issn       = {0950-7051},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Optimal%20Power%20Flow/OPF_MTSO1.m">OPF-MTSO</a> (TEVC)</td>
<td><details><summary>5 classes</summary><a href="../MTO/Problems/Real-world%20Applications/Optimal%20Power%20Flow/OPF_MTSO1.m" title="Multi-task · Single-objective · Constrained"><code>OPF_MTSO1</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Optimal%20Power%20Flow/OPF_MTSO2.m" title="Multi-task · Single-objective · Constrained"><code>OPF_MTSO2</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Optimal%20Power%20Flow/OPF_MTSO3.m" title="Multi-task · Single-objective · Constrained"><code>OPF_MTSO3</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Optimal%20Power%20Flow/OPF_MTSO4.m" title="Multi-task · Single-objective · Constrained"><code>OPF_MTSO4</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Optimal%20Power%20Flow/OPF_MTSO5.m" title="Multi-task · Single-objective · Constrained"><code>OPF_MTSO5</code></a></details></td>
<td>T=2; D=24/33</td>
<td><strong>Application</strong> · constrained<br>Optimal power flow.</td>
<td><a href="https://doi.org/10.1109/TEVC.2023.3330265" title="Multitask Evolution Strategy With Knowledge-Guided External Sampling">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2024MTES-KG,
  title      = {Multitask Evolution Strategy With Knowledge-Guided External Sampling},
  author     = {Li, Yanchi and Gong, Wenyin and Li, Shuijia},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2024},
  volume     = {28},
  number     = {6},
  pages      = {1733-1745},
  doi        = {10.1109/TEVC.2023.3330265},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P1.m">C-CPLX</a> (ESWA)</td>
<td><details><summary>20 classes</summary><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P1.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P1</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P2.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P2</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P3.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P3</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P4.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P4</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P5.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P5</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P6.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P6</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P7.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P7</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P8.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P8</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P9.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P9</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case1/CCPLX_Case1_P10.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case1_P10</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P1.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P1</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P2.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P2</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P3.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P3</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P4.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P4</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P5.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P5</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P6.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P6</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P7.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P7</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P8.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P8</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P9.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P9</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-CPLX/Case2/CCPLX_Case2_P10.m" title="Multi-task · Single-objective · Competitive"><code>CCPLX_Case2_P10</code></a></details></td>
<td>T=2; D=50</td>
<td><strong>Benchmark</strong> · competitive<br>Two groups of ten complex cases.</td>
<td><a href="https://doi.org/10.1016/j.eswa.2023.119550" title="Evolutionary Competitive Multitasking Optimization Via Improved Adaptive Differential Evolution">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2023MTSRA,
  title      = {Evolutionary Competitive Multitasking Optimization Via Improved Adaptive Differential Evolution},
  author     = {Yanchi Li and Wenyin Gong and Shuijia Li},
  journal    = {Expert Systems with Applications},
  year       = {2023},
  pages      = {119550},
  doi        = {10.1016/j.eswa.2023.119550},
  issn       = {0957-4174},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Parameter%20Extraction%20of%20Photovoltaic%20Models/PEPVM.m">PEPVM</a> (ECM / INS / ESWA)</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Parameter%20Extraction%20of%20Photovoltaic%20Models/PEPVM.m">1 class</a></td>
<td>T=3; D=5/7/5</td>
<td><strong>Application</strong> · unconstrained / competitive<br>Photovoltaic parameter extraction; ordinary/competitive modes.</td>
<td><a href="https://doi.org/10.1016/j.enconman.2019.112443" title="An Enhanced Adaptive Differential Evolution Algorithm for Parameter Extraction of Photovoltaic Models">Link</a><br><a href="https://doi.org/10.1016/j.ins.2022.10.099" title="Multitasking Optimization via an Adaptive Solver Multitasking Evolutionary Framework">Link</a><br><a href="https://doi.org/10.1016/j.eswa.2023.119550" title="Evolutionary Competitive Multitasking Optimization Via Improved Adaptive Differential Evolution">Link</a></td>
<td>
<details>
<summary>BibTeX · ECM · 2020</summary>

```bibtex
@article{Li2020Enhanced,
  title      = {An Enhanced Adaptive Differential Evolution Algorithm for Parameter Extraction of Photovoltaic Models},
  author     = {Shuijia Li and Qiong Gu and Wenyin Gong and Bin Ning},
  journal    = {Energy Conversion and Management},
  year       = {2020},
  volume     = {205},
  pages      = {112443},
  doi        = {10.1016/j.enconman.2019.112443},
  issn       = {0196-8904},
}
```

</details>
<details>
<summary>BibTeX · INS · 2023</summary>

```bibtex
@article{Li2023MTEA-SaO,
  title      = {Multitasking Optimization via an Adaptive Solver Multitasking Evolutionary Framework},
  author     = {Yanchi Li and Wenyin Gong and Shuijia Li},
  journal    = {Information Sciences},
  year       = {2023},
  volume     = {630},
  pages      = {688-712},
  doi        = {10.1016/j.ins.2022.10.099},
  url        = {https://www.sciencedirect.com/science/article/pii/S0020025522012191},
  issn       = {0020-0255},
}
```

</details>
<details>
<summary>BibTeX · ESWA · 2023</summary>

```bibtex
@article{Li2023MTSRA,
  title      = {Evolutionary Competitive Multitasking Optimization Via Improved Adaptive Differential Evolution},
  author     = {Yanchi Li and Wenyin Gong and Shuijia Li},
  journal    = {Expert Systems with Applications},
  year       = {2023},
  pages      = {119550},
  doi        = {10.1016/j.eswa.2023.119550},
  issn       = {0957-4174},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Planar%20Kinematic%20Arm%20Control%20Problem/PKACP.m">PKACP</a> (TEVC)</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Planar%20Kinematic%20Arm%20Control%20Problem/PKACP.m">1 class</a></td>
<td>Configurable T/D</td>
<td><strong>Application</strong> · unconstrained<br>Planar kinematic arm control; defaults T=20, D=20.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3210783" title="A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization">Link</a><br><a href="https://doi.org/10.1109/TEVC.2021.3107435" title="Evolutionary Multi-Task Optimization with Adaptive Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX · TEVC · 2023</summary>

```bibtex
@article{Jiang2023BoKT,
  title      = {A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization},
  author     = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2023},
  volume     = {27},
  number     = {5},
  pages      = {1514-1528},
  doi        = {10.1109/TEVC.2022.3210783},
}
```

</details>
<details>
<summary>BibTeX · TEVC · 2022</summary>

```bibtex
@article{Xu2022AEMTO,
  title      = {Evolutionary Multi-Task Optimization with Adaptive Knowledge Transfer},
  author     = {Xu, Hao and Qin, A. K. and Xia, Siyu},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {290--303},
  doi        = {10.1109/TEVC.2021.3107435},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P1.m">C2TOP</a> (TEVC)</td>
<td><details><summary>36 classes</summary><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P1.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case1_P1</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P2.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case1_P2</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P3.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case1_P3</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P4.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case1_P4</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P5.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case1_P5</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P6.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case1_P6</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P7.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case1_P7</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P8.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case1_P8</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case1/C2TOP_Case1_P9.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case1_P9</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case2/C2TOP_Case2_P1.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case2_P1</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case2/C2TOP_Case2_P2.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case2_P2</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case2/C2TOP_Case2_P3.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case2_P3</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case2/C2TOP_Case2_P4.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case2_P4</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case2/C2TOP_Case2_P5.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case2_P5</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case2/C2TOP_Case2_P6.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case2_P6</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case2/C2TOP_Case2_P7.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case2_P7</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case2/C2TOP_Case2_P8.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case2_P8</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case2/C2TOP_Case2_P9.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case2_P9</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case3/C2TOP_Case3_P1.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case3_P1</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case3/C2TOP_Case3_P2.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case3_P2</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case3/C2TOP_Case3_P3.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case3_P3</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case3/C2TOP_Case3_P4.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case3_P4</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case3/C2TOP_Case3_P5.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case3_P5</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case3/C2TOP_Case3_P6.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case3_P6</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case3/C2TOP_Case3_P7.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case3_P7</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case3/C2TOP_Case3_P8.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case3_P8</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case3/C2TOP_Case3_P9.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case3_P9</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case4/C2TOP_Case4_P1.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case4_P1</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case4/C2TOP_Case4_P2.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case4_P2</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case4/C2TOP_Case4_P3.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case4_P3</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case4/C2TOP_Case4_P4.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case4_P4</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case4/C2TOP_Case4_P5.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case4_P5</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case4/C2TOP_Case4_P6.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case4_P6</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case4/C2TOP_Case4_P7.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case4_P7</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case4/C2TOP_Case4_P8.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case4_P8</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C2TOP/Case4/C2TOP_Case4_P9.m" title="Multi-task · Single-objective · Competitive"><code>C2TOP_Case4_P9</code></a></details></td>
<td>T=2; D=25/50</td>
<td><strong>Benchmark</strong> · competitive<br>Four groups of nine cases.</td>
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
<td><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP1.m">C4TOP</a> (TEVC)</td>
<td><details><summary>15 classes</summary><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP1.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP1</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP2.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP2</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP3.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP3</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP4.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP4</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP5.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP5</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP6.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP6</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP7.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP7</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP8.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP8</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP9.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP9</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP10.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP10</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP11.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP11</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP12.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP12</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP13.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP13</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP14.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP14</code></a><br><a href="../MTO/Problems/Multi-task/Competitive-C4TOP/C4TOP15.m" title="Multi-task · Single-objective · Competitive"><code>C4TOP15</code></a></details></td>
<td>T=4; D=40/50</td>
<td><strong>Benchmark</strong> · competitive<br>Competitive four-task benchmark.</td>
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
<td><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT1.m">CMT</a> (GECCO-C)</td>
<td><details><summary>9 classes</summary><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT1.m" title="Multi-task · Single-objective · Constrained"><code>CMT1</code></a><br><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT2.m" title="Multi-task · Single-objective · Constrained"><code>CMT2</code></a><br><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT3.m" title="Multi-task · Single-objective · Constrained"><code>CMT3</code></a><br><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT4.m" title="Multi-task · Single-objective · Constrained"><code>CMT4</code></a><br><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT5.m" title="Multi-task · Single-objective · Constrained"><code>CMT5</code></a><br><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT6.m" title="Multi-task · Single-objective · Constrained"><code>CMT6</code></a><br><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT7.m" title="Multi-task · Single-objective · Constrained"><code>CMT7</code></a><br><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT8.m" title="Multi-task · Single-objective · Constrained"><code>CMT8</code></a><br><a href="../MTO/Problems/Multi-task/Constrained-CMT/CMT9.m" title="Multi-task · Single-objective · Constrained"><code>CMT9</code></a></details></td>
<td>T=2; configurable D</td>
<td><strong>Benchmark</strong> · constrained<br>Feasible-region overlap and task similarity.</td>
<td><a href="https://doi.org/10.1145/3520304.3528890" title="Evolutionary Constrained Multi-Task Optimization: Benchmark Problems and Preliminary Results">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Li2022CMT-Benchmark,
  title      = {Evolutionary Constrained Multi-Task Optimization: Benchmark Problems and Preliminary Results},
  author     = {Li, Yanchi and Gong, Wenyin and Li, Shuijia},
  booktitle  = {Proceedings of the Genetic and Evolutionary Computation Conference Companion},
  year       = {2022},
  pages      = {443–446},
  publisher  = {Association for Computing Machinery},
  doi        = {10.1145/3520304.3528890},
  series     = {GECCO '22},
  numpages   = {4},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Sensor%20Coverage%20Problem/SCP.m">SCP</a> (GPEM / TEVC)</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Sensor%20Coverage%20Problem/SCP.m">1 class</a></td>
<td>Configurable T/D</td>
<td><strong>Application</strong> · unconstrained / competitive<br>Variable-length sensor coverage.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3141819" title="Evolutionary Competitive Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX · GPEM · 2017</summary>

```bibtex
@article{Ryerkerk2017VLP,
  title      = {Solving Metameric Variable-length Optimization Problems Using Genetic Algorithms},
  author     = {Ryerkerk, Matthew L and Averill, Ronald C and Deb, Kalyanmoy and Goodman, Erik D},
  journal    = {Genetic Programming and Evolvable Machines},
  year       = {2017},
  volume     = {18},
  number     = {2},
  pages      = {247--277},
  publisher  = {Springer},
}
```

</details>
<details>
<summary>BibTeX · TEVC · 2022</summary>

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
<td>2020</td>
<td><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO1.m">WCCI20-MTSO</a> (WCCI · competition)</td>
<td><details><summary>10 classes</summary><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO1.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO1</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO2.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO2</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO3.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO3</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO4.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO4</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO5.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO5</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO6.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO6</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO7.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO7</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO8.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO8</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO9.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO9</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO/WCCI20_MTSO10.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO10</code></a></details></td>
<td>T=2; D=50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Complex multitask benchmark.</td>
<td><a href="http://www.bdsc.site/websites/MTO_competition_2020/MTO_Competition_WCCI_2020.html" title="WCCI 2020 Competition on Evolutionary Multi-task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@misc{Feng2020Competition,
  title      = {WCCI 2020 Competition on Evolutionary Multi-task Optimization},
  author     = {Feng, Liang and Qin, Kai and Gupta, Abhishek and Yuan, Yuan and Ong, Yew-Soon and Chi, Xu},
  year       = {2020},
  url        = {http://www.bdsc.site/websites/MTO_competition_2020/MTO_Competition_WCCI_2020.html},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV1.m">WCCI20-MTSO-ErrorValue</a> (WCCI · competition)</td>
<td><details><summary>10 classes</summary><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV1.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV1</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV2.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV2</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV3.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV3</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV4.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV4</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV5.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV5</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV6.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV6</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV7.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV7</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV8.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV8</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV9.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV9</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MTSO-ErrorValue/WCCI20_MTSO_EV10.m" title="Multi-task · Single-objective · None"><code>WCCI20_MTSO_EV10</code></a></details></td>
<td>T=2; D=50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Error-value variant of WCCI20-MTSO.</td>
<td><a href="http://www.bdsc.site/websites/MTO_competition_2020/MTO_Competition_WCCI_2020.html" title="WCCI 2020 Competition on Evolutionary Multi-task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@misc{Feng2020Competition,
  title      = {WCCI 2020 Competition on Evolutionary Multi-task Optimization},
  author     = {Feng, Liang and Qin, Kai and Gupta, Abhishek and Yuan, Yuan and Ong, Yew-Soon and Chi, Xu},
  year       = {2020},
  url        = {http://www.bdsc.site/websites/MTO_competition_2020/MTO_Competition_WCCI_2020.html},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO1_CI_HS.m">CEC17-MTSO</a> (arXiv)</td>
<td><details><summary>9 classes</summary><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO1_CI_HS.m" title="Multi-task · Single-objective · None"><code>CEC17_MTSO1_CI_HS</code></a><br><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO2_CI_MS.m" title="Multi-task · Single-objective · None"><code>CEC17_MTSO2_CI_MS</code></a><br><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO3_CI_LS.m" title="Multi-task · Single-objective · None"><code>CEC17_MTSO3_CI_LS</code></a><br><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO4_PI_HS.m" title="Multi-task · Single-objective · None"><code>CEC17_MTSO4_PI_HS</code></a><br><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO5_PI_MS.m" title="Multi-task · Single-objective · None"><code>CEC17_MTSO5_PI_MS</code></a><br><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO6_PI_LS.m" title="Multi-task · Single-objective · None"><code>CEC17_MTSO6_PI_LS</code></a><br><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO7_NI_HS.m" title="Multi-task · Single-objective · None"><code>CEC17_MTSO7_NI_HS</code></a><br><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO8_NI_MS.m" title="Multi-task · Single-objective · None"><code>CEC17_MTSO8_NI_MS</code></a><br><a href="../MTO/Problems/Multi-task/CEC17-MTSO/CEC17_MTSO9_NI_LS.m" title="Multi-task · Single-objective · None"><code>CEC17_MTSO9_NI_LS</code></a></details></td>
<td>T=2; D=25/50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Nine overlap/similarity combinations.</td>
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
</tbody>
</table>

[↑ Contents](#contents)

## Single-objective many-task optimization

<table>
<thead>
<tr><th>Year ↓</th><th>Suite / source</th><th>Classes</th><th>Scale (T tasks; D variables)</th><th>Characteristics</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2026</td>
<td><a href="../MTO/Problems/Policy%20Search/MaT-Gym/MaT_Gym.m">MaT-Gym</a> (ICML)</td>
<td><a href="../MTO/Problems/Policy%20Search/MaT-Gym/MaT_Gym.m">1 class</a></td>
<td>Environment-dependent T/D</td>
<td><strong>Policy search</strong> · unconstrained<br>Gymnasium policy search; Python dependencies in the local README.</td>
<td><a href="https://openreview.net/forum?id=lkGnJhXUNu" title="Breaking Multi-Task Curse: Reward-Weighted Evolution for Black-Box Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Li2026MES-RET,
  title      = {Breaking Multi-Task Curse: Reward-Weighted Evolution for Black-Box Many-Task Optimization},
  author     = {Li, Yanchi and Liu, Jiao and Gong, Wenyin and Gu, Qiong and Zhao, Yue and Ong, Yew-Soon},
  booktitle  = {Proceedings of the 43rd International Conference on Machine Learning},
  year       = {2026},
  volume     = {306},
  pages      = {68403--68429},
  publisher  = {PMLR},
  url        = {https://openreview.net/forum?id=lkGnJhXUNu},
  series     = {Proceedings of Machine Learning Research},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Problems/Multi-task/LSMaTSO/LSMaTSO1.m">LSMaTSO</a> (TEVC)</td>
<td><details><summary>5 classes</summary><a href="../MTO/Problems/Multi-task/LSMaTSO/LSMaTSO1.m" title="Many-task · Single-objective · None"><code>LSMaTSO1</code></a><br><a href="../MTO/Problems/Multi-task/LSMaTSO/LSMaTSO2.m" title="Many-task · Single-objective · None"><code>LSMaTSO2</code></a><br><a href="../MTO/Problems/Multi-task/LSMaTSO/LSMaTSO3.m" title="Many-task · Single-objective · None"><code>LSMaTSO3</code></a><br><a href="../MTO/Problems/Multi-task/LSMaTSO/LSMaTSO4.m" title="Many-task · Single-objective · None"><code>LSMaTSO4</code></a><br><a href="../MTO/Problems/Multi-task/LSMaTSO/LSMaTSO5.m" title="Many-task · Single-objective · None"><code>LSMaTSO5</code></a></details></td>
<td>Configurable T; D=300</td>
<td><strong>Benchmark</strong> · unconstrained<br>Large-scale many-task functions.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3459862" title="Transfer Task-averaged Natural Gradient for Efficient Many-task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2024TNG-NES,
  title      = {Transfer Task-averaged Natural Gradient for Efficient Many-task Optimization},
  author     = {Li, Yanchi and Gong, Wenyin and Gu, Qiong},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2025},
  volume     = {29},
  number     = {5},
  pages      = {1952-1965},
  doi        = {10.1109/TEVC.2024.3459862},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Global%20Trajectory%20Optimization/MGA_DSM_GTOP.m">MGA-DSM-GTOP</a> (KBS)</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Global%20Trajectory%20Optimization/MGA_DSM_GTOP.m">1 class</a></td>
<td>Default T=5; case-dependent D</td>
<td><strong>Application</strong> · unconstrained<br>Spacecraft trajectory optimization, including deep-space maneuvers.</td>
<td><a href="https://doi.org/10.1016/j.knosys.2025.113824" title="Scenario-based self-learning transfer framework for multi-task optimization problems">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Yuan2025Scenario,
  title      = {Scenario-based self-learning transfer framework for multi-task optimization problems},
  author     = {Zhuoming Yuan and Guangming Dai and Lei Peng and Maocai Wang and Zhiming Song and Xiaoyu Chen},
  journal    = {Knowledge-Based Systems},
  year       = {2025},
  volume     = {325},
  pages      = {113824},
  doi        = {10.1016/j.knosys.2025.113824},
  issn       = {0950-7051},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Problems/Multi-task/STOP/STOP1.m">STOP</a> (TCYB / TSMC-S)</td>
<td><details><summary>12 classes</summary><a href="../MTO/Problems/Multi-task/STOP/STOP1.m" title="Many-task · Single-objective · None"><code>STOP1</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP2.m" title="Many-task · Single-objective · None"><code>STOP2</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP3.m" title="Many-task · Single-objective · None"><code>STOP3</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP4.m" title="Many-task · Single-objective · None"><code>STOP4</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP5.m" title="Many-task · Single-objective · None"><code>STOP5</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP6.m" title="Many-task · Single-objective · None"><code>STOP6</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP7.m" title="Many-task · Single-objective · None"><code>STOP7</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP8.m" title="Many-task · Single-objective · None"><code>STOP8</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP9.m" title="Many-task · Single-objective · None"><code>STOP9</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP10.m" title="Many-task · Single-objective · None"><code>STOP10</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP11.m" title="Many-task · Single-objective · None"><code>STOP11</code></a><br><a href="../MTO/Problems/Multi-task/STOP/STOP12.m" title="Many-task · Single-objective · None"><code>STOP12</code></a></details></td>
<td>Configurable T; D=25/30/50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Scalable sequential-transfer generator; includes the DTSKT adaptation.</td>
<td><a href="https://doi.org/10.1109/TCYB.2025.3547565" title="A Scalable Test Problem Generator for Sequential Transfer Optimization">Link</a><br><a href="https://doi.org/10.1109/TSMC.2025.3598800" title="Distribution Direction-Assisted Two-Stage Knowledge Transfer for Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX · TCYB · 2025</summary>

```bibtex
@article{Xue2023STOP-G,
  title      = {A Scalable Test Problem Generator for Sequential Transfer Optimization},
  author     = {Xue, Xiaoming and Yang, Cuie and Feng, Liang and Zhang, Kai and Song, Linqi and Tan, Kay Chen},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2025},
  volume     = {55},
  number     = {5},
  pages      = {2110-2123},
  doi        = {10.1109/TCYB.2025.3547565},
}
```

</details>
<details>
<summary>BibTeX · TSMC-S · 2025</summary>

```bibtex
@article{Zhang2025DTSKT,
  title      = {Distribution Direction-Assisted Two-Stage Knowledge Transfer for Many-Task Optimization},
  author     = {Zhang, Tingyu and Wu, Xinyi and Li, Yanchi and Gong, Wenyin and Qin, Hu},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2025},
  volume     = {55},
  number     = {10},
  pages      = {7551-7565},
  doi        = {10.1109/TSMC.2025.3598800},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Planar%20Kinematic%20Arm%20Control%20Problem/PKACP.m">PKACP</a> (TEVC)</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Planar%20Kinematic%20Arm%20Control%20Problem/PKACP.m">1 class</a></td>
<td>Configurable T/D</td>
<td><strong>Application</strong> · unconstrained<br>Planar kinematic arm control; defaults T=20, D=20.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3210783" title="A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization">Link</a><br><a href="https://doi.org/10.1109/TEVC.2021.3107435" title="Evolutionary Multi-Task Optimization with Adaptive Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX · TEVC · 2023</summary>

```bibtex
@article{Jiang2023BoKT,
  title      = {A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization},
  author     = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2023},
  volume     = {27},
  number     = {5},
  pages      = {1514-1528},
  doi        = {10.1109/TEVC.2022.3210783},
}
```

</details>
<details>
<summary>BibTeX · TEVC · 2022</summary>

```bibtex
@article{Xu2022AEMTO,
  title      = {Evolutionary Multi-Task Optimization with Adaptive Knowledge Transfer},
  author     = {Xu, Hao and Qin, A. K. and Xia, Siyu},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {290--303},
  doi        = {10.1109/TEVC.2021.3107435},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Problems/Multi-task/Many-task%20CEC-SO/MaT_CEC20_RWCO.m">MaT-CEC20-RWCO</a> (SWEVO)</td>
<td><a href="../MTO/Problems/Multi-task/Many-task%20CEC-SO/MaT_CEC20_RWCO.m">1 class</a></td>
<td>T=42; case-dependent D</td>
<td><strong>Benchmark</strong> · constrained<br>Aggregates 42 real-world cases.</td>
<td><a href="https://doi.org/10.1016/j.swevo.2020.100693" title="A Test-suite of Non-convex Constrained Optimization Problems from the Real-world and Some Baseline Results">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Kumar2020CEC20-RWCO,
  title      = {A Test-suite of Non-convex Constrained Optimization Problems from the Real-world and Some Baseline Results},
  author     = {Abhishek Kumar and Guohua Wu and Mostafa Z. Ali and Rammohan Mallipeddi and Ponnuthurai Nagaratnam Suganthan and Swagatam Das},
  journal    = {Swarm and Evolutionary Computation},
  year       = {2020},
  volume     = {56},
  pages      = {100693},
  doi        = {10.1016/j.swevo.2020.100693},
  issn       = {2210-6502},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO1.m">WCCI20-MaTSO</a> (WCCI · competition)</td>
<td><details><summary>10 classes</summary><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO1.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO1</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO2.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO2</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO3.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO3</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO4.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO4</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO5.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO5</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO6.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO6</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO7.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO7</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO8.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO8</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO9.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO9</code></a><br><a href="../MTO/Problems/Multi-task/WCCI20-MaTSO/WCCI20_MaTSO10.m" title="Many-task · Single-objective · None"><code>WCCI20_MaTSO10</code></a></details></td>
<td>Configurable T; D=50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Complex many-task benchmark.</td>
<td><a href="http://www.bdsc.site/websites/MTO_competition_2020/MTO_Competition_WCCI_2020.html" title="WCCI 2020 Competition on Evolutionary Multi-task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@misc{Feng2020Competition,
  title      = {WCCI 2020 Competition on Evolutionary Multi-task Optimization},
  author     = {Feng, Liang and Qin, Kai and Gupta, Abhishek and Yuan, Yuan and Ong, Yew-Soon and Chi, Xu},
  year       = {2020},
  url        = {http://www.bdsc.site/websites/MTO_competition_2020/MTO_Competition_WCCI_2020.html},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Problems/Multi-task/CEC19-MaTSO/CEC19_MaTSO1.m">CEC19-MaTSO</a> (CEC · competition)</td>
<td><details><summary>6 classes</summary><a href="../MTO/Problems/Multi-task/CEC19-MaTSO/CEC19_MaTSO1.m" title="Many-task · Single-objective · None"><code>CEC19_MaTSO1</code></a><br><a href="../MTO/Problems/Multi-task/CEC19-MaTSO/CEC19_MaTSO2.m" title="Many-task · Single-objective · None"><code>CEC19_MaTSO2</code></a><br><a href="../MTO/Problems/Multi-task/CEC19-MaTSO/CEC19_MaTSO3.m" title="Many-task · Single-objective · None"><code>CEC19_MaTSO3</code></a><br><a href="../MTO/Problems/Multi-task/CEC19-MaTSO/CEC19_MaTSO4.m" title="Many-task · Single-objective · None"><code>CEC19_MaTSO4</code></a><br><a href="../MTO/Problems/Multi-task/CEC19-MaTSO/CEC19_MaTSO5.m" title="Many-task · Single-objective · None"><code>CEC19_MaTSO5</code></a><br><a href="../MTO/Problems/Multi-task/CEC19-MaTSO/CEC19_MaTSO6.m" title="Many-task · Single-objective · None"><code>CEC19_MaTSO6</code></a></details></td>
<td>Configurable T; D=50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Many-task benchmark: six implemented function families.</td>
<td><a href="http://www.bdsc.site/websites/MTO_competiton_2019/MTO_Competition_CEC_2019.html" title="CEC 2019 Competition on Evolutionary Multi-task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@misc{Feng2019Competition,
  title      = {CEC 2019 Competition on Evolutionary Multi-task Optimization},
  author     = {Feng, Liang and Qin, Kai and Gupta, Abhishek and Yuan, Yuan and Ong, Yew-Soon and Chi, Xu},
  year       = {2019},
  url        = {http://www.bdsc.site/websites/MTO_competiton_2019/MTO_Competition_CEC_2019.html},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Problems/Multi-task/Many-task%20CEC-SO/MaT_CEC17_SO.m">MaT-CEC17-SO</a> (Tech. Rep.)</td>
<td><a href="../MTO/Problems/Multi-task/Many-task%20CEC-SO/MaT_CEC17_SO.m">1 class</a></td>
<td>T=87; D=10/30/50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Aggregates 29 CEC17 functions at three dimensions.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Awad2017CEC17-SO,
  title      = {Problem Definitions and Evaluation Criteria for the CEC 2017 Special Session and Competition on Single Objective Bound Constrained Real-Parameter Numerical Optimization},
  author     = {N. H. Awad and M. Z. Ali and J. J. Liang and B. Y. Qu and P. N. Suganthan},
  journal    = {Technical Report, Nanyang Technological University, Singapore},
  year       = {2017},
}
```

</details>
</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)

## Single-objective stream-task optimization

<table>
<thead>
<tr><th>Year ↓</th><th>Suite / source</th><th>Classes</th><th>Scale (T tasks; D variables)</th><th>Characteristics</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2026</td>
<td><a href="../MTO/Problems/Stream-task/AMaTSO10/AMaTSO10.m">AMaTSO10</a> (TSMC-S)</td>
<td><a href="../MTO/Problems/Stream-task/AMaTSO10/AMaTSO10.m">1 class</a></td>
<td>T=10; D=25/50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Stream; reproducible asynchronous many-task arrivals.</td>
<td><a href="https://doi.org/10.1109/TSMC.2026.3658328" title="Multitense Knowledge Transfer for Asynchronous Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Han2026KR_AMTEA,
  title      = {Multitense Knowledge Transfer for Asynchronous Multitasking Optimization},
  author     = {Han, Honggui and Zhao, Ben and Wu, Xiaolong and Li, Xin},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2026},
  volume     = {56},
  number     = {5},
  pages      = {3370--3383},
  doi        = {10.1109/TSMC.2026.3658328},
}
```

</details>
</td>
</tr>
<tr>
<td>2026</td>
<td><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P1.m">AMTSO-Case1</a> (TSMC-S)</td>
<td><details><summary>9 classes</summary><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P1.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case1_P1</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P2.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case1_P2</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P3.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case1_P3</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P4.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case1_P4</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P5.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case1_P5</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P6.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case1_P6</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P7.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case1_P7</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P8.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case1_P8</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case1/AMTSO_Case1_P9.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case1_P9</code></a></details></td>
<td>T=2; D=25/50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Stream; second task arrives halfway through the first task budget.</td>
<td><a href="https://doi.org/10.1109/TSMC.2026.3658328" title="Multitense Knowledge Transfer for Asynchronous Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Han2026KR_AMTEA,
  title      = {Multitense Knowledge Transfer for Asynchronous Multitasking Optimization},
  author     = {Han, Honggui and Zhao, Ben and Wu, Xiaolong and Li, Xin},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2026},
  volume     = {56},
  number     = {5},
  pages      = {3370--3383},
  doi        = {10.1109/TSMC.2026.3658328},
}
```

</details>
</td>
</tr>
<tr>
<td>2026</td>
<td><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P1.m">AMTSO-Case2</a> (TSMC-S)</td>
<td><details><summary>9 classes</summary><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P1.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case2_P1</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P2.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case2_P2</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P3.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case2_P3</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P4.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case2_P4</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P5.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case2_P5</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P6.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case2_P6</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P7.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case2_P7</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P8.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case2_P8</code></a><br><a href="../MTO/Problems/Stream-task/AMTSO-Case2/AMTSO_Case2_P9.m" title="Multi-task · Single-objective · None · Stream"><code>AMTSO_Case2_P9</code></a></details></td>
<td>T=2; D=25/50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Stream; second task arrives when the first task exhausts its budget.</td>
<td><a href="https://doi.org/10.1109/TSMC.2026.3658328" title="Multitense Knowledge Transfer for Asynchronous Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Han2026KR_AMTEA,
  title      = {Multitense Knowledge Transfer for Asynchronous Multitasking Optimization},
  author     = {Han, Honggui and Zhao, Ben and Wu, Xiaolong and Li, Xin},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2026},
  volume     = {56},
  number     = {5},
  pages      = {3370--3383},
  doi        = {10.1109/TSMC.2026.3658328},
}
```

</details>
</td>
</tr>
<tr>
<td>2026</td>
<td><a href="../MTO/Problems/Stream-task/APKACP/APKACP_10.m">APKACP-10 / APKACP-20</a> (TSMC-S)</td>
<td><details><summary>2 classes</summary><a href="../MTO/Problems/Stream-task/APKACP/APKACP_10.m" title="Many-task · Single-objective · None · Stream"><code>APKACP_10</code></a><br><a href="../MTO/Problems/Stream-task/APKACP/APKACP_20.m" title="Many-task · Single-objective · None · Stream"><code>APKACP_20</code></a></details></td>
<td>T=10/20; configurable D</td>
<td><strong>Application</strong> · unconstrained<br>Stream; seeded planar-arm instances and FE-based task arrivals.</td>
<td><a href="https://doi.org/10.1109/TSMC.2026.3658328" title="Multitense Knowledge Transfer for Asynchronous Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Han2026KR_AMTEA,
  title      = {Multitense Knowledge Transfer for Asynchronous Multitasking Optimization},
  author     = {Han, Honggui and Zhao, Ben and Wu, Xiaolong and Li, Xin},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2026},
  volume     = {56},
  number     = {5},
  pages      = {3370--3383},
  doi        = {10.1109/TSMC.2026.3658328},
}
```

</details>
</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)

## Single-objective single-task optimization

<table>
<thead>
<tr><th>Year ↓</th><th>Suite / source</th><th>Classes</th><th>Scale (T tasks; D variables)</th><th>Characteristics</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2022</td>
<td><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO1.m">CEC22-SO</a> (Tech. Rep.)</td>
<td><details><summary>12 classes</summary><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO1.m" title="Single-task · Single-objective · None"><code>CEC22_SO1</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO2.m" title="Single-task · Single-objective · None"><code>CEC22_SO2</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO3.m" title="Single-task · Single-objective · None"><code>CEC22_SO3</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO4.m" title="Single-task · Single-objective · None"><code>CEC22_SO4</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO5.m" title="Single-task · Single-objective · None"><code>CEC22_SO5</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO6.m" title="Single-task · Single-objective · None"><code>CEC22_SO6</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO7.m" title="Single-task · Single-objective · None"><code>CEC22_SO7</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO8.m" title="Single-task · Single-objective · None"><code>CEC22_SO8</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO9.m" title="Single-task · Single-objective · None"><code>CEC22_SO9</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO10.m" title="Single-task · Single-objective · None"><code>CEC22_SO10</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO11.m" title="Single-task · Single-objective · None"><code>CEC22_SO11</code></a><br><a href="../MTO/Problems/Single-task/CEC22-SO/CEC22_SO12.m" title="Single-task · Single-objective · None"><code>CEC22_SO12</code></a></details></td>
<td>T=1; D=10/20</td>
<td><strong>Benchmark</strong> · unconstrained<br>Bound-constrained CEC 2022 benchmark.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Kumar2022CEC22-SO,
  title      = {Problem Definitions and Evaluation Criteria for the CEC 2022 Special Session and Competition on Single Objective Bound Constrained Numerical Optimization},
  author     = {Abhishek Kumar and Kenneth V. Price and Ali Wagdy Mohamed and Anas A. Hadi and P. N.Suganthan},
  year       = {2022},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO1.m">CEC20-RWCO</a> (SWEVO)</td>
<td><details><summary>57 classes</summary><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO1.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO1</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO2.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO2</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO3.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO3</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO4.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO4</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO5.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO5</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO6.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO6</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO7.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO7</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO8.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO8</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO9.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO9</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO10.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO10</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO11.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO11</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO12.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO12</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO13.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO13</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO14.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO14</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO15.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO15</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO16.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO16</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO17.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO17</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO18.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO18</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO19.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO19</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO20.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO20</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO21.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO21</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO22.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO22</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO23.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO23</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO24.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO24</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO25.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO25</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO26.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO26</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO27.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO27</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO28.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO28</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO29.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO29</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO30.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO30</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO31.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO31</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO32.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO32</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO33.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO33</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO34.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO34</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO35.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO35</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO36.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO36</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO37.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO37</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO38.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO38</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO39.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO39</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO40.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO40</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO41.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO41</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO42.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO42</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO43.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO43</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO44.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO44</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO45.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO45</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO46.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO46</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO47.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO47</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO48.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO48</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO49.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO49</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO50.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO50</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO51.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO51</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO52.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO52</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO53.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO53</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO54.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO54</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO55.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO55</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO56.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO56</code></a><br><a href="../MTO/Problems/Single-task/CEC20-RWCO/Class/CEC20_RWCO57.m" title="Single-task · Single-objective · Constrained"><code>CEC20_RWCO57</code></a></details></td>
<td>T=1; case-dependent D</td>
<td><strong>Benchmark</strong> · constrained<br>Real-world constrained CEC 2020 benchmark.</td>
<td><a href="https://doi.org/10.1016/j.swevo.2020.100693" title="A Test-suite of Non-convex Constrained Optimization Problems from the Real-world and Some Baseline Results">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Kumar2020CEC20-RWCO,
  title      = {A Test-suite of Non-convex Constrained Optimization Problems from the Real-world and Some Baseline Results},
  author     = {Abhishek Kumar and Guohua Wu and Mostafa Z. Ali and Rammohan Mallipeddi and Ponnuthurai Nagaratnam Suganthan and Swagatam Das},
  journal    = {Swarm and Evolutionary Computation},
  year       = {2020},
  volume     = {56},
  pages      = {100693},
  doi        = {10.1016/j.swevo.2020.100693},
  issn       = {2210-6502},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO1.m">CEC17-CSO</a> (Tech. Rep.)</td>
<td><details><summary>28 classes</summary><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO1.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO1</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO2.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO2</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO3.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO3</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO4.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO4</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO5.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO5</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO6.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO6</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO7.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO7</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO8.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO8</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO9.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO9</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO10.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO10</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO11.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO11</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO12.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO12</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO13.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO13</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO14.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO14</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO15.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO15</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO16.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO16</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO17.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO17</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO18.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO18</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO19.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO19</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO20.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO20</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO21.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO21</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO22.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO22</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO23.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO23</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO24.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO24</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO25.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO25</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO26.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO26</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO27.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO27</code></a><br><a href="../MTO/Problems/Single-task/CEC17-CSO/Class/CEC17_CSO28.m" title="Single-task · Single-objective · Constrained"><code>CEC17_CSO28</code></a></details></td>
<td>T=1; configurable D</td>
<td><strong>Benchmark</strong> · constrained<br>Constrained CEC 2017 benchmark.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wu2017CEC17-CSO,
  title      = {Problem Definitions and Evaluation Criteria for the Cec 2017 Competition on Constrained Real-parameter Optimization},
  author     = {Wu, Guohua and Mallipeddi, Rammohan and Suganthan, Ponnuthurai Nagaratnam},
  journal    = {National University of Defense Technology, Changsha, Hunan, PR China and Kyungpook National University, Daegu, South Korea and Nanyang Technological University, Singapore, Technical Report},
  year       = {2017},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO1.m">CEC17-SO</a> (Tech. Rep.)</td>
<td><details><summary>29 classes</summary><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO1.m" title="Single-task · Single-objective · None"><code>CEC17_SO1</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO2.m" title="Single-task · Single-objective · None"><code>CEC17_SO2</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO3.m" title="Single-task · Single-objective · None"><code>CEC17_SO3</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO4.m" title="Single-task · Single-objective · None"><code>CEC17_SO4</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO5.m" title="Single-task · Single-objective · None"><code>CEC17_SO5</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO6.m" title="Single-task · Single-objective · None"><code>CEC17_SO6</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO7.m" title="Single-task · Single-objective · None"><code>CEC17_SO7</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO8.m" title="Single-task · Single-objective · None"><code>CEC17_SO8</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO9.m" title="Single-task · Single-objective · None"><code>CEC17_SO9</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO10.m" title="Single-task · Single-objective · None"><code>CEC17_SO10</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO11.m" title="Single-task · Single-objective · None"><code>CEC17_SO11</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO12.m" title="Single-task · Single-objective · None"><code>CEC17_SO12</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO13.m" title="Single-task · Single-objective · None"><code>CEC17_SO13</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO14.m" title="Single-task · Single-objective · None"><code>CEC17_SO14</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO15.m" title="Single-task · Single-objective · None"><code>CEC17_SO15</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO16.m" title="Single-task · Single-objective · None"><code>CEC17_SO16</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO17.m" title="Single-task · Single-objective · None"><code>CEC17_SO17</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO18.m" title="Single-task · Single-objective · None"><code>CEC17_SO18</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO19.m" title="Single-task · Single-objective · None"><code>CEC17_SO19</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO20.m" title="Single-task · Single-objective · None"><code>CEC17_SO20</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO21.m" title="Single-task · Single-objective · None"><code>CEC17_SO21</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO22.m" title="Single-task · Single-objective · None"><code>CEC17_SO22</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO23.m" title="Single-task · Single-objective · None"><code>CEC17_SO23</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO24.m" title="Single-task · Single-objective · None"><code>CEC17_SO24</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO25.m" title="Single-task · Single-objective · None"><code>CEC17_SO25</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO26.m" title="Single-task · Single-objective · None"><code>CEC17_SO26</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO27.m" title="Single-task · Single-objective · None"><code>CEC17_SO27</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO28.m" title="Single-task · Single-objective · None"><code>CEC17_SO28</code></a><br><a href="../MTO/Problems/Single-task/CEC17-SO/CEC17_SO29.m" title="Single-task · Single-objective · None"><code>CEC17_SO29</code></a></details></td>
<td>T=1; configurable D</td>
<td><strong>Benchmark</strong> · unconstrained<br>Bound-constrained CEC 2017 benchmark; 29 implemented classes.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Awad2017CEC17-SO,
  title      = {Problem Definitions and Evaluation Criteria for the CEC 2017 Special Session and Competition on Single Objective Bound Constrained Real-Parameter Numerical Optimization},
  author     = {N. H. Awad and M. Z. Ali and J. J. Liang and B. Y. Qu and P. N. Suganthan},
  journal    = {Technical Report, Nanyang Technological University, Singapore},
  year       = {2017},
}
```

</details>
</td>
</tr>
<tr>
<td>2013</td>
<td><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Ackley.m">Classical functions</a> (IJMMNO)</td>
<td><details><summary>9 classes</summary><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Ackley.m" title="Single-task · Single-objective · None"><code>Func_Ackley</code></a><br><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Elliptic.m" title="Single-task · Single-objective · None"><code>Func_Elliptic</code></a><br><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Griewank.m" title="Single-task · Single-objective · None"><code>Func_Griewank</code></a><br><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Rastrigin.m" title="Single-task · Single-objective · None"><code>Func_Rastrigin</code></a><br><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Rosenbrock.m" title="Single-task · Single-objective · None"><code>Func_Rosenbrock</code></a><br><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Schwefel.m" title="Single-task · Single-objective · None"><code>Func_Schwefel</code></a><br><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Schwefel2.m" title="Single-task · Single-objective · None"><code>Func_Schwefel2</code></a><br><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Sphere.m" title="Single-task · Single-objective · None"><code>Func_Sphere</code></a><br><a href="../MTO/Problems/Single-task/Classical%20Function/Func_Weierstrass.m" title="Single-task · Single-objective · None"><code>Func_Weierstrass</code></a></details></td>
<td>T=1; configurable D</td>
<td><strong>Benchmark</strong> · unconstrained<br>Ackley, Elliptic, Griewank, Rastrigin, Rosenbrock, Schwefel, Schwefel2, Sphere, Weierstrass.</td>
<td><a href="https://doi.org/10.1504/IJMMNO.2013.055204" title="A Literature Survey of Benchmark Functions for Global Optimisation Problems">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Jamil2013Functions,
  title      = {A Literature Survey of Benchmark Functions for Global Optimisation Problems},
  author     = {Jamil, Momin and Yang, Xin-She},
  journal    = {International Journal of Mathematical Modelling and Numerical Optimisation},
  year       = {2013},
  volume     = {4},
  number     = {2},
  pages      = {150},
  doi        = {10.1504/IJMMNO.2013.055204},
}
```

</details>
</td>
</tr>
<tr>
<td>2010</td>
<td><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO1.m">CEC10-CSO</a> (Tech. Rep.)</td>
<td><details><summary>18 classes</summary><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO1.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO1</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO2.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO2</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO3.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO3</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO4.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO4</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO5.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO5</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO6.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO6</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO7.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO7</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO8.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO8</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO9.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO9</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO10.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO10</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO11.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO11</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO12.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO12</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO13.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO13</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO14.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO14</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO15.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO15</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO16.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO16</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO17.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO17</code></a><br><a href="../MTO/Problems/Single-task/CEC10-CSO/Class/CEC10_CSO18.m" title="Single-task · Single-objective · Constrained"><code>CEC10_CSO18</code></a></details></td>
<td>T=1; configurable D</td>
<td><strong>Benchmark</strong> · constrained<br>Constrained CEC 2010 benchmark.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Mallipeddi2010CEC10-CSO,
  title      = {Problem Definitions and Evaluation Criteria for the Cec 2010 Competition on Constrained Real-parameter Optimization},
  author     = {Mallipeddi, Rammohan and Suganthan, Ponnuthurai},
  year       = {2010},
  month      = {05},
}
```

</details>
</td>
</tr>
<tr>
<td>2006</td>
<td><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO1.m">CEC06-CSO</a> (Tech. Rep.)</td>
<td><details><summary>24 classes</summary><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO1.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO1</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO2.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO2</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO3.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO3</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO4.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO4</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO5.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO5</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO6.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO6</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO7.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO7</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO8.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO8</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO9.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO9</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO10.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO10</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO11.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO11</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO12.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO12</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO13.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO13</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO14.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO14</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO15.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO15</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO16.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO16</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO17.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO17</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO18.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO18</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO19.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO19</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO20.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO20</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO21.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO21</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO22.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO22</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO23.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO23</code></a><br><a href="../MTO/Problems/Single-task/CEC06-CSO/Class/CEC06_CSO24.m" title="Single-task · Single-objective · Constrained"><code>CEC06_CSO24</code></a></details></td>
<td>T=1; case-dependent D</td>
<td><strong>Benchmark</strong> · constrained<br>Constrained CEC 2006 benchmark.</td>
<td><a href="https://sites.google.com/view/suganthan-p-n/cec-benchmark/cec06-special-session" title="CEC 2006 constrained optimization benchmark report">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@TechReport{Liang2006CEC06-CSO,
  title       = {Problem Definitions and Evaluation Criteria for the {CEC} 2006 Special Session on Constrained Real-Parameter Optimization},
  author      = {Liang, J. J. and Runarsson, Thomas Philip and Mezura-Montes, Efren and Clerc, Maurice and Suganthan, Ponnuthurai Nagaratnam and Coello Coello, Carlos A. and Deb, Kalyanmoy},
  institution = {Nanyang Technological University},
  year        = {2006},
  type        = {Technical Report},
  url         = {https://sites.google.com/view/suganthan-p-n/cec-benchmark/cec06-special-session},
}
```

</details>
</td>
</tr>
<tr>
<td>—</td>
<td><a href="../MTO/Problems/Single-task/ATF/ATF1.m">ATF</a></td>
<td><details><summary>2 classes</summary><a href="../MTO/Problems/Single-task/ATF/ATF1.m" title="Single-task · Single-objective · Constrained"><code>ATF1</code></a><br><a href="../MTO/Problems/Single-task/ATF/ATF2.m" title="Single-task · Single-objective · Constrained"><code>ATF2</code></a></details></td>
<td>T=1; D=2</td>
<td><strong>Benchmark</strong> · constrained<br>Constrained Rastrigin functions with two different feasible regions.</td>
<td>—</td>
<td>—</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)

## Multiobjective multitask optimization

<table>
<thead>
<tr><th>Year ↓</th><th>Suite / source</th><th>Classes</th><th>Scale (T tasks; D variables)</th><th>Characteristics</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2025</td>
<td><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT1.m">CMOMT</a> (TEVC)</td>
<td><details><summary>12 classes</summary><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT1.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT1</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT2.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT2</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT3.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT3</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT4.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT4</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT5.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT5</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT6.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT6</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT7.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT7</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT8.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT8</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT9.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT9</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT10.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT10</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT11.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT11</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/Competitive-CMOMT/CMOMT12.m" title="Multi-task · Multi-objective · Competitive"><code>CMOMT12</code></a></details></td>
<td>T=2/3; D=30–70</td>
<td><strong>Benchmark</strong> · competitive<br>2–3 objectives.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3524508" title="Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2025CMO-MTO,
  title      = {Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions},
  author     = {Li, Yanchi and Wu, Xinyi and Gong, Wenyin and Xu, Meng and Wang, Yubo and Gu, Qiong},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2025},
  volume     = {29},
  number     = {6},
  pages      = {2757-2770},
  doi        = {10.1109/TEVC.2024.3524508},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Sensor%20Coverage%20Problem/MOSCP2.m">MOSCP2</a> (TEVC)</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Sensor%20Coverage%20Problem/MOSCP2.m">1 class</a></td>
<td>Configurable T/D</td>
<td><strong>Application</strong> · unconstrained / competitive<br>Sensor coverage.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3524508" title="Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2025CMO-MTO,
  title      = {Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions},
  author     = {Li, Yanchi and Wu, Xinyi and Gong, Wenyin and Xu, Meng and Wang, Yubo and Gu, Qiong},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2025},
  volume     = {29},
  number     = {6},
  pages      = {2757-2770},
  doi        = {10.1109/TEVC.2024.3524508},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Competitive%20Multiobjective%20Optimal%20Power%20Flow/OPF_CMTMO1.m">OPF-CMTMO</a> (TEVC)</td>
<td><details><summary>4 classes</summary><a href="../MTO/Problems/Real-world%20Applications/Competitive%20Multiobjective%20Optimal%20Power%20Flow/OPF_CMTMO1.m" title="Multi-task · Multi-objective · Constrained/Competitive"><code>OPF_CMTMO1</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Competitive%20Multiobjective%20Optimal%20Power%20Flow/OPF_CMTMO2.m" title="Multi-task · Multi-objective · Constrained/Competitive"><code>OPF_CMTMO2</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Competitive%20Multiobjective%20Optimal%20Power%20Flow/OPF_CMTMO3.m" title="Multi-task · Multi-objective · Constrained/Competitive"><code>OPF_CMTMO3</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Competitive%20Multiobjective%20Optimal%20Power%20Flow/OPF_CMTMO4.m" title="Multi-task · Multi-objective · Constrained/Competitive"><code>OPF_CMTMO4</code></a></details></td>
<td>T=2; D=11/24</td>
<td><strong>Application</strong> · constrained / competitive<br>Thermal and wind/solar optimal power flow.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3524508" title="Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2025CMO-MTO,
  title      = {Evolutionary Competitive Multiobjective Multitasking: One-Pass Optimization of Heterogeneous Pareto Solutions},
  author     = {Li, Yanchi and Wu, Xinyi and Gong, Wenyin and Xu, Meng and Wang, Yubo and Gu, Qiong},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2025},
  volume     = {29},
  number     = {6},
  pages      = {2757-2770},
  doi        = {10.1109/TEVC.2024.3524508},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Optimal%20Power%20Flow/OPF_MTMO1.m">OPF-MTMO</a> (TEVC / ASOC)</td>
<td><details><summary>4 classes</summary><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Optimal%20Power%20Flow/OPF_MTMO1.m" title="Multi-task · Multi-objective · Constrained"><code>OPF_MTMO1</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Optimal%20Power%20Flow/OPF_MTMO2.m" title="Multi-task · Multi-objective · Constrained"><code>OPF_MTMO2</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Optimal%20Power%20Flow/OPF_MTMO3.m" title="Multi-task · Multi-objective · Constrained"><code>OPF_MTMO3</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Optimal%20Power%20Flow/OPF_MTMO4.m" title="Multi-task · Multi-objective · Constrained"><code>OPF_MTMO4</code></a></details></td>
<td>T=2; D=24/33</td>
<td><strong>Application</strong> · constrained<br>Optimal power flow.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3353319" title="Multiobjective Multitask Optimization With Multiple Knowledge Types and Transfer Adaptation">Link</a></td>
<td>
<details>
<summary>BibTeX · TEVC · 2025</summary>

```bibtex
@article{Li2025MTDE-MKTA,
  title      = {Multiobjective Multitask Optimization With Multiple Knowledge Types and Transfer Adaptation},
  author     = {Li, Yanchi and Gong, Wenyin},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2025},
  volume     = {29},
  number     = {1},
  pages      = {205-216},
  doi        = {10.1109/TEVC.2024.3353319},
}
```

</details>
<details>
<summary>BibTeX · ASOC · 2022</summary>

```bibtex
@article{Li2022Multi,
  title      = {Multi-Objective Optimal Power Flow with Stochastic Wind and Solar Power},
  author     = {Shuijia Li and Wenyin Gong and Ling Wang and Qiong Gu},
  journal    = {Applied Soft Computing},
  year       = {2022},
  volume     = {114},
  pages      = {108045},
  issn       = {1568-4946},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Synchronous%20Optimal%20Pulse-width%20Modulation/SOPM_MTMO1.m">SOPM-MTMO</a> (TEVC / SWEVO)</td>
<td><details><summary>2 classes</summary><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Synchronous%20Optimal%20Pulse-width%20Modulation/SOPM_MTMO1.m" title="Multi-task · Multi-objective · Constrained"><code>SOPM_MTMO1</code></a><br><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Synchronous%20Optimal%20Pulse-width%20Modulation/SOPM_MTMO2.m" title="Multi-task · Multi-objective · Constrained"><code>SOPM_MTMO2</code></a></details></td>
<td>T=3; D=25/30</td>
<td><strong>Application</strong> · constrained<br>Synchronous optimal pulse-width modulation.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3353319" title="Multiobjective Multitask Optimization With Multiple Knowledge Types and Transfer Adaptation">Link</a></td>
<td>
<details>
<summary>BibTeX · TEVC · 2025</summary>

```bibtex
@article{Li2025MTDE-MKTA,
  title      = {Multiobjective Multitask Optimization With Multiple Knowledge Types and Transfer Adaptation},
  author     = {Li, Yanchi and Gong, Wenyin},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2025},
  volume     = {29},
  number     = {1},
  pages      = {205-216},
  doi        = {10.1109/TEVC.2024.3353319},
}
```

</details>
<details>
<summary>BibTeX · SWEVO · 2021</summary>

```bibtex
@article{Kumar2021RWMOP,
  title      = {A Benchmark-suite of Real-world Constrained Multi-objective Optimization Problems and Some Baseline Results},
  author     = {Abhishek Kumar and Guohua Wu and Mostafa Z. Ali and Qizhang Luo and Rammohan Mallipeddi and Ponnuthurai Nagaratnam Suganthan and Swagatam Das},
  journal    = {Swarm and Evolutionary Computation},
  year       = {2021},
  volume     = {67},
  pages      = {100961},
  issn       = {2210-6502},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Sensor%20Coverage%20Problem/MOSCP.m">MOSCP</a> (GECCO)</td>
<td><a href="../MTO/Problems/Real-world%20Applications/Multiobjective%20Sensor%20Coverage%20Problem/MOSCP.m">1 class</a></td>
<td>Configurable T/D</td>
<td><strong>Application</strong> · unconstrained / competitive<br>Sensor coverage; ordinary/competitive modes.</td>
<td><a href="https://doi.org/10.1145/3638529.3653989" title="Transfer Search Directions Among Decomposed Subtasks for Evolutionary Multitasking in Multiobjective Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Li2024MTEA-D-TSD,
  title      = {Transfer Search Directions Among Decomposed Subtasks for Evolutionary Multitasking in Multiobjective Optimization},
  author     = {Li, Yanchi and Gong, Wenyin and Gu, Qiong},
  booktitle  = {Proceedings of the Genetic and Evolutionary Computation Conference},
  year       = {2024},
  pages      = {557–565},
  publisher  = {Association for Computing Machinery},
  address    = {New York, NY, USA},
  doi        = {10.1145/3638529.3653989},
  isbn       = {9798400704949},
  series     = {GECCO '24},
  location   = {Melbourne, VIC, Australia},
  numpages   = {9},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX1.m">CEC21-MTMO-CPLX</a> (CEC · competition)</td>
<td><details><summary>10 classes</summary><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX1.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX1</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX2.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX2</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX3.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX3</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX4.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX4</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX5.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX5</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX6.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX6</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX7.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX7</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX8.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX8</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX9.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX9</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC21-MTMO-CPLX/CEC21_MTMO_CPLX10.m" title="Multi-task · Multi-objective · None"><code>CEC21_MTMO_CPLX10</code></a></details></td>
<td>T=2; D=50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Complex multitask benchmark; 2 objectives.</td>
<td><a href="http://www.bdsc.site/websites/MTO_competition_2021/MTO_Competition_CEC_2021.html" title="CEC 2021 Competition on Evolutionary Multi-task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@misc{Feng2021Competition,
  title      = {CEC 2021 Competition on Evolutionary Multi-task Optimization},
  author     = {Feng, Liang and Qin, Kai and Gupta, Abhishek and Yuan, Yuan and Scott, Eric and Ong, Yew-Soon and Chi, Xu},
  year       = {2021},
  url        = {http://www.bdsc.site/websites/MTO_competition_2021/MTO_Competition_CEC_2021.html},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX1.m">CEC19-MTMO-CPLX</a> (CEC · competition)</td>
<td><details><summary>10 classes</summary><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX1.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX1</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX2.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX2</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX3.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX3</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX4.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX4</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX5.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX5</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX6.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX6</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX7.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX7</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX8.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX8</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX9.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX9</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MTMO-CPLX/CEC19_MTMO_CPLX10.m" title="Multi-task · Multi-objective · None"><code>CEC19_MTMO_CPLX10</code></a></details></td>
<td>T=2; D=10/30</td>
<td><strong>Benchmark</strong> · unconstrained<br>Complex multitask benchmark; 2–3 objectives.</td>
<td><a href="http://www.bdsc.site/websites/MTO_competiton_2019/MTO_Competition_CEC_2019.html" title="CEC 2019 Competition on Evolutionary Multi-task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@misc{Feng2019Competition,
  title      = {CEC 2019 Competition on Evolutionary Multi-task Optimization},
  author     = {Feng, Liang and Qin, Kai and Gupta, Abhishek and Yuan, Yuan and Ong, Yew-Soon and Chi, Xu},
  year       = {2019},
  url        = {http://www.bdsc.site/websites/MTO_competiton_2019/MTO_Competition_CEC_2019.html},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO1_CI_HS.m">CEC17-MTMO</a> (arXiv)</td>
<td><details><summary>9 classes</summary><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO1_CI_HS.m" title="Multi-task · Multi-objective · None"><code>CEC17_MTMO1_CI_HS</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO2_CI_MS.m" title="Multi-task · Multi-objective · None"><code>CEC17_MTMO2_CI_MS</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO3_CI_LS.m" title="Multi-task · Multi-objective · None"><code>CEC17_MTMO3_CI_LS</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO4_PI_HS.m" title="Multi-task · Multi-objective · None"><code>CEC17_MTMO4_PI_HS</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO5_PI_MS.m" title="Multi-task · Multi-objective · None"><code>CEC17_MTMO5_PI_MS</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO6_PI_LS.m" title="Multi-task · Multi-objective · None"><code>CEC17_MTMO6_PI_LS</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO7_NI_HS.m" title="Multi-task · Multi-objective · None"><code>CEC17_MTMO7_NI_HS</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO8_NI_MS.m" title="Multi-task · Multi-objective · None"><code>CEC17_MTMO8_NI_MS</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC17-MTMO/CEC17_MTMO9_NI_LS.m" title="Multi-task · Multi-objective · None"><code>CEC17_MTMO9_NI_LS</code></a></details></td>
<td>T=2; D=10–50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Nine overlap/similarity combinations; 2–3 objectives.</td>
<td><a href="https://arxiv.org/abs/1706.02766" title="Evolutionary Multitasking for Multiobjective Continuous Optimization: Benchmark Problems, Performance Metrics and Baseline Results">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Yuan2017CEC2017-MTMO,
  title      = {Evolutionary Multitasking for Multiobjective Continuous Optimization: Benchmark Problems, Performance Metrics and Baseline Results},
  author     = {Yuan, Yuan and Ong, Yew-Soon and Feng, Liang and Qin, A Kai and Gupta, Abhishek and Da, Bingshui and Zhang, Qingfu and Tan, Kay Chen and Jin, Yaochu and Ishibuchi, Hisao},
  journal    = {arXiv preprint arXiv:1706.02766},
  year       = {2017},
  file       = {:Yuan2017CEC2017-MTMO - Evolutionary Multitasking for Multiobjective Continuous Optimization_ Benchmark Problems, Performance Metrics and Baseline Results.pdf:PDF},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Problems/Multi-objective%20Multi-task/MTMO-Instance/MTMO_Instance1.m">MTMO-Instance</a> (TCYB)</td>
<td><details><summary>2 classes</summary><a href="../MTO/Problems/Multi-objective%20Multi-task/MTMO-Instance/MTMO_Instance1.m" title="Multi-task · Multi-objective · None"><code>MTMO_Instance1</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/MTMO-Instance/MTMO_Instance2.m" title="Multi-task · Multi-objective · Constrained"><code>MTMO_Instance2</code></a></details></td>
<td>T=2; D=10</td>
<td><strong>Benchmark</strong> · unconstrained / constrained<br>Two multiobjective multifactorial problem instances.</td>
<td><a href="https://doi.org/10.1109/TCYB.2016.2554622" title="Multiobjective Multifactorial Optimization in Evolutionary Multitasking">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Gupta2017MO-MFEA,
  title      = {Multiobjective Multifactorial Optimization in Evolutionary Multitasking},
  author     = {Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang and Tan, Kay Chen},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2017},
  volume     = {47},
  number     = {7},
  pages      = {1652-1665},
  doi        = {10.1109/TCYB.2016.2554622},
}
```

</details>
</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)

## Multiobjective many-task optimization

<table>
<thead>
<tr><th>Year ↓</th><th>Suite / source</th><th>Classes</th><th>Scale (T tasks; D variables)</th><th>Characteristics</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2020</td>
<td><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO1.m">WCCI20-MaTMO</a> (WCCI · competition)</td>
<td><details><summary>10 classes</summary><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO1.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO1</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO2.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO2</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO3.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO3</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO4.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO4</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO5.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO5</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO6.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO6</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO7.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO7</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO8.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO8</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO9.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO9</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/WCCI20-MaTMO/WCCI20_MaTMO10.m" title="Many-task · Multi-objective · None"><code>WCCI20_MaTMO10</code></a></details></td>
<td>Configurable T; D=50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Complex many-task benchmark; 2 objectives.</td>
<td><a href="http://www.bdsc.site/websites/MTO_competition_2020/MTO_Competition_WCCI_2020.html" title="WCCI 2020 Competition on Evolutionary Multi-task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@misc{Feng2020Competition,
  title      = {WCCI 2020 Competition on Evolutionary Multi-task Optimization},
  author     = {Feng, Liang and Qin, Kai and Gupta, Abhishek and Yuan, Yuan and Ong, Yew-Soon and Chi, Xu},
  year       = {2020},
  url        = {http://www.bdsc.site/websites/MTO_competition_2020/MTO_Competition_WCCI_2020.html},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MaTMO/CEC19_MaTMO1.m">CEC19-MaTMO</a> (CEC · competition)</td>
<td><details><summary>6 classes</summary><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MaTMO/CEC19_MaTMO1.m" title="Many-task · Multi-objective · None"><code>CEC19_MaTMO1</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MaTMO/CEC19_MaTMO2.m" title="Many-task · Multi-objective · None"><code>CEC19_MaTMO2</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MaTMO/CEC19_MaTMO3.m" title="Many-task · Multi-objective · None"><code>CEC19_MaTMO3</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MaTMO/CEC19_MaTMO4.m" title="Many-task · Multi-objective · None"><code>CEC19_MaTMO4</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MaTMO/CEC19_MaTMO5.m" title="Many-task · Multi-objective · None"><code>CEC19_MaTMO5</code></a><br><a href="../MTO/Problems/Multi-objective%20Multi-task/CEC19-MaTMO/CEC19_MaTMO6.m" title="Many-task · Multi-objective · None"><code>CEC19_MaTMO6</code></a></details></td>
<td>Configurable T; D=10/50</td>
<td><strong>Benchmark</strong> · unconstrained<br>Six implemented many-task families; 2 objectives.</td>
<td><a href="http://www.bdsc.site/websites/MTO_competiton_2019/MTO_Competition_CEC_2019.html" title="CEC 2019 Competition on Evolutionary Multi-task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@misc{Feng2019Competition,
  title      = {CEC 2019 Competition on Evolutionary Multi-task Optimization},
  author     = {Feng, Liang and Qin, Kai and Gupta, Abhishek and Yuan, Yuan and Ong, Yew-Soon and Chi, Xu},
  year       = {2019},
  url        = {http://www.bdsc.site/websites/MTO_competiton_2019/MTO_Competition_CEC_2019.html},
}
```

</details>
</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)

## Multiobjective single-task optimization

<table>
<thead>
<tr><th>Year ↓</th><th>Suite / source</th><th>Classes</th><th>Scale (T tasks; D variables)</th><th>Characteristics</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2005</td>
<td><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ1.m">DTLZ1–DTLZ9</a> (Springer · chapter)</td>
<td><details><summary>9 classes</summary><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ1.m" title="Single-task · Multi-objective/Many-objective · None"><code>DTLZ1</code></a><br><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ2.m" title="Single-task · Multi-objective/Many-objective · None"><code>DTLZ2</code></a><br><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ3.m" title="Single-task · Multi-objective/Many-objective · None"><code>DTLZ3</code></a><br><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ4.m" title="Single-task · Multi-objective/Many-objective · None"><code>DTLZ4</code></a><br><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ5.m" title="Single-task · Multi-objective/Many-objective · None"><code>DTLZ5</code></a><br><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ6.m" title="Single-task · Multi-objective/Many-objective · None"><code>DTLZ6</code></a><br><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ7.m" title="Single-task · Multi-objective/Many-objective · None"><code>DTLZ7</code></a><br><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ8.m" title="Single-task · Multi-objective/Many-objective · Constrained"><code>DTLZ8</code></a><br><a href="../MTO/Problems/Multi-objective%20Single-task/DTLZ/DTLZ9.m" title="Single-task · Multi-objective/Many-objective · Constrained"><code>DTLZ9</code></a></details></td>
<td>T=1; configurable D/M</td>
<td><strong>Benchmark</strong> · unconstrained / constrained<br>Multi-/many-objective; DTLZ8 and DTLZ9 are constrained.</td>
<td><a href="https://doi.org/10.1007/1-84628-137-7_6" title="Scalable Test Problems for Evolutionary Multiobjective Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inbook{Deb2005DTLZ,
  title      = {Scalable Test Problems for Evolutionary Multiobjective Optimization},
  author     = {Deb, Kalyanmoy and Thiele, Lothar and Laumanns, Marco and Zitzler, Eckart},
  booktitle  = {Evolutionary Multiobjective Optimization: Theoretical Advances and Applications},
  editor     = {Abraham, Ajith and Jain, Lakhmi and Goldberg, Robert},
  year       = {2005},
  pages      = {105--145},
  publisher  = {Springer London},
  address    = {London},
  doi        = {10.1007/1-84628-137-7_6},
  isbn       = {978-1-84628-137-2},
}
```

</details>
</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)
