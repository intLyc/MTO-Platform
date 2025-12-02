# Multitask Optimization Platform (MToP)

[![](https://img.shields.io/badge/Download-Latest-green)](https://github.com/intLyc/MTO-Platform/archive/refs/heads/master.zip)
[![](https://img.shields.io/badge/Release-v1.9-orange)](#mto-platform)
[![](https://img.shields.io/badge/Matlab-%3E%3DR2022b-blue)](#mto-platform)

[![GitHub Repo stars](https://img.shields.io/github/stars/intLyc/MTO-Platform?style=social)](#mto-platform)
[![GitHub forks](https://img.shields.io/github/forks/intLyc/MTO-Platform?style=social)](#mto-platform)
[![GitHub watchers](https://img.shields.io/github/watchers/intLyc/MTO-Platform?style=social)](#mto-platform)

<img src="./Doc/ReadmeFigure/CMT-LandScape.png" width="200px"><img src="./Doc/ReadmeFigure/MaT-LandScape.png" width="200px"><img src="./Doc/ReadmeFigure/CpMT-LandScape.png" width="200px">

We introduce the multitask benchmarking platform, named **MToP**, for evolutionary multitasking:

- 50+ multitask evolutionary algorithms for multitask optimization
- 50+ single-task evolutionary algorithms that can handle multitask optimization problems
- 200+ multitask optimization problem cases with real-world applications
- 150+ classical single-task optimization benchmark problems
- 20+ performance metrics covering single- and multi-objective optimization

MToP is a user-friendly tool with a graphical user interface that makes it easy to analyze results, export data, and plot schematics. More importantly, MToP is extensible, allowing users to develop new algorithms and define new problems.

### 📄 Documents

[**[Paper]**](https://arxiv.org/abs/2312.08134)
: Paper introducing MToP in detail.

[**[User Guide]**](./Doc/User-Guide.md)
: Brief guide on how to use MToP.

[**[Tables]**](./Doc/tables.pdf)
: Tables of algorithms, problems, and metrics.

### 💿 Data

In order to enhance reproducibility and avoid unnecessary repeated experiments, we provide the experimental data of algorithms on benchmark suites over 30 independent runs under fixed random seeds:

[**[Google Drive]**](https://drive.google.com/drive/folders/1IpwXNuOYcnpC3IXbAx3VnLGVV899k3bG?usp=share_link) /
[**[Hugging Face]**](https://huggingface.co/datasets/intLyc/MToP-MTOData/tree/main) /
[**[Baidu Netdisk]**](https://pan.baidu.com/s/1Pk06fBj_4gidkiZe4f1Oww?pwd=mtop)

## Copyright

> Copyright (c) Yanchi Li. You are free to use the MToP for research purposes. All publications which use this platform should acknowledge the use of MToP and cite as "Y. Li, W. Gong, T. Zhang, F. Ming, S. Li, Q. Gu, and Y.-S. Ong, MToP: A MATLAB Benchmarking Platform for Evolutionary Multitasking, 2023, arXiv:2312.08134"

```
@Article{Li2023MToP,
  title   = {{MToP}: A {MATLAB} Benchmarking Platform for Evolutionary Multitasking},
  author  = {Yanchi Li and Wenyin Gong and Tingyu Zhang and Fei Ming and Shuijia Li and Qiong Gu and Yew-Soon Ong},
  journal = {arXiv preprint arXiv:2312.08134},
  year    = {2023},
  eprint  = {2312.08134},
}
```

## Contact Us

*Email: <int_lyc@cug.edu.cn>*

*QQ Group: 862974231*

<img src="./Doc/ReadmeFigure/MToP-QQ-Group.jpg" width="150px">

## Release Highlights of MToP v1.9

**New Algorithms:** 🆕
- DTSKT (Single-objective Many-task TSMC 25)
- MTEA-PAE (Single-objective Multi-task ASOC 25)
- MO-MTEA-PAE (Multi-objective Multi-task ASOC 25)
- EMTO-AI (Single-objective Multi-task TETCI 24)

**New Problems:** 📊
- STOP-G (Many-task optimization problems TCYB 2025)

**New Features:** ✨
- Global **random seed control** using rng(seed + rep -1) for better reproducibility
- Add **IOHanalyzer** data type export to support more analysis tools
- Add option to **save best decision variables** during optimization
- Add competitive and constrained buttons to Experiment module for enhanced problem type support
- Add context menus component for **batch editing of problem public parameters** with dedicated editing dialog (thanks @Zhizhou-Geng)
- Integrate refresh functionality into right-click context menu with keyboard shortcuts

**Optimizations and Improvements:** ⚡
- Refactor constraint handling logic with full constraint support
- Add Evaluation method to Problem class for flexible evaluation
- Improve GUI display and user interface responsiveness
- Change relative data load path for improved file management
- Improve Experiment module buttons display and ordering
- Update CMA-ES related algorithms to follow official implementation
- Algorithm reloading now triggers automatically when clicking Add button

<details><summary><strong>Older Release Highlights (Click to Expand)</strong></summary>

## Release Highlights of MToP v1.8

- New Algorithm: SSLT (Single-objective Multi-task KBS-25)
- New Problems: MGA_DSM_GTOP and MGA-GTOP (Multi-task Global Trajectory Optimization Problem)
- Add the Friedman test for statistical analysis
- Add Convergence range drawing with 95% confidence interval
- Improve the GUI tooltip and description
- Fix some bugs

## Release Highlights of MToP v1.7

- New Algorithms: 
  - RVC-MTEA (Competitive Multi-objective Multi-task TEVC-24)
  - MTEA-DCK (Multi-objective Multi-task TSMC-S-25)
  - MFEA-VC (Single-objective Multi-task ASOC-24)
  - CMO-LKT (Constrained Single-objective Multi-task TSMC-S-25)
- New Problems:
  - CMOMT Benchmark (Competitive Multi-objective Multi-task TEVC-24)
  - MOSCP2 (Competitive Multi-objective Sensor Coverage Problem)
  - OPF-CMOMT (Competitive Multi-objective Optimal Power Flow)
- Optimize 2D Pareto Front drawing
- Add competitive multi-objective multi-task metric IGD-CMT and HV-CMT
- Update MTS metric with convergence for HV, IGD, and IGD+
- Fix MFEA-GHS domain adaptation bug
- Fix LDA-MFEA data size reduce method
- Fix NaN bug in IGD and IGD+ calculation

## Release Highlights of MToP v1.6

- Fix the bug of multifactorial algorithms run in many-task problems
- New Algorithm: 
  - TNG-NES (Single-objective Many-task TEVC24)
  - MTDE-ADKT (Single-objective Multi-task ASOC24)
  - AR-MOEA, MSEA (Multi-objective Single-task)
- New Problem: LSMaTSO (Large-scale many-task single-objective)

## Release Highlights of MToP v1.5

- Fix the bug when GUI parallel runs experiments with save Dec.
- New Algorithm: MTEA-HKTS (Single-objective Multi/Many-task INS24)
- New Problem: Multi-objective sensor coverage problem

## Release Highlights of MToP v1.4

- **New features:**
  - **Draw dynamic Dec and Obj of populations during optimization in the Test Module**
  - **Pause and Stop buttons can now respond in time by clicking on both the Test and Experiment Module**
  - Figures sample numbers in the Test Module can be modified, and figures can be exported
  - Algorithm and Problem objects can be input in the command line running e.g. "mto(MFEA(), CMT1());"
- New Algorithms:
  - CEDA (Constrained Single-objective Multitask SWEC24)
  - MTEA-D-TSD (Multi-objective Multitask GECCO24)
  - Global-GA (Single-objective Single-task TEVC24)
  - KLDE and KLPSO (Single-objective Single-task TEVC23)
  - Other classical algorithms: RVEA (MO-ST), SMS-EMOA (MO-ST), IPOP-CMA-ES (SO-ST)
- New Problems:
  - Classical Single-Objective Functions with any dimension setting
- Fix some bugs.

## Release Highlights of MToP v1.3

- Newly added algorithms:
  - MTDE-MKTA (multi-objective multitask TEVC 2024) with application problems
  - KR-MTEA (multi/single-objective multitask INS 2023)
- Fix some bugs.

## Release Highlights of MToP v1.2

- Newly added algorithms:
  - TRADE (single-objective many-task TCYB 2023)
  - ASCMFDE (single-objective multitask TEVC 2021)
- Add error value type of WCCI20-MTSO
- Update Operator GA (SBX and polynomial mutation) with more advanced calculation methods. GA-based algorithms now have improved performance.

## Release Highlights of MToP v1.1

- The speed of experimental execution is significantly increased, brought by the simultaneous evaluation of whole population decision variables
- 3D task figures of 2-dimensional variables for un-/constrained single-objective multi-/many-/single-task optimization can be plotted in the test module
- Performance metrics can be displayed automatically based on the data type in the experiment module
- Newly added algorithms:
  - MKTDE (single-objective multi-task TEVC 2022)
  - CCEF-ECHT (constrained single-objective TSMC 2023)

</details>

## Related Websites

[*MTO Website*](http://www.bdsc.site/websites/MTO/index.html)
/
[*ETO Website*](http://www.bdsc.site/websites/ETO/ETO.html)

## Star History

<img src="https://api.star-history.com/svg?repos=intLyc/MTO-Platform&type=Date" width="500px">
