# Algorithms in MToP

[← README](../README.md) · [Problems](Problems.md) · [Metrics](Metrics.md)

**144 algorithms · 7 categories**

## Contents

| Category | Algorithms |
| :-- | --: |
| [Single-objective multitask optimization](#single-objective-multitask-optimization) | 40 |
| [Single-objective many-task optimization](#single-objective-many-task-optimization) | 21 |
| [Single-objective stream-task optimization](#single-objective-stream-task-optimization) | 13 |
| [Single-objective single-task optimization](#single-objective-single-task-optimization) | 42 |
| [Multiobjective multitask optimization](#multiobjective-multitask-optimization) | 20 |
| [Multiobjective many-task optimization](#multiobjective-many-task-optimization) | 7 |
| [Multiobjective single-task optimization](#multiobjective-single-task-optimization) | 15 |

## Single-objective multitask optimization

<table>
<thead>
<tr><th>Year ↓</th><th>Algorithm / source</th><th>Method</th><th>Task support / constraints</th><th>Highlights</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2026</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/MES-RET/MES_RET.m"><code>MES_RET</code></a> (ICML)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Reward-weighted evolution for many-task optimization.</td>
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
<td>2026</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/MES-RET/sep_MES_RET.m"><code>sep_MES_RET</code></a> (ICML)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Reward-weighted evolution for many-task optimization.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Constrained%20Multi-task/CMO-LKT/CMO_LKT.m"><code>CMO_LKT</code></a> (TSMC-S)</td>
<td>Multipopulation</td>
<td>Multitask · constrained</td>
<td>Local knowledge transfer for constrained multitasking.</td>
<td><a href="https://doi.org/10.1109/TSMC.2024.3520322" title="A Local Knowledge Transfer-Based Evolutionary Algorithm for Constrained Multitask Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Ban2025CMO-LKT,
  title      = {A Local Knowledge Transfer-Based Evolutionary Algorithm for Constrained Multitask Optimization},
  author     = {Ban, Xuanxuan and Liang, Jing and Yu, Kunjie and Wang, Yaonan and Qiao, Kangjia and Peng, Jinzhu and Gong, Dunwei and Dai, Canyun},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2025},
  volume     = {55},
  number     = {3},
  pages      = {2183-2195},
  doi        = {10.1109/TSMC.2024.3520322},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTEA-PAE/MTEA_PAE.m"><code>MTEA_PAE</code></a> (ASOC)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Progressive autoencoding for domain adaptation.</td>
<td><a href="https://doi.org/10.1016/j.asoc.2025.113916" title="Progressive Auto-Encoding for Domain Adaptation in Evolutionary Multi-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Gu2025MTEA-PAE,
  title      = {Progressive Auto-Encoding for Domain Adaptation in Evolutionary Multi-Task Optimization},
  author     = {Qiong Gu and Yanchi Li and Wenyin Gong and Zhiyuan Yuan and Bin Ning and Chunyang Hu and Jicheng Wu},
  journal    = {Applied Soft Computing},
  year       = {2025},
  pages      = {113916},
  doi        = {10.1016/j.asoc.2025.113916},
  issn       = {1568-4946},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/SSLT/SSLT_DE.m"><code>SSLT_DE</code></a> (KBS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Scenario-based self-learning transfer.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/SSLT/SSLT_GA.m"><code>SSLT_GA</code></a> (KBS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Scenario-based self-learning transfer.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/BLKT-DE/BLKT_DE.m"><code>BLKT_DE</code></a> (TCYB)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Block-level knowledge transfer.</td>
<td><a href="https://doi.org/10.1109/TCYB.2023.3273625" title="Block-Level Knowledge Transfer for Evolutionary Multitask Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Jiang2024BLKT-DE,
  title      = {Block-Level Knowledge Transfer for Evolutionary Multitask Optimization},
  author     = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2024},
  volume     = {54},
  number     = {1},
  pages      = {558-571},
  doi        = {10.1109/TCYB.2023.3273625},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Constrained%20Multi-task/CEDA/CEDA_MF.m"><code>CEDA_MF</code></a> (SWEVO)</td>
<td>Multifactorial</td>
<td>Multitask · constrained</td>
<td>Coevolution and domain adaptation for constrained tasks.</td>
<td><a href="https://doi.org/10.1016/j.swevo.2024.101570" title="Constrained Multitasking Optimization Via Co-Evolution and Domain Adaptation">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhang2024CEDA,
  title      = {Constrained Multitasking Optimization Via Co-Evolution and Domain Adaptation},
  author     = {Tingyu Zhang and Dongcheng Li and Yanchi Li and Wenyin Gong},
  journal    = {Swarm and Evolutionary Computation},
  year       = {2024},
  volume     = {87},
  pages      = {101570},
  doi        = {10.1016/j.swevo.2024.101570},
  issn       = {2210-6502},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Constrained%20Multi-task/CEDA/CEDA_MP.m"><code>CEDA_MP</code></a> (SWEVO)</td>
<td>Multipopulation</td>
<td>Multitask · constrained</td>
<td>Coevolution and domain adaptation for constrained tasks.</td>
<td><a href="https://doi.org/10.1016/j.swevo.2024.101570" title="Constrained Multitasking Optimization Via Co-Evolution and Domain Adaptation">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhang2024CEDA,
  title      = {Constrained Multitasking Optimization Via Co-Evolution and Domain Adaptation},
  author     = {Tingyu Zhang and Dongcheng Li and Yanchi Li and Wenyin Gong},
  journal    = {Swarm and Evolutionary Computation},
  year       = {2024},
  volume     = {87},
  pages      = {101570},
  doi        = {10.1016/j.swevo.2024.101570},
  issn       = {2210-6502},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/EMTO-AI/EMTO_AI.m"><code>EMTO_AI</code></a> (TETCI)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Adaptive intensity of knowledge transfer.</td>
<td><a href="https://doi.org/10.1109/TETCI.2024.3418810" title="Evolutionary Multi-Task Optimization With Adaptive Intensity of Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhou2024EMTO-AI,
  title      = {Evolutionary Multi-Task Optimization With Adaptive Intensity of Knowledge Transfer},
  author     = {Zhou, Xinyu and Mei, Neng and Zhong, Maosheng and Wang, Mingwen},
  journal    = {IEEE Transactions on Emerging Topics in Computational Intelligence},
  year       = {2024},
  pages      = {1-13},
  doi        = {10.1109/TETCI.2024.3418810},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/MFEA-DGD/MFEA_DGD.m"><code>MFEA_DGD</code></a> (TCYB)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained</td>
<td>Diffusion gradient descent for multifactorial evolution.</td>
<td><a href="https://doi.org/10.1109/TCYB.2023.3270904" title="Multifactorial Evolutionary Algorithm Based on Diffusion Gradient Descent">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liu2024MFEA-DGD,
  title      = {Multifactorial Evolutionary Algorithm Based on Diffusion Gradient Descent},
  author     = {Liu, Zhaobo and Li, Guo and Zhang, Haili and Liang, Zhengping and Zhu, Zexuan},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2024},
  volume     = {54},
  number     = {7},
  pages      = {4267-4279},
  doi        = {10.1109/TCYB.2023.3270904},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/MFEA-VC/MFEA_VC.m"><code>MFEA_VC</code></a> (ASOC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Contrastive variational autoencoder for transfer.</td>
<td><a href="https://doi.org/10.1016/j.asoc.2024.111883" title="Contrastive Variational Auto-Encoder Driven Convergence Guidance in Evolutionary Multitasking">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wang2024MFEA-VC,
  title      = {Contrastive Variational Auto-Encoder Driven Convergence Guidance in Evolutionary Multitasking},
  author     = {Ruilin Wang and Xiang Feng and Huiqun Yu},
  journal    = {Applied Soft Computing},
  year       = {2024},
  volume     = {163},
  pages      = {111883},
  doi        = {10.1016/j.asoc.2024.111883},
  issn       = {1568-4946},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTDE-ADKT/MTDE_ADKT.m"><code>MTDE_ADKT</code></a> (ASOC)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Adaptive dual knowledge transfer.</td>
<td><a href="https://doi.org/10.1016/j.asoc.2024.112040" title="Multitask Differential Evolution with Adaptive Dual Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhang2024MTDE-ADKT,
  title      = {Multitask Differential Evolution with Adaptive Dual Knowledge Transfer},
  author     = {Tingyu Zhang and Wenyin Gong and Yanchi Li},
  journal    = {Applied Soft Computing},
  year       = {2024},
  volume     = {165},
  pages      = {112040},
  doi        = {10.1016/j.asoc.2024.112040},
  issn       = {1568-4946},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTEA-HKTS/MTEA_HKTS.m"><code>MTEA_HKTS</code></a> (INS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained</td>
<td>Selection of knowledge-transfer targets.</td>
<td><a href="https://doi.org/10.1016/j.ins.2024.121214" title="A Multi-Task Evolutionary Algorithm for Solving the Problem of Transfer Targets">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhao2024MTEA-HKTS,
  title      = {A Multi-Task Evolutionary Algorithm for Solving the Problem of Transfer Targets},
  author     = {Ben Zhao and Zhihua Cui and JinQian Yang and Xingjuan Cai and Jianghui Cai and Jinjun Chen},
  journal    = {Information Sciences},
  year       = {2024},
  volume     = {681},
  pages      = {121214},
  doi        = {10.1016/j.ins.2024.121214},
  issn       = {0020-0255},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTES-KG/MTES_KG.m"><code>MTES_KG</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Knowledge-guided external sampling.</td>
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
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTES-KG/sep_MTES_KG.m"><code>sep_MTES_KG</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Knowledge-guided external sampling.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Many-task/KR-MTEA/KR_MTEA.m"><code>KR_MTEA</code></a> (INS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained</td>
<td>Adaptive knowledge reuse. Supports single- and multiobjective problems.</td>
<td><a href="https://doi.org/10.1016/j.ins.2023.119568" title="Adaptive Multi-task Evolutionary Algorithm Based on Knowledge Reuse">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Cui2023Adaptive,
  title      = {Adaptive Multi-task Evolutionary Algorithm Based on Knowledge Reuse},
  author     = {Cui, Zhihua and Zhao, Ben and Zhao, Tianhao and Cai, Xingjuan and Chen, Jinjun},
  journal    = {Information Sciences},
  year       = {2023},
  volume     = {648},
  pages      = {119568},
  doi        = {10.1016/j.ins.2023.119568},
  month      = {08},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTEA-SaO/MTEA_SaO.m"><code>MTEA_SaO</code></a> (INS)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Adaptive solver multitasking framework.</td>
<td><a href="https://doi.org/10.1016/j.ins.2022.10.099" title="Multitasking Optimization via an Adaptive Solver Multitasking Evolutionary Framework">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-task/Competitive%20Multi-task/MTSRA/MTSRA.m"><code>MTSRA</code></a> (ESWA)</td>
<td>Multipopulation</td>
<td>Multitask · competitive</td>
<td>Improved adaptive DE with competitive task selection.</td>
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
<td>2022</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/AT-MFEA/AT_MFEA.m"><code>AT_MFEA</code></a> (TCYB)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Affine-transformation domain adaptation.</td>
<td><a href="https://doi.org/10.1109/TCYB.2020.3036393" title="Affine Transformation-Enhanced Multifactorial Optimization for Heterogeneous Problems">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Xue2022AT-MFEA,
  title      = {Affine Transformation-Enhanced Multifactorial Optimization for Heterogeneous Problems},
  author     = {Xue, Xiaoming and Zhang, Kai and Tan, Kay Chen and Feng, Liang and Wang, Jian and Chen, Guodong and Zhao, Xinggang and Zhang, Liming and Yao, Jun},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2022},
  volume     = {52},
  number     = {7},
  pages      = {6217-6231},
  doi        = {10.1109/TCYB.2020.3036393},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Multi-task/Competitive%20Multi-task/DEORA/DEORA.m"><code>DEORA</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask · competitive</td>
<td>Competitive task selection and resource allocation.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Competitive%20Multi-task/DEORA/DEORA_MTDE.m"><code>DEORA_MTDE</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask · competitive</td>
<td>Competitive task selection and resource allocation.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MKTDE/MKTDE.m"><code>MKTDE</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Meta-knowledge transfer between tasks.</td>
<td><a href="https://doi.org/10.1109/TEVC.2021.3131236" title="A Meta-Knowledge Transfer-Based Differential Evolution for Multitask Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2021MKTDE,
  title      = {A Meta-Knowledge Transfer-Based Differential Evolution for Multitask Optimization},
  author     = {Li, Jian-Yu and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {4},
  pages      = {719-734},
  doi        = {10.1109/TEVC.2021.3131236},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTEA-AD/MTEA_AD.m"><code>MTEA_AD</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Adaptive transfer via anomaly detection.</td>
<td><a href="https://doi.org/10.1109/TEVC.2021.3068157" title="Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wang2022MTEA-AD,
  title      = {Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection},
  author     = {Wang, Chao and Liu, Jing and Wu, Kai and Wu, Zhaoyang},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {304-318},
  doi        = {10.1109/TEVC.2021.3068157},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTES/MTES.m"><code>MTES</code></a> (TCYB)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Gradient-free evolutionary multitasking.</td>
<td><a href="https://doi.org/10.1109/TCYB.2021.3052509" title="From Multitask Gradient Descent to Gradient-Free Evolutionary Multitasking: A Proof of Faster Convergence">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Bai2022MTES,
  title      = {From Multitask Gradient Descent to Gradient-Free Evolutionary Multitasking: A Proof of Faster Convergence},
  author     = {Bai, Lu and Lin, Wu and Gupta, Abhishek and Ong, Yew-Soon},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2022},
  volume     = {52},
  number     = {8},
  pages      = {8561-8573},
  doi        = {10.1109/TCYB.2021.3052509},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/ASCMFDE/ASCMFDE.m"><code>ASCMFDE</code></a> (TEVC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Intertask transfer in an aligned subspace.</td>
<td><a href="https://doi.org/10.1109/TEVC.2020.3023480" title="Regularized Evolutionary Multitask Optimization: Learning to Intertask Transfer in Aligned Subspace">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Tang2021ASCMFDE,
  title      = {Regularized Evolutionary Multitask Optimization: Learning to Intertask Transfer in Aligned Subspace},
  author     = {Tang, Zedong and Gong, Maoguo and Wu, Yue and Liu, Wenfeng and Xie, Yu},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2021},
  volume     = {25},
  number     = {2},
  pages      = {262-276},
  doi        = {10.1109/TEVC.2020.3023480},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/MFEA-AKT/MFEA_AKT.m"><code>MFEA_AKT</code></a> (TCYB)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained</td>
<td>Adaptive transfer with multiple crossover operators.</td>
<td><a href="https://doi.org/10.1109/TCYB.2020.2974100" title="Toward Adaptive Knowledge Transfer in Multifactorial Evolutionary Computation">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhou2021MFEA-AKT,
  title      = {Toward Adaptive Knowledge Transfer in Multifactorial Evolutionary Computation},
  author     = {Zhou, Lei and Feng, Liang and Tan, Kay Chen and Zhong, Jinghui and Zhu, Zexuan and Liu, Kai and Chen, Chao},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2021},
  volume     = {51},
  number     = {5},
  pages      = {2563-2576},
  doi        = {10.1109/TCYB.2020.2974100},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/MFEA-II/MFEA_II.m"><code>MFEA_II</code></a> (TEVC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Online transfer-parameter estimation.</td>
<td><a href="https://doi.org/10.1109/TEVC.2019.2906927" title="Multifactorial Evolutionary Algorithm With Online Transfer Parameter Estimation: MFEA-II">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Bali2020MFEA2,
  title      = {Multifactorial Evolutionary Algorithm With Online Transfer Parameter Estimation: MFEA-II},
  author     = {Bali, Kavitesh Kumar and Ong, Yew-Soon and Gupta, Abhishek and Tan, Puay Siew},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2020},
  volume     = {24},
  number     = {1},
  pages      = {69-83},
  doi        = {10.1109/TEVC.2019.2906927},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MFMP/MFMP.m"><code>MFMP</code></a> (INS)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Explicit multipopulation evolutionary framework.</td>
<td><a href="https://doi.org/10.1016/j.ins.2019.10.066" title="Multifactorial Optimization Via Explicit Multipopulation Evolutionary Framework">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2020MFMP,
  title      = {Multifactorial Optimization Via Explicit Multipopulation Evolutionary Framework},
  author     = {Genghui Li and Qiuzhen Lin and Weifeng Gao},
  journal    = {Information Sciences},
  year       = {2020},
  volume     = {512},
  pages      = {1555-1570},
  doi        = {10.1016/j.ins.2019.10.066},
  issn       = {0020-0255},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/SREMTO/SREMTO.m"><code>SREMTO</code></a> (TEVC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Self-regulated transfer for varying task relatedness.</td>
<td><a href="https://doi.org/10.1109/TEVC.2019.2904696" title="Self-Regulated Evolutionary Multitask Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zheng2020SREMTO,
  title      = {Self-Regulated Evolutionary Multitask Optimization},
  author     = {Zheng, Xiaolong and Qin, A. K. and Gong, Maoguo and Zhou, Deyun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2020},
  volume     = {24},
  number     = {1},
  pages      = {16-28},
  doi        = {10.1109/TEVC.2019.2904696},
  file       = {:Zheng2020SREMTO - Self Regulated Evolutionary Multitask Optimization.pdf:PDF},
  groups     = {MT, SO, Algorithm},
  readstatus = {read},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/TLTLA/TLTLA.m"><code>TLTLA</code></a> (Front. Neurosci.)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Two-level inter- and intra-task transfer learning.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Ma2020TLTLA,
  title      = {A Two-level Transfer Learning Algorithm for Evolutionary Multitasking},
  author     = {Ma, Xiaoliang and Chen, Qunjian and Yu, Yanan and Sun, Yiwen and Ma, Lijia and Zhu, Zexuan},
  journal    = {Frontiers in neuroscience},
  year       = {2020},
  volume     = {13},
  pages      = {1408},
  publisher  = {Frontiers},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/EMEA/EMEA.m"><code>EMEA</code></a> (TCYB)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Explicit transfer through autoencoding.</td>
<td><a href="https://doi.org/10.1109/TCYB.2018.2845361" title="Evolutionary Multitasking via Explicit Autoencoding">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Feng2019EMEA,
  title      = {Evolutionary Multitasking via Explicit Autoencoding},
  author     = {Feng, Liang and Zhou, Lei and Zhong, Jinghui and Gupta, Abhishek and Ong, Yew-Soon and Tan, Kay-Chen and Qin, A. K.},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2019},
  volume     = {49},
  number     = {9},
  pages      = {3457-3470},
  doi        = {10.1109/TCYB.2018.2845361},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/G-MFEA/G_MFEA.m"><code>G_MFEA</code></a> (TEVC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained</td>
<td>Decision-variable translation and shuffling.</td>
<td><a href="https://doi.org/10.1109/TEVC.2017.2785351" title="Generalized Multitasking for Evolutionary Optimization of Expensive Problems">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Ding2019G-MFEA,
  title      = {Generalized Multitasking for Evolutionary Optimization of Expensive Problems},
  author     = {Ding, Jinliang and Yang, Cuie and Jin, Yaochu and Chai, Tianyou},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2019},
  volume     = {23},
  number     = {1},
  pages      = {44-58},
  doi        = {10.1109/TEVC.2017.2785351},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/MFEA-DV/MFEA_DV.m"><code>MFEA_DV</code></a> (CEC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Cross-task search-direction transfer.</td>
<td><a href="https://doi.org/10.1109/CEC.2019.8789959" title="Multifactorial Evolutionary Algorithm Enhanced with Cross-task Search Direction">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Yin2019MFEA-DV,
  title      = {Multifactorial Evolutionary Algorithm Enhanced with Cross-task Search Direction},
  author     = {Yin,Jian and Zhu, Anmin and Zhu, Zexuan and Yu, Yanan and Ma, Xiaoling},
  journal    = {IEEE Congress on Evolutionary Computation},
  year       = {2019},
  pages      = {2244-2251},
  doi        = {10.1109/CEC.2019.8789959},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/MFEA-GHS/MFEA_GHS.m"><code>MFEA_GHS</code></a> (ESWA)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Genetic transform and hyper-rectangle search.</td>
<td><a href="https://doi.org/10.1016/j.eswa.2019.07.015" title="A Hybrid of Genetic Transform and Hyper-rectangle Search Strategies for Evolutionary Multi-tasking">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liang2019MFEA-GHS,
  title      = {A Hybrid of Genetic Transform and Hyper-rectangle Search Strategies for Evolutionary Multi-tasking},
  author     = {Zhengping Liang and Jian Zhang and Liang Feng and Zexuan Zhu},
  journal    = {Expert Systems with Applications},
  year       = {2019},
  volume     = {138},
  pages      = {112798},
  doi        = {10.1016/j.eswa.2019.07.015},
}
```

</details>
</td>
</tr>
<tr>
<td>2018</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/IMEA/IMEA.m"><code>IMEA</code></a> (GECCO-C)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Island-model evolutionary multitasking.</td>
<td><a href="https://doi.org/10.1145/3205651.3208228" title="Analysis of Evolutionary Multi-Tasking as an Island Model">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Hashimoto2018IMEA,
  title      = {Analysis of Evolutionary Multi-Tasking as an Island Model},
  author     = {Hashimoto, Ryuichi and Ishibuchi, Hisao and Masuyama, Naoki and Nojima, Yusuke},
  booktitle  = {Proceedings of the Genetic and Evolutionary Computation Conference Companion},
  year       = {2018},
  pages      = {1894–1897},
  publisher  = {Association for Computing Machinery},
  address    = {New York, NY, USA},
  doi        = {10.1145/3205651.3208228},
  isbn       = {9781450357647},
  series     = {GECCO '18},
  location   = {Kyoto, Japan},
  numpages   = {4},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/LDA-MFEA/LDA_MFEA.m"><code>LDA_MFEA</code></a> (CEC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained</td>
<td>Linearized domain adaptation for multifactorial evolution.</td>
<td><a href="https://doi.org/10.1109/CEC.2017.7969454" title="Linearized Domain Adaptation in Evolutionary Multitasking">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Bali2017LDA-MFEA,
  title      = {Linearized Domain Adaptation in Evolutionary Multitasking},
  author     = {Bali, Kavitesh Kumar and Gupta, Abhishek and Feng, Liang and Ong, Yew Soon and Tan Puay Siew},
  booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2017},
  pages      = {1295-1302},
  doi        = {10.1109/CEC.2017.7969454},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/MFDE/MFDE.m"><code>MFDE</code></a> (CEC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Multifactorial differential evolution.</td>
<td><a href="https://doi.org/10.1109/CEC.2017.7969407" title="An Empirical Study of Multifactorial PSO and Multifactorial DE">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Feng2017MFDE-MFPSO,
  title      = {An Empirical Study of Multifactorial PSO and Multifactorial DE},
  author     = {Feng, L. and Zhou, W. and Zhou, L. and Jiang, S. W. and Zhong, J. H. and Da, B. S. and Zhu, Z. X. and Wang, Y.},
  booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2017},
  pages      = {921-928},
  doi        = {10.1109/CEC.2017.7969407},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/MFPSO/MFPSO.m"><code>MFPSO</code></a> (CEC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Multifactorial particle swarm optimization.</td>
<td><a href="https://doi.org/10.1109/CEC.2017.7969407" title="An Empirical Study of Multifactorial PSO and Multifactorial DE">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Feng2017MFDE-MFPSO,
  title      = {An Empirical Study of Multifactorial PSO and Multifactorial DE},
  author     = {Feng, L. and Zhou, W. and Zhou, L. and Jiang, S. W. and Zhong, J. H. and Da, B. S. and Zhu, Z. X. and Wang, Y.},
  booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2017},
  pages      = {921-928},
  doi        = {10.1109/CEC.2017.7969407},
}
```

</details>
</td>
</tr>
<tr>
<td>2016</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-factorial/MFEA/MFEA.m"><code>MFEA</code></a> (TEVC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Multifactorial evolution with implicit genetic transfer.</td>
<td><a href="https://doi.org/10.1109/TEVC.2015.2458037" title="Multifactorial Evolution: Toward Evolutionary Multitasking">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Gupta2016MFEA,
  title      = {Multifactorial Evolution: Toward Evolutionary Multitasking},
  author     = {Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2016},
  volume     = {20},
  number     = {3},
  pages      = {343-357},
  doi        = {10.1109/TEVC.2015.2458037},
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
<tr><th>Year ↓</th><th>Algorithm / source</th><th>Method</th><th>Task support / constraints</th><th>Highlights</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2026</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/MES-RET/MES_RET.m"><code>MES_RET</code></a> (ICML)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Reward-weighted evolution for many-task optimization.</td>
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
<td>2026</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/MES-RET/sep_MES_RET.m"><code>sep_MES_RET</code></a> (ICML)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Reward-weighted evolution for many-task optimization.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Many-task/DTSKT/DTSKT.m"><code>DTSKT</code></a> (TSMC-S)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>Distribution-direction-assisted two-stage transfer.</td>
<td><a href="https://doi.org/10.1109/TSMC.2025.3598800" title="Distribution Direction-Assisted Two-Stage Knowledge Transfer for Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
<td>2025</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/SSLT/SSLT_DE.m"><code>SSLT_DE</code></a> (KBS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Scenario-based self-learning transfer.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/SSLT/SSLT_GA.m"><code>SSLT_GA</code></a> (KBS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Scenario-based self-learning transfer.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Many-task/TNG-NES/TNG_SNES.m"><code>TNG_SNES</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>Transfer of task-averaged natural gradients.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Many-task/TNG-NES/TNG_SNES_EP.m"><code>TNG_SNES_EP</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>Transfer of task-averaged natural gradients.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Many-task/TNG-NES/TNG_xNES.m"><code>TNG_xNES</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>Transfer of task-averaged natural gradients.</td>
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
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTEA-HKTS/MTEA_HKTS.m"><code>MTEA_HKTS</code></a> (INS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained</td>
<td>Selection of knowledge-transfer targets.</td>
<td><a href="https://doi.org/10.1016/j.ins.2024.121214" title="A Multi-Task Evolutionary Algorithm for Solving the Problem of Transfer Targets">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhao2024MTEA-HKTS,
  title      = {A Multi-Task Evolutionary Algorithm for Solving the Problem of Transfer Targets},
  author     = {Ben Zhao and Zhihua Cui and JinQian Yang and Xingjuan Cai and Jianghui Cai and Jinjun Chen},
  journal    = {Information Sciences},
  year       = {2024},
  volume     = {681},
  pages      = {121214},
  doi        = {10.1016/j.ins.2024.121214},
  issn       = {0020-0255},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTES-KG/MTES_KG.m"><code>MTES_KG</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Knowledge-guided external sampling.</td>
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
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTES-KG/sep_MTES_KG.m"><code>sep_MTES_KG</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Knowledge-guided external sampling.</td>
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
<td><a href="../MTO/Algorithms/Multi-task/Many-task/BoKT/BoKTDE.m"><code>BoKTDE</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained</td>
<td>Bi-objective knowledge-transfer framework.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3210783" title="A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/BoKT/BoKTGA.m"><code>BoKTGA</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained</td>
<td>Bi-objective knowledge-transfer framework.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3210783" title="A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/KR-MTEA/KR_MTEA.m"><code>KR_MTEA</code></a> (INS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained</td>
<td>Adaptive knowledge reuse. Supports single- and multiobjective problems.</td>
<td><a href="https://doi.org/10.1016/j.ins.2023.119568" title="Adaptive Multi-task Evolutionary Algorithm Based on Knowledge Reuse">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Cui2023Adaptive,
  title      = {Adaptive Multi-task Evolutionary Algorithm Based on Knowledge Reuse},
  author     = {Cui, Zhihua and Zhao, Ben and Zhao, Tianhao and Cai, Xingjuan and Chen, Jinjun},
  journal    = {Information Sciences},
  year       = {2023},
  volume     = {648},
  pages      = {119568},
  doi        = {10.1016/j.ins.2023.119568},
  month      = {08},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/TRADE/TRADE.m"><code>TRADE</code></a> (TCYB)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained</td>
<td>Transfer of adaptive DE parameters.</td>
<td><a href="https://doi.org/10.1109/TCYB.2023.3234969" title="Transferable Adaptive Differential Evolution for Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wu2023TRADE,
  title      = {Transferable Adaptive Differential Evolution for Many-Task Optimization},
  author     = {Wu, Sheng-Hao and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2023},
  volume     = {53},
  number     = {11},
  pages      = {7295-7308},
  doi        = {10.1109/TCYB.2023.3234969},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/EMaTO-MKT/EMaTO_MKT.m"><code>EMaTO_MKT</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained</td>
<td>Multi-source transfer using local distributions.</td>
<td><a href="https://doi.org/10.1109/TEVC.2021.3101697" title="Evolutionary Many-Task Optimization Based on Multi-Source Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liang2022EMaTO-MKT,
  title      = {Evolutionary Many-Task Optimization Based on Multi-Source Knowledge Transfer},
  author     = {Liang, Zhengping and Xu, Xiuju and Liu, Ling and Tu, Yaofeng and Zhu, Zexuan},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {319-333},
  doi        = {10.1109/TEVC.2021.3101697},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Multi-task/Multi-population/MTEA-AD/MTEA_AD.m"><code>MTEA_AD</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Adaptive transfer via anomaly detection.</td>
<td><a href="https://doi.org/10.1109/TEVC.2021.3068157" title="Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wang2022MTEA-AD,
  title      = {Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection},
  author     = {Wang, Chao and Liu, Jing and Wu, Kai and Wu, Zhaoyang},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {304-318},
  doi        = {10.1109/TEVC.2021.3068157},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/MaTDE/MaTDE.m"><code>MaTDE</code></a> (TETCI)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>Adaptive archive-based many-task transfer.</td>
<td><a href="https://doi.org/10.1109/TETCI.2019.2916051" title="An Adaptive Archive-Based Evolutionary Framework for Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Chen2020MaTDE,
  title      = {An Adaptive Archive-Based Evolutionary Framework for Many-Task Optimization},
  author     = {Chen, Yongliang and Zhong, Jinghui and Feng, Liang and Zhang, Jun},
  journal    = {IEEE Transactions on Emerging Topics in Computational Intelligence},
  year       = {2020},
  volume     = {4},
  number     = {3},
  pages      = {369-384},
  doi        = {10.1109/TETCI.2019.2916051},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/SBO/SBCMAES.m"><code>SBCMAES</code></a> (AAAI)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>Symbiosis-inspired many-task optimization.</td>
<td><a href="https://doi.org/10.1609/aaai.v33i01.33014295" title="Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liaw2019SBO,
  title      = {Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis},
  author     = {Liaw, Rung-Tzuo and Ting, Chuan-Kang},
  journal    = {Proceedings of the AAAI Conference on Artificial Intelligence},
  year       = {2019},
  volume     = {33},
  number     = {01},
  pages      = {4295-4303},
  doi        = {10.1609/aaai.v33i01.33014295},
  month      = {Jul.},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/SBO/SBGA.m"><code>SBGA</code></a> (AAAI)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>Symbiosis-inspired many-task optimization.</td>
<td><a href="https://doi.org/10.1609/aaai.v33i01.33014295" title="Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liaw2019SBO,
  title      = {Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis},
  author     = {Liaw, Rung-Tzuo and Ting, Chuan-Kang},
  journal    = {Proceedings of the AAAI Conference on Artificial Intelligence},
  year       = {2019},
  volume     = {33},
  number     = {01},
  pages      = {4295-4303},
  doi        = {10.1609/aaai.v33i01.33014295},
  month      = {Jul.},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/SBO/sep_SBCMAES.m"><code>sep_SBCMAES</code></a> (AAAI)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>Symbiosis-inspired many-task optimization.</td>
<td><a href="https://doi.org/10.1609/aaai.v33i01.33014295" title="Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liaw2019SBO,
  title      = {Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis},
  author     = {Liaw, Rung-Tzuo and Ting, Chuan-Kang},
  journal    = {Proceedings of the AAAI Conference on Artificial Intelligence},
  year       = {2019},
  volume     = {33},
  number     = {01},
  pages      = {4295-4303},
  doi        = {10.1609/aaai.v33i01.33014295},
  month      = {Jul.},
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
<tr><th>Year ↓</th><th>Algorithm / source</th><th>Method</th><th>Task support / constraints</th><th>Highlights</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2026</td>
<td><a href="../MTO/Algorithms/Stream-task/AMES-RET/AMES_RET.m"><code>AMES_RET</code></a> (ICML)</td>
<td>Asynchronous</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Asynchronous reward-weighted MES-RET adaptation.</td>
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
<td>2026</td>
<td><a href="../MTO/Algorithms/Stream-task/KR-AMTEA/KR_AMTEA.m"><code>KR_AMTEA</code></a> (TSMC-S)</td>
<td>Asynchronous</td>
<td>Multitask / many-task · unconstrained</td>
<td>Multitense knowledge transfer with asynchronous arrivals.</td>
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
<td>2025</td>
<td><a href="../MTO/Algorithms/Stream-task/ATNG-SNES/ATNG_SNES.m"><code>ATNG_SNES</code></a> (TEVC)</td>
<td>Asynchronous</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Asynchronous averaging of published natural gradients.</td>
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
<td><a href="../MTO/Algorithms/Stream-task/GL-LERC/GL_LERC.m"><code>GL_LERC</code></a> (TEVC)</td>
<td>Sequential</td>
<td>Multitask / many-task · unconstrained</td>
<td>Sequential transfer of global and local search experience.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3417325" title="Global and Local Search Experience-Based Evolutionary Sequential Transfer Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Cao2025Global,
  title      = {Global and Local Search Experience-Based Evolutionary Sequential Transfer Optimization},
  author     = {Cao, Chenming and Zhang, Kai and Xue, Xiaoming and Tan, Kay Chen and Wang, Jian and Zhang, Liming and Liu, Piyang and Yan, Xia},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2025},
  volume     = {29},
  number     = {4},
  pages      = {1269--1283},
  doi        = {10.1109/TEVC.2024.3417325},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Stream-task/AMTES-KG/AMTES_KG.m"><code>AMTES_KG</code></a> (TEVC)</td>
<td>Asynchronous</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Asynchronous knowledge-guided external sampling.</td>
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
<td><a href="../MTO/Algorithms/Stream-task/ABoKTDE/ABoKTDE.m"><code>ABoKTDE</code></a> (TEVC)</td>
<td>Asynchronous</td>
<td>Multitask / many-task · unconstrained</td>
<td>Asynchronous DE variant of bi-objective transfer.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3210783" title="A Bi-Objective Knowledge Transfer Framework for Evolutionary Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Stream-task/AMTEA-SaO/AMTEA_SaO.m"><code>AMTEA_SaO</code></a> (INS)</td>
<td>Asynchronous</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Asynchronous adaptive solver multitasking.</td>
<td><a href="https://doi.org/10.1016/j.ins.2022.10.099" title="Multitasking Optimization via an Adaptive Solver Multitasking Evolutionary Framework">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Stream-task/AAEMTO/AAEMTO.m"><code>AAEMTO</code></a> (TEVC)</td>
<td>Asynchronous</td>
<td>Multitask / many-task · unconstrained</td>
<td>Asynchronous adaptive knowledge transfer (AEMTO adaptation).</td>
<td><a href="https://doi.org/10.1109/TEVC.2021.3107435" title="Evolutionary Multi-Task Optimization with Adaptive Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
<td><a href="../MTO/Algorithms/Stream-task/AMTEA-AD/AMTEA_AD.m"><code>AMTEA_AD</code></a> (TEVC)</td>
<td>Asynchronous</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Asynchronous anomaly-detection-based transfer.</td>
<td><a href="https://doi.org/10.1109/TEVC.2021.3068157" title="Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wang2022MTEA-AD,
  title      = {Solving Multi-task Optimization Problems with Adaptive Knowledge Transfer via Anomaly Detection},
  author     = {Wang, Chao and Liu, Jing and Wu, Kai and Wu, Zhaoyang},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {304-318},
  doi        = {10.1109/TEVC.2021.3068157},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Stream-task/AMTEA-MS/AMTEA_MS.m"><code>AMTEA_MS</code></a> (Cogn. Comput.)</td>
<td>Sequential</td>
<td>Multitask / many-task · unconstrained</td>
<td>Sequential nonlinear source-to-target transfer.</td>
<td><a href="https://doi.org/10.1007/s12559-020-09777-7" title="Non-linear Domain Adaptation in Transfer Evolutionary Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Lim2021Nonlinear,
  title      = {Non-linear Domain Adaptation in Transfer Evolutionary Optimization},
  author     = {Lim, Ray and Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang and Zhang, Allan N.},
  journal    = {Cognitive Computation},
  year       = {2021},
  volume     = {13},
  number     = {2},
  pages      = {290--307},
  doi        = {10.1007/s12559-020-09777-7},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Stream-task/AMaTDE/AMaTDE.m"><code>AMaTDE</code></a> (TETCI)</td>
<td>Asynchronous</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Asynchronous archive-based many-task DE.</td>
<td><a href="https://doi.org/10.1109/TETCI.2019.2916051" title="An Adaptive Archive-Based Evolutionary Framework for Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Chen2020MaTDE,
  title      = {An Adaptive Archive-Based Evolutionary Framework for Many-Task Optimization},
  author     = {Chen, Yongliang and Zhong, Jinghui and Feng, Liang and Zhang, Jun},
  journal    = {IEEE Transactions on Emerging Topics in Computational Intelligence},
  year       = {2020},
  volume     = {4},
  number     = {3},
  pages      = {369-384},
  doi        = {10.1109/TETCI.2019.2916051},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Stream-task/AEMEA/AEMEA.m"><code>AEMEA</code></a> (TCYB)</td>
<td>Asynchronous</td>
<td>Multitask · unconstrained / constrained</td>
<td>Asynchronous autoencoding-based explicit transfer.</td>
<td><a href="https://doi.org/10.1109/TCYB.2018.2845361" title="Evolutionary Multitasking via Explicit Autoencoding">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Feng2019EMEA,
  title      = {Evolutionary Multitasking via Explicit Autoencoding},
  author     = {Feng, Liang and Zhou, Lei and Zhong, Jinghui and Gupta, Abhishek and Ong, Yew-Soon and Tan, Kay-Chen and Qin, A. K.},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2019},
  volume     = {49},
  number     = {9},
  pages      = {3457-3470},
  doi        = {10.1109/TCYB.2018.2845361},
}
```

</details>
</td>
</tr>
<tr>
<td>2016</td>
<td><a href="../MTO/Algorithms/Stream-task/AMFEA/AMFEA.m"><code>AMFEA</code></a> (TEVC)</td>
<td>Asynchronous</td>
<td>Multitask · unconstrained / constrained</td>
<td>Asynchronous multifactorial genetic transfer.</td>
<td><a href="https://doi.org/10.1109/TEVC.2015.2458037" title="Multifactorial Evolution: Toward Evolutionary Multitasking">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Gupta2016MFEA,
  title      = {Multifactorial Evolution: Toward Evolutionary Multitasking},
  author     = {Gupta, Abhishek and Ong, Yew-Soon and Feng, Liang},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2016},
  volume     = {20},
  number     = {3},
  pages      = {343-357},
  doi        = {10.1109/TEVC.2015.2458037},
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
<tr><th>Year ↓</th><th>Algorithm / source</th><th>Method</th><th>Task support / constraints</th><th>Highlights</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2026</td>
<td><a href="../MTO/Algorithms/Single-task/Genetic%20Algorithm/ABOM/ABOM.m"><code>ABOM</code></a> (ICLR)</td>
<td>Genetic algorithm</td>
<td>Single-task · unconstrained / constrained</td>
<td>Task-free adaptive meta black-box optimization.</td>
<td><a href="https://openreview.net/forum?id=AufVSUgMUo" title="Task-free Adaptive Meta Black-box Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Wang2026ABOM,
  title      = {Task-free Adaptive Meta Black-box Optimization},
  author     = {Chao Wang and Licheng Jiao and Lingling Li and Jiaxuan Zhao and Guanchun Wang and Fang Liu and Shuyuan Yang},
  booktitle  = {The Fourteenth International Conference on Learning Representations},
  year       = {2026},
  url        = {https://openreview.net/forum?id=AufVSUgMUo},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/KLDE/KLDE.m"><code>KLDE</code></a> (TEVC)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Knowledge learning in differential evolution.</td>
<td><a href="https://doi.org/10.1109/TEVC.2023.3278132" title="Knowledge Learning for Evolutionary Computation">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Jiang2025KLEC,
  title      = {Knowledge Learning for Evolutionary Computation},
  author     = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2025},
  volume     = {29},
  number     = {1},
  pages      = {16-30},
  doi        = {10.1109/TEVC.2023.3278132},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Single-task/Swarm%20Intelligence/KLPSO/KLPSO.m"><code>KLPSO</code></a> (TEVC)</td>
<td>Swarm intelligence</td>
<td>Single-task · unconstrained / constrained</td>
<td>Knowledge learning in particle swarm optimization.</td>
<td><a href="https://doi.org/10.1109/TEVC.2023.3278132" title="Knowledge Learning for Evolutionary Computation">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Jiang2025KLEC,
  title      = {Knowledge Learning for Evolutionary Computation},
  author     = {Jiang, Yi and Zhan, Zhi-Hui and Tan, Kay Chen and Zhang, Jun},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2025},
  volume     = {29},
  number     = {1},
  pages      = {16-30},
  doi        = {10.1109/TEVC.2023.3278132},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/CCEF-ECHT/CCEF_ECHT.m"><code>CCEF_ECHT</code></a> (TSMC-S)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Competitive and cooperative constraint-handling ensemble.</td>
<td><a href="https://doi.org/10.1109/TSMC.2023.3343778" title="A Competitive and Cooperative Evolutionary Framework for Ensemble of Constraint Handling Techniques">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2024CCEF-ECHT,
  title      = {A Competitive and Cooperative Evolutionary Framework for Ensemble of Constraint Handling Techniques},
  author     = {Li, Yanchi and Gong, Wenyin and Hu, Zhenzhen and Li, Shuijia},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2024},
  volume     = {54},
  number     = {4},
  pages      = {2440-2451},
  doi        = {10.1109/TSMC.2023.3343778},
}
```

</details>
</td>
</tr>
<tr>
<td>2024</td>
<td><a href="../MTO/Algorithms/Single-task/Genetic%20Algorithm/Global-GA/Global_GA.m"><code>Global_GA</code></a> (TEVC)</td>
<td>Genetic algorithm</td>
<td>Single-task · unconstrained / constrained</td>
<td>Global crossover for cooperative evolution.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3355776" title="On Cooperative Coevolution and Global Crossover">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Bull2024Global-GA,
  title      = {On Cooperative Coevolution and Global Crossover},
  author     = {Bull, Larry and Liu, Haixia},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2024},
  volume     = {28},
  number     = {2},
  pages      = {558-561},
  doi        = {10.1109/TEVC.2024.3355776},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/CEDE-DRL/CEDE_DRL.m"><code>CEDE_DRL</code></a> (SWEVO)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Reinforcement-learning-assisted coevolutionary DE.</td>
<td><a href="https://doi.org/10.1016/j.swevo.2023.101387" title="Deep reinforcement learning assisted co-evolutionary differential evolution for constrained optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Hu2023CEDE-DRL,
  title      = {Deep reinforcement learning assisted co-evolutionary differential evolution for constrained optimization},
  author     = {Zhenzhen Hu and Wenyin Gong and Witold Pedrycz and Yanchi Li},
  journal    = {Swarm and Evolutionary Computation},
  year       = {2023},
  volume     = {83},
  pages      = {101387},
  doi        = {10.1016/j.swevo.2023.101387},
  issn       = {2210-6502},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/LES/LES.m"><code>LES</code></a> (ICLR)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained / constrained</td>
<td>Evolution strategies discovered by meta-optimization.</td>
<td><a href="https://openreview.net/forum?id=mFDU0fP3EQH" title="Discovering Evolution Strategies via Meta-Black-Box Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Lange2023LES,
  title      = {Discovering Evolution Strategies via Meta-Black-Box Optimization},
  author     = {Robert Tjarko Lange and Tom Schaul and Yutian Chen and Tom Zahavy and Valentin Dalibard and Chris Lu and Satinder Singh and Sebastian Flennerhag},
  booktitle  = {The Eleventh International Conference on Learning Representations},
  year       = {2023},
  url        = {https://openreview.net/forum?id=mFDU0fP3EQH},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/VMCH/VMCH.m"><code>VMCH</code></a> (TEVC)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Voting ensemble of constraint-handling methods.</td>
<td><a href="https://doi.org/10.1109/TEVC.2021.3110130" title="A Voting-Mechanism-Based Ensemble Framework for Constraint Handling Techniques">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wu2022VMCH,
  title      = {A Voting-Mechanism-Based Ensemble Framework for Constraint Handling Techniques},
  author     = {Wu, Guohua and Wen, Xupeng and Wang, Ling and Pedrycz, Witold and Suganthan, Ponnuthurai Nagaratnam},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {4},
  pages      = {646-660},
  doi        = {10.1109/TEVC.2021.3110130},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Single-task/Swarm%20Intelligence/AO/AO.m"><code>AO</code></a> (CAIE)</td>
<td>Swarm intelligence</td>
<td>Single-task · unconstrained / constrained</td>
<td>Aquila optimizer.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Abualigah2021AO,
  title      = {Aquila Optimizer: A Novel Meta-heuristic Optimization Algorithm},
  author     = {Laith Abualigah and Dalia Yousri and Mohamed {Abd Elaziz} and Ahmed A. Ewees and Mohammed A.A. Al-qaness and Amir H. Gandomi},
  journal    = {Computers & Industrial Engineering},
  year       = {2021},
  volume     = {157},
  pages      = {107250},
  issn       = {0360-8352},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/DeCODE/DeCODE.m"><code>DeCODE</code></a> (TSMC-S)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Decomposition-based constrained optimization.</td>
<td><a href="https://doi.org/10.1109/TSMC.2018.2876335" title="Decomposition-Based Multiobjective Optimization for Constrained Evolutionary Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wang2021DeCODE,
  title      = {Decomposition-Based Multiobjective Optimization for Constrained Evolutionary Optimization},
  author     = {Wang, Bing-Chuan and Li, Han-Xiong and Zhang, Qingfu and Wang, Yong},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2021},
  volume     = {51},
  number     = {1},
  pages      = {574-587},
  doi        = {10.1109/TSMC.2018.2876335},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/NL-SHADE-RSP/NL_SHADE_RSP.m"><code>NL_SHADE_RSP</code></a> (CEC)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained</td>
<td>Nonlinear population reduction and selective pressure.</td>
<td><a href="https://doi.org/10.1109/CEC45853.2021.9504959" title="NL-SHADE-RSP Algorithm with Adaptive Archive and Selective Pressure for CEC 2021 Numerical Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Stanovov2021NL-SHADE-RSP,
  title      = {NL-SHADE-RSP Algorithm with Adaptive Archive and Selective Pressure for CEC 2021 Numerical Optimization},
  author     = {Stanovov, Vladimir and Akhmedova, Shakhnaz and Semenkin, Eugene},
  booktitle  = {2021 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2021},
  pages      = {809-816},
  doi        = {10.1109/CEC45853.2021.9504959},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/CORCO/CORCO.m"><code>CORCO</code></a> (TEVC)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Correlation between constraints and objective.</td>
<td><a href="https://doi.org/10.1109/TEVC.2019.2904900" title="Utilizing the Correlation Between Constraints and Objective Function for Constrained Evolutionary Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wang2020CORCO,
  title      = {Utilizing the Correlation Between Constraints and Objective Function for Constrained Evolutionary Optimization},
  author     = {Wang, Yong and Li, Jia-Peng and Xue, Xihui and Wang, Bing-chuan},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2020},
  volume     = {24},
  number     = {1},
  pages      = {29-43},
  doi        = {10.1109/TEVC.2019.2904900},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/DES/DES.m"><code>DES</code></a> (TEVC)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained / constrained</td>
<td>Matrix-free covariance-matrix adaptation.</td>
<td><a href="https://doi.org/10.1109/TEVC.2019.2907266" title="Toward a Matrix-Free Covariance Matrix Adaptation Evolution Strategy">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Arabas2020DES,
  title      = {Toward a Matrix-Free Covariance Matrix Adaptation Evolution Strategy},
  author     = {Arabas, Jarosław and Jagodziński, Dariusz},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2020},
  volume     = {24},
  number     = {1},
  pages      = {84-98},
  doi        = {10.1109/TEVC.2019.2907266},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Single-task/Swarm%20Intelligence/EO/EO.m"><code>EO</code></a> (KBS)</td>
<td>Swarm intelligence</td>
<td>Single-task · unconstrained / constrained</td>
<td>Equilibrium optimizer.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Faramarzi2020EO,
  title      = {Equilibrium Optimizer: A Novel Optimization Algorithm},
  author     = {Afshin Faramarzi and Mohammad Heidarinejad and Brent Stephens and Seyedali Mirjalili},
  journal    = {Knowledge-Based Systems},
  year       = {2020},
  volume     = {191},
  pages      = {105190},
  issn       = {0950-7051},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Single-task/Swarm%20Intelligence/MPA/MPA.m"><code>MPA</code></a> (ESWA)</td>
<td>Swarm intelligence</td>
<td>Single-task · unconstrained / constrained</td>
<td>Marine predators optimizer.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Faramarzi2020MPA,
  title      = {Marine Predators Algorithm: A Nature-inspired Metaheuristic},
  author     = {Afshin Faramarzi and Mohammad Heidarinejad and Seyedali Mirjalili and Amir H. Gandomi},
  journal    = {Expert Systems with Applications},
  year       = {2020},
  volume     = {152},
  pages      = {113377},
  issn       = {0957-4174},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/C2oDE/C2oDE.m"><code>C2oDE</code></a> (TSMC-S)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Composite DE for constrained optimization.</td>
<td><a href="https://doi.org/10.1109/TSMC.2018.2807785" title="Composite Differential Evolution for Constrained Evolutionary Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wang2019C2oDE,
  title      = {Composite Differential Evolution for Constrained Evolutionary Optimization},
  author     = {Wang, Bing-Chuan and Li, Han-Xiong and Li, Jia-Peng and Wang, Yong},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2019},
  volume     = {49},
  number     = {7},
  pages      = {1482-1495},
  doi        = {10.1109/TSMC.2018.2807785},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/CAL-SHADE/CAL_SHADE.m"><code>CAL_SHADE</code></a> (CEC)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Adaptive constraint handling with L-SHADE.</td>
<td><a href="https://doi.org/10.1109/CEC.2017.7969601" title="Adaptive Constraint Handling and Success History Differential Evolution for Cec 2017 Constrained Real-Parameter Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Zamuda2017CAL-SHADE,
  title      = {Adaptive Constraint Handling and Success History Differential Evolution for Cec 2017 Constrained Real-Parameter Optimization},
  author     = {Zamuda, Aleš},
  booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2017},
  pages      = {2443-2450},
  doi        = {10.1109/CEC.2017.7969601},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/jSO/jSO.m"><code>jSO</code></a> (CEC)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Improved DE for single-objective optimization.</td>
<td><a href="https://doi.org/10.1109/CEC.2017.7969456" title="Single Objective Real-Parameter Optimization: Algorithm jSO">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Brest2017jSO,
  title      = {Single Objective Real-Parameter Optimization: Algorithm jSO},
  author     = {Brest, Janez and Maučec, Mirjam Sepesy and Bošković, Borko},
  booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2017},
  pages      = {1311-1318},
  doi        = {10.1109/CEC.2017.7969456},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/LSHADE44/LSHADE44.m"><code>LSHADE44</code></a> (CEC)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Competing DE strategies for constrained optimization.</td>
<td><a href="https://doi.org/10.1109/CEC.2017.7969504" title="L-shade with Competing Strategies Applied to Constrained Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Polakova2017LSHADE44,
  title      = {L-shade with Competing Strategies Applied to Constrained Optimization},
  author     = {Poláková, Radka},
  booktitle  = {2017 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2017},
  pages      = {1683-1689},
  doi        = {10.1109/CEC.2017.7969504},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/OpenAI-ES/OpenAI_ES.m"><code>OpenAI_ES</code></a> (arXiv)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained / constrained</td>
<td>Scalable gradient-free evolution strategy.</td>
<td><a href="https://arxiv.org/abs/1703.03864" title="Evolution Strategies as a Scalable Alternative to Reinforcement Learning">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@misc{Salimans2017OpenAI-ES,
  title      = {Evolution Strategies as a Scalable Alternative to Reinforcement Learning},
  author     = {Tim Salimans and Jonathan Ho and Xi Chen and Szymon Sidor and Ilya Sutskever},
  year       = {2017},
  archiveprefix = {arXiv},
  eprint     = {1703.03864},
  primaryclass = {stat.ML},
}
```

</details>
</td>
</tr>
<tr>
<td>2016</td>
<td><a href="../MTO/Algorithms/Single-task/Estimation%20of%20Distribution/EDAver/EDAver.m"><code>EDAver</code></a> (CEC)</td>
<td>Estimation of distribution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Distribution estimation using variable relationships.</td>
<td><a href="https://doi.org/10.1109/CEC.2016.7744225" title="Enhance Continuous Estimation of Distribution Algorithm by Variance Enlargement and Reflecting Sampling">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Ren2016EDAver,
  title      = {Enhance Continuous Estimation of Distribution Algorithm by Variance Enlargement and Reflecting Sampling},
  author     = {Ren, Zhigang and He, Chenlong and Zhong, Dexing and Huang, Shanshan and Liang, Yongsheng},
  booktitle  = {2016 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2016},
  pages      = {3441-3447},
  doi        = {10.1109/CEC.2016.7744225},
}
```

</details>
</td>
</tr>
<tr>
<td>2016</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/FROFI/FROFI.m"><code>FROFI</code></a> (TCYB)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Objective information in the feasibility rule.</td>
<td><a href="https://doi.org/10.1109/TCYB.2015.2493239" title="Incorporating Objective Function Information Into the Feasibility Rule for Constrained Evolutionary Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wang2016FROFI,
  title      = {Incorporating Objective Function Information Into the Feasibility Rule for Constrained Evolutionary Optimization},
  author     = {Wang, Yong and Wang, Bing-Chuan and Li, Han-Xiong and Yen, Gary G.},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2016},
  volume     = {46},
  number     = {12},
  pages      = {2938-2952},
  doi        = {10.1109/TCYB.2015.2493239},
}
```

</details>
</td>
</tr>
<tr>
<td>2015</td>
<td><a href="../MTO/Algorithms/Single-task/Swarm%20Intelligence/CSO/CSO.m"><code>CSO</code></a> (TCYB)</td>
<td>Swarm intelligence</td>
<td>Single-task · unconstrained / constrained</td>
<td>Competitive swarm optimization.</td>
<td><a href="https://doi.org/10.1109/TCYB.2014.2322602" title="A Competitive Swarm Optimizer for Large Scale Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Cheng2015CSO,
  title      = {A Competitive Swarm Optimizer for Large Scale Optimization},
  author     = {Cheng, Ran and Jin, Yaochu},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2015},
  volume     = {45},
  number     = {2},
  pages      = {191-204},
  doi        = {10.1109/TCYB.2014.2322602},
}
```

</details>
</td>
</tr>
<tr>
<td>2014</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/L-SHADE/L_SHADE.m"><code>L_SHADE</code></a> (CEC)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>SHADE with linear population-size reduction.</td>
<td><a href="https://doi.org/10.1109/CEC.2014.6900380" title="Improving the Search Performance of Shade Using Linear Population Size Reduction">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Tanabe2014LSHADE,
  title      = {Improving the Search Performance of Shade Using Linear Population Size Reduction},
  author     = {Tanabe, Ryoji and Fukunaga, Alex S.},
  booktitle  = {2014 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2014},
  pages      = {1658-1665},
  doi        = {10.1109/CEC.2014.6900380},
}
```

</details>
</td>
</tr>
<tr>
<td>2013</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/R1-NES/R1_NES.m"><code>R1_NES</code></a> (GECCO-C)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained / constrained</td>
<td>Linear-time natural evolution strategy.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Sun2013R1-NES,
  title      = {A Linear Time Natural Evolution Strategy for Non-Separable Functions},
  author     = {Sun, Yi and Schaul, Tom and Gomez, Faustino and Schmidhuber, J\"{u}rgen},
  booktitle  = {Proceedings of the 15th Annual Conference Companion on Genetic and Evolutionary Computation},
  year       = {2013},
  pages      = {61–62},
}
```

</details>
</td>
</tr>
<tr>
<td>2013</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/rank-DE/rank_DE.m"><code>rank_DE</code></a> (TCYB)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Ranking-based DE mutation.</td>
<td><a href="https://doi.org/10.1109/TCYB.2013.2239988" title="Differential Evolution With Ranking-Based Mutation Operators">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Gong2013rank-DE,
  title      = {Differential Evolution With Ranking-Based Mutation Operators},
  author     = {Gong, Wenyin and Cai, Zhihua},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2013},
  volume     = {43},
  number     = {6},
  pages      = {2066-2081},
  doi        = {10.1109/TCYB.2013.2239988},
}
```

</details>
</td>
</tr>
<tr>
<td>2013</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/rank-DE/rank_jDE.m"><code>rank_jDE</code></a> (TCYB)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Ranking-based DE mutation.</td>
<td><a href="https://doi.org/10.1109/TCYB.2013.2239988" title="Differential Evolution With Ranking-Based Mutation Operators">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Gong2013rank-DE,
  title      = {Differential Evolution With Ranking-Based Mutation Operators},
  author     = {Gong, Wenyin and Cai, Zhihua},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2013},
  volume     = {43},
  number     = {6},
  pages      = {2066-2081},
  doi        = {10.1109/TCYB.2013.2239988},
}
```

</details>
</td>
</tr>
<tr>
<td>2013</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/SHADE/SHADE.m"><code>SHADE</code></a> (CEC)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Success-history parameter adaptation.</td>
<td><a href="https://doi.org/10.1109/CEC.2013.6557555" title="Success-history based Parameter adaptation for Differential Evolution">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Tanabe2013SHADE,
  title      = {Success-history based Parameter adaptation for Differential Evolution},
  author     = {Tanabe, Ryoji and Fukunaga, Alex},
  booktitle  = {2013 IEEE Congress on Evolutionary Computation},
  year       = {2013},
  pages      = {71-78},
  doi        = {10.1109/CEC.2013.6557555},
}
```

</details>
</td>
</tr>
<tr>
<td>2012</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/xNES-as/xNES_as.m"><code>xNES_as</code></a> (GECCO-C / JMLR)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained / constrained</td>
<td>Natural ES with adaptation sampling.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX · GECCO-C · 2012</summary>

```bibtex
@inproceedings{Schaul2012xNES-as,
  title      = {Benchmarking Natural Evolution Strategies with Adaptation Sampling on the Noiseless and Noisy Black-Box Optimization Testbeds},
  author     = {Schaul, Tom},
  booktitle  = {Proceedings of the 14th Annual Conference Companion on Genetic and Evolutionary Computation},
  year       = {2012},
  pages      = {229–236},
}
```

</details>
<details>
<summary>BibTeX · JMLR · 2014</summary>

```bibtex
@article{Wierstra2014NES,
  title      = {Natural Evolution Strategies},
  author     = {Daan Wierstra and Tom Schaul and Tobias Glasmachers and Yi Sun and Jan Peters and J\"{u}rgen Schmidhuber},
  journal    = {Journal of Machine Learning Research},
  year       = {2014},
  volume     = {15},
  number     = {27},
  pages      = {949--980},
}
```

</details>
</td>
</tr>
<tr>
<td>2011</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/SNES/SNES.m"><code>SNES</code></a> (GECCO / JMLR)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained / constrained</td>
<td>Separable natural evolution strategy.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX · GECCO · 2011</summary>

```bibtex
@inproceedings{Schaul2011SNES,
  title      = {High Dimensions and Heavy Tails for Natural Evolution Strategies},
  author     = {Schaul, Tom and Glasmachers, Tobias and Schmidhuber, J\"{u}rgen},
  booktitle  = {Proceedings of the 13th Annual Conference on Genetic and Evolutionary Computation},
  year       = {2011},
  pages      = {845–852},
}
```

</details>
<details>
<summary>BibTeX · JMLR · 2014</summary>

```bibtex
@article{Wierstra2014NES,
  title      = {Natural Evolution Strategies},
  author     = {Daan Wierstra and Tom Schaul and Tobias Glasmachers and Yi Sun and Jan Peters and J\"{u}rgen Schmidhuber},
  journal    = {Journal of Machine Learning Research},
  year       = {2014},
  volume     = {15},
  number     = {27},
  pages      = {949--980},
}
```

</details>
</td>
</tr>
<tr>
<td>2010</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/ECHT/ECHT.m"><code>ECHT</code></a> (TEVC)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Ensemble of constraint-handling techniques.</td>
<td><a href="https://doi.org/10.1109/TEVC.2009.2033582" title="Ensemble of Constraint Handling Techniques">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Mallipeddi2010ECHT,
  title      = {Ensemble of Constraint Handling Techniques},
  author     = {Mallipeddi, Rammohan and Suganthan, Ponnuthurai N.},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2010},
  volume     = {14},
  number     = {4},
  pages      = {561-579},
  doi        = {10.1109/TEVC.2009.2033582},
}
```

</details>
</td>
</tr>
<tr>
<td>2010</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/xNES/xNES.m"><code>xNES</code></a> (GECCO / JMLR)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained / constrained</td>
<td>Exponential natural evolution strategy.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX · GECCO · 2010</summary>

```bibtex
@inproceedings{Glasmachers2010xNES,
  title      = {Exponential Natural Evolution Strategies},
  author     = {Glasmachers, Tobias and Schaul, Tom and Yi, Sun and Wierstra, Daan and Schmidhuber, J\"{u}rgen},
  booktitle  = {Proceedings of the 12th Annual Conference on Genetic and Evolutionary Computation},
  year       = {2010},
  pages      = {393–400},
}
```

</details>
<details>
<summary>BibTeX · JMLR · 2014</summary>

```bibtex
@article{Wierstra2014NES,
  title      = {Natural Evolution Strategies},
  author     = {Daan Wierstra and Tom Schaul and Tobias Glasmachers and Yi Sun and Jan Peters and J\"{u}rgen Schmidhuber},
  journal    = {Journal of Machine Learning Research},
  year       = {2014},
  volume     = {15},
  number     = {27},
  pages      = {949--980},
}
```

</details>
</td>
</tr>
<tr>
<td>2009</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/SaDE/SaDE.m"><code>SaDE</code></a> (TEVC)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Self-adaptive DE strategies and parameters.</td>
<td><a href="https://doi.org/10.1109/TEVC.2008.927706" title="Differential Evolution Algorithm With Strategy Adaptation for Global Numerical Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Qin2009SaDE,
  title      = {Differential Evolution Algorithm With Strategy Adaptation for Global Numerical Optimization},
  author     = {Qin, A. K. and Huang, V. L. and Suganthan, P. N.},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2009},
  volume     = {13},
  number     = {2},
  pages      = {398-417},
  doi        = {10.1109/TEVC.2008.927706},
}
```

</details>
</td>
</tr>
<tr>
<td>2008</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/sep-CMA-ES/sep_CMA_ES.m"><code>sep_CMA_ES</code></a> (PPSN)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained / constrained</td>
<td>Separable covariance-matrix adaptation.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Ros2008sep-CMA-ES,
  title      = {A Simple Modification in CMA-ES Achieving Linear Time and Space Complexity},
  author     = {Ros, Raymond and Hansen, Nikolaus},
  booktitle  = {Parallel Problem Solving from Nature -- PPSN X},
  editor     = {Rudolph, G{\"u}nter and Jansen, Thomas and Beume, Nicola and Lucas, Simon and Poloni, Carlo},
  year       = {2008},
  pages      = {296--305},
  publisher  = {Springer Berlin Heidelberg},
  address    = {Berlin, Heidelberg},
  isbn       = {978-3-540-87700-4},
}
```

</details>
</td>
</tr>
<tr>
<td>2007</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/JADE/JADE.m"><code>JADE</code></a> (CEC)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Self-adaptive DE with fast convergence.</td>
<td><a href="https://doi.org/10.1109/CEC.2007.4424751" title="Jade: Self-adaptive Differential Evolution with Fast and Reliable Convergence Performance">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Zhang2007JADE,
  title      = {Jade: Self-adaptive Differential Evolution with Fast and Reliable Convergence Performance},
  author     = {Jingqiao Zhang and Sanderson, Arthur C.},
  booktitle  = {2007 IEEE Congress on Evolutionary Computation},
  year       = {2007},
  pages      = {2251-2258},
  doi        = {10.1109/CEC.2007.4424751},
}
```

</details>
</td>
</tr>
<tr>
<td>2007</td>
<td><a href="../MTO/Algorithms/Single-task/Constraint%20Handling/MTV-DE/MTV_DE.m"><code>MTV_DE</code></a> (Eng. Optim.)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Multiple DE trial vectors for constraint handling.</td>
<td><a href="https://doi.org/10.1080/03052150701364022" title="Multiple Trial Vectors in Differential Evolution for Engineering Design">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{MezuraMontes2007MTV-DE,
  title      = {Multiple Trial Vectors in Differential Evolution for Engineering Design},
  author     = {E. Mezura-Montes and C. A. Coello Coello and J. Velázquez-Reyes and L. Muñoz-Dávila},
  journal    = {Engineering Optimization},
  year       = {2007},
  volume     = {39},
  number     = {5},
  pages      = {567-589},
  publisher  = {Taylor & Francis},
  doi        = {10.1080/03052150701364022},
}
```

</details>
</td>
</tr>
<tr>
<td>2006</td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/jDE/jDE.m"><code>jDE</code></a> (TEVC)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Self-adaptive DE control parameters.</td>
<td><a href="https://doi.org/10.1109/TEVC.2006.872133" title="Self-Adapting Control Parameters in Differential Evolution: A Comparative Study on Numerical Benchmark Problems">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Brest2006jDE,
  title      = {Self-Adapting Control Parameters in Differential Evolution: A Comparative Study on Numerical Benchmark Problems},
  author     = {Brest, Janez and Greiner, Sao and Boskovic, Borko and Mernik, Marjan and Zumer, Viljem},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2006},
  volume     = {10},
  number     = {6},
  pages      = {646-657},
  doi        = {10.1109/TEVC.2006.872133},
}
```

</details>
</td>
</tr>
<tr>
<td>2005</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/IPOP-CMA-ES/IPOP_CMA_ES.m"><code>IPOP_CMA_ES</code></a> (CEC)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained</td>
<td>Restarts with increasing population sizes.</td>
<td><a href="https://doi.org/10.1109/CEC.2005.1554902" title="A Restart CMA Evolution Strategy with Increasing Population Size">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Auger2005IPOP-CMA-ES,
  title      = {A Restart CMA Evolution Strategy with Increasing Population Size},
  author     = {Auger, A. and Hansen, N.},
  booktitle  = {2005 IEEE Congress on Evolutionary Computation},
  year       = {2005},
  volume     = {2},
  pages      = {1769-1776 Vol. 2},
  doi        = {10.1109/CEC.2005.1554902},
}
```

</details>
</td>
</tr>
<tr>
<td>2001</td>
<td><a href="../MTO/Algorithms/Single-task/Evolution%20Strategy/CMA-ES/CMA_ES.m"><code>CMA_ES</code></a> (EC)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained / constrained</td>
<td>Covariance-matrix adaptation.</td>
<td><a href="https://doi.org/10.1162/106365601750190398" title="Completely Derandomized Self-Adaptation in Evolution Strategies">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Hansen2001CMA-ES,
  title      = {Completely Derandomized Self-Adaptation in Evolution Strategies},
  author     = {Hansen, Nikolaus and Ostermeier, Andreas},
  journal    = {Evolutionary Computation},
  year       = {2001},
  volume     = {9},
  number     = {2},
  pages      = {159-195},
  doi        = {10.1162/106365601750190398},
}
```

</details>
</td>
</tr>
<tr>
<td><abbr title="Baseline reference year; class year is Unknown">1996†</abbr></td>
<td><a href="../MTO/Algorithms/Single-task/Differential%20Evolution/DE/DE.m"><code>DE</code></a> (NAFIPS)</td>
<td>Differential evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>DE/rand/1/bin baseline.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Storn1996DE,
  title      = {On the Usage of Differential Evolution for Function Optimization},
  author     = {Storn, Rainer},
  booktitle  = {Proceedings of North American Fuzzy Information Processing},
  year       = {1996},
  pages      = {519--523},
  publisher  = {IEEE},
}
```

</details>
</td>
</tr>
<tr>
<td><abbr title="Baseline reference year; class year is Unknown">1996†</abbr></td>
<td><a href="../MTO/Algorithms/Single-task/Genetic%20Algorithm/GA/GA.m"><code>GA</code></a> (Springer · book)</td>
<td>Genetic algorithm</td>
<td>Single-task · unconstrained / constrained</td>
<td>SBX crossover and polynomial mutation.</td>
<td><a href="https://doi.org/10.1007/978-3-662-03315-9" title="Genetic Algorithms + Data Structures = Evolution Programs">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@book{Michalewicz1996GA,
  title      = {Genetic Algorithms + Data Structures = Evolution Programs},
  author     = {Michalewicz, Zbigniew},
  year       = {1996},
  edition    = {3},
  publisher  = {Springer Berlin, Heidelberg},
  doi        = {10.1007/978-3-662-03315-9},
}
```

</details>
</td>
</tr>
<tr>
<td>1995</td>
<td><a href="../MTO/Algorithms/Single-task/Swarm%20Intelligence/PSO/PSO.m"><code>PSO</code></a> (ICNN)</td>
<td>Swarm intelligence</td>
<td>Single-task · unconstrained / constrained</td>
<td>Global-best particle swarm optimization.</td>
<td><a href="https://doi.org/10.1109/ICNN.1995.488968" title="Particle Swarm Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Kennedy1995PSO,
  title      = {Particle Swarm Optimization},
  author     = {Kennedy, J. and Eberhart, R.},
  booktitle  = {Proceedings of ICNN'95 - International Conference on Neural Networks},
  year       = {1995},
  volume     = {4},
  pages      = {1942-1948 vol.4},
  doi        = {10.1109/ICNN.1995.488968},
}
```

</details>
</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)

## Multiobjective multitask optimization

<table>
<thead>
<tr><th>Year ↓</th><th>Algorithm / source</th><th>Method</th><th>Task support / constraints</th><th>Highlights</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2026</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/EMT-MSKT/EMT_MSKT.m"><code>EMT_MSKT</code></a> (TSMC-S)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Manifold-structure-driven knowledge transfer.</td>
<td><a href="https://doi.org/10.1109/TSMC.2025.3649528" title="Multiobjective Multitask Optimization With Manifold Structure-Driven Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhang2026EMT-MSKT,
  title      = {Multiobjective Multitask Optimization With Manifold Structure-Driven Knowledge Transfer},
  author     = {Zhang, Tingyu and Wu, Xinyi and Li, Yanchi and Li, Shuijia and Gong, Wenyin},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2026},
  volume     = {56},
  number     = {4},
  pages      = {2426-2438},
  doi        = {10.1109/TSMC.2025.3649528},
}
```

</details>
</td>
</tr>
<tr>
<td>2026</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MMTO-ETA/MMTO_ETA.m"><code>MMTO_ETA</code></a> (TAI)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Ensemble transfer with adaptive resource allocation.</td>
<td><a href="https://doi.org/10.1109/TAI.2026.3689513" title="Ensemble of Transfer Techniques via Adaptive Resource Allocation for Multiobjective Multitask Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhang2026MMTO-ETA,
  title      = {Ensemble of Transfer Techniques via Adaptive Resource Allocation for Multiobjective Multitask Optimization},
  author     = {Zhang, Tingyu and Huang, Kuihua and Wu, Xinyi and Li, Yanchi and Liu, Jianfeng and Li, Shuijia and Gong, Wenyin},
  journal    = {IEEE Transactions on Artificial Intelligence},
  year       = {2026},
  pages      = {1-13},
  doi        = {10.1109/TAI.2026.3689513},
}
```

</details>
</td>
</tr>
<tr>
<td>2026</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MMTO-TGT/MMTO_TGT.m"><code>MMTO_TGT</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Topology-guided knowledge transfer.</td>
<td><a href="https://doi.org/10.1109/TEVC.2026.3696355" title="Topology-Guided Knowledge Transfer for Multiobjective Multitask Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhang2026MMTO-TGT,
  title      = {Topology-Guided Knowledge Transfer for Multiobjective Multitask Optimization},
  author     = {Zhang, Tingyu and Wu, Xinyi and Gong, Wenyin and Li, Shuijia and Li, Yanchi and Qin, A. K.},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2026},
  doi        = {10.1109/TEVC.2026.3696355},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MO-MTEA-PAE/MO_MTEA_PAE.m"><code>MO_MTEA_PAE</code></a> (ASOC)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Progressive Auto-Encoding for Domain Adaptation in Evolutionary Multi-Task Optimization.</td>
<td><a href="https://doi.org/10.1016/j.asoc.2025.113916" title="Progressive Auto-Encoding for Domain Adaptation in Evolutionary Multi-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Gu2025MTEA-PAE,
  title      = {Progressive Auto-Encoding for Domain Adaptation in Evolutionary Multi-Task Optimization},
  author     = {Qiong Gu and Yanchi Li and Wenyin Gong and Zhiyuan Yuan and Bin Ning and Chunyang Hu and Jicheng Wu},
  journal    = {Applied Soft Computing},
  year       = {2025},
  pages      = {113916},
  doi        = {10.1016/j.asoc.2025.113916},
  issn       = {1568-4946},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MTDE-MKTA/MTDE_MKTA.m"><code>MTDE_MKTA</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Multiple knowledge types and transfer adaptation.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3353319" title="Multiobjective Multitask Optimization With Multiple Knowledge Types and Transfer Adaptation">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MTEA-DCK/MTEA_DCK.m"><code>MTEA_DCK</code></a> (TSMC-S)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Diversity and convergence knowledge transfer.</td>
<td><a href="https://doi.org/10.1109/TSMC.2024.3520526" title="Multiobjective Multitask Optimization via Diversity- and Convergence-Oriented Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2025MTEA-DCK,
  title      = {Multiobjective Multitask Optimization via Diversity- and Convergence-Oriented Knowledge Transfer},
  author     = {Li, Yanchi and Li, Dongcheng and Gong, Wenyin and Gu, Qiong},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2025},
  volume     = {55},
  number     = {3},
  pages      = {2367-2379},
  doi        = {10.1109/TSMC.2024.3520526},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Competitive%20Multi-task/RVC-MTEA/RVC_MTEA.m"><code>RVC_MTEA</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask · constrained / competitive</td>
<td>Reference-vector contribution for competitive tasks.</td>
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
<td>2024</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MTEA-D-TSD/MTEA_D_TSD.m"><code>MTEA_D_TSD</code></a> (GECCO)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Search-direction transfer among decomposed subtasks.</td>
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
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-factorial/EMT-GS/EMT_GS.m"><code>EMT_GS</code></a> (TEVC)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Generative-adversarial transfer.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3189029" title="Evolutionary Multitasking for Optimization Based on Generative Strategies">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liang2023EMT-GS,
  title      = {Evolutionary Multitasking for Optimization Based on Generative Strategies},
  author     = {Liang, Zhengping and Zhu, Yingmiao and Wang, Xiyu and Li, Zhi and Zhu, Zexuan},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2023},
  volume     = {27},
  number     = {4},
  pages      = {1042-1056},
  doi        = {10.1109/TEVC.2022.3189029},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/KR-MTEA/KR_MTEA.m"><code>KR_MTEA</code></a> (INS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained</td>
<td>Adaptive knowledge reuse. Supports single- and multiobjective problems.</td>
<td><a href="https://doi.org/10.1016/j.ins.2023.119568" title="Adaptive Multi-task Evolutionary Algorithm Based on Knowledge Reuse">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Cui2023Adaptive,
  title      = {Adaptive Multi-task Evolutionary Algorithm Based on Knowledge Reuse},
  author     = {Cui, Zhihua and Zhao, Ben and Zhao, Tianhao and Cai, Xingjuan and Chen, Jinjun},
  journal    = {Information Sciences},
  year       = {2023},
  volume     = {648},
  pages      = {119568},
  doi        = {10.1016/j.ins.2023.119568},
  month      = {08},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MO-MTEA-SaO/MO_MTEA_SaO.m"><code>MO_MTEA_SaO</code></a> (INS)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Multitasking Optimization via an Adaptive Solver Multitasking Evolutionary Framework.</td>
<td><a href="https://doi.org/10.1016/j.ins.2022.10.099" title="Multitasking Optimization via an Adaptive Solver Multitasking Evolutionary Framework">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MTEA-D-DN/MTEA_D_DN.m"><code>MTEA_D_DN</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained</td>
<td>Neighborhood transfer in decomposition-based search.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3154416" title="Multiobjective Multitask Optimization - Neighborhood as a Bridge for Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Wang2023MTEA-D-DN,
  title      = {Multiobjective Multitask Optimization - Neighborhood as a Bridge for Knowledge Transfer},
  author     = {Wang, Xianpeng and Dong, Zhiming and Tang, Lixin and Zhang, Qingfu},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2023},
  volume     = {27},
  number     = {1},
  pages      = {155-169},
  doi        = {10.1109/TEVC.2022.3154416},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-factorial/EMT-PD/EMT_PD.m"><code>EMT_PD</code></a> (TSMC-S)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Population-distribution-based two-stage transfer.</td>
<td><a href="https://doi.org/10.1109/TSMC.2021.3096220" title="Multiobjective Evolutionary Multitasking With Two-Stage Adaptive Knowledge Transfer Based on Population Distribution">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liang2022EMT-PD,
  title      = {Multiobjective Evolutionary Multitasking With Two-Stage Adaptive Knowledge Transfer Based on Population Distribution},
  author     = {Liang, Zhengping and Liang, Weiqi and Wang, Zhiqiang and Ma, Xiaoliang and Liu, Ling and Zhu, Zexuan},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2022},
  volume     = {52},
  number     = {7},
  pages      = {4457-4469},
  doi        = {10.1109/TSMC.2021.3096220},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MOMFEA-SADE/MOMFEA_SADE.m"><code>MOMFEA_SADE</code></a> (TCYB)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Subspace alignment and adaptive DE.</td>
<td><a href="https://doi.org/10.1109/TCYB.2020.2980888" title="Evolutionary Multitasking for Multiobjective Optimization With Subspace Alignment and Adaptive Differential Evolution">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liang2022MOMFEA-SADE,
  title      = {Evolutionary Multitasking for Multiobjective Optimization With Subspace Alignment and Adaptive Differential Evolution},
  author     = {Liang, Zhengping and Dong, Hao and Liu, Cheng and Liang, Weiqi and Zhu, Zexuan},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2022},
  volume     = {52},
  number     = {4},
  pages      = {2096-2109},
  doi        = {10.1109/TCYB.2020.2980888},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/EMT-ET/EMT_ET.m"><code>EMT_ET</code></a> (TCYB)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Effective transfer with nondominated selection.</td>
<td><a href="https://doi.org/10.1109/TCYB.2020.2969025" title="An Effective Knowledge Transfer Approach for Multiobjective Multitasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Lin2021EMT-ET,
  title      = {An Effective Knowledge Transfer Approach for Multiobjective Multitasking Optimization},
  author     = {Lin, Jiabin and Liu, Hai-Lin and Tan, Kay Chen and Gu, Fangqing},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2021},
  volume     = {51},
  number     = {6},
  pages      = {3238-3248},
  doi        = {10.1109/TCYB.2020.2969025},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-factorial/MO-MFEA-II/MO_MFEA_II.m"><code>MO_MFEA_II</code></a> (TCYB)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Cognizant transfer-parameter estimation.</td>
<td><a href="https://doi.org/10.1109/TCYB.2020.2981733" title="Cognizant Multitasking in Multiobjective Multifactorial Evolution: MO-MFEA-II">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Bali2021MO-MFEA2,
  title      = {Cognizant Multitasking in Multiobjective Multifactorial Evolution: MO-MFEA-II},
  author     = {Bali, Kavitesh Kumar and Gupta, Abhishek and Ong, Yew-Soon and Tan, Puay Siew},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2021},
  volume     = {51},
  number     = {4},
  pages      = {1784-1796},
  doi        = {10.1109/TCYB.2020.2981733},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/AMT-NSGA-II/AMT_NSGA_II.m"><code>AMT_NSGA_II</code></a> (TCYB)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Online control of negative transfer.</td>
<td><a href="https://doi.org/10.1109/TCYB.2018.2864345" title="Curbing Negative Influences Online for Seamless Transfer Evolutionary Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Da2019AMTEA,
  title      = {Curbing Negative Influences Online for Seamless Transfer Evolutionary Optimization},
  author     = {Da, Bingshui and Gupta, Abhishek and Ong, Yew-Soon},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2019},
  volume     = {49},
  number     = {12},
  pages      = {4365-4378},
  doi        = {10.1109/TCYB.2018.2864345},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MO-EMEA/MO_EMEA.m"><code>MO_EMEA</code></a> (TCYB)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Evolutionary Multitasking via Explicit Autoencoding.</td>
<td><a href="https://doi.org/10.1109/TCYB.2018.2845361" title="Evolutionary Multitasking via Explicit Autoencoding">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Feng2019EMEA,
  title      = {Evolutionary Multitasking via Explicit Autoencoding},
  author     = {Feng, Liang and Zhou, Lei and Zhong, Jinghui and Gupta, Abhishek and Ong, Yew-Soon and Tan, Kay-Chen and Qin, A. K.},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2019},
  volume     = {49},
  number     = {9},
  pages      = {3457-3470},
  doi        = {10.1109/TCYB.2018.2845361},
}
```

</details>
</td>
</tr>
<tr>
<td>2018</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MM-DE/MM_DE.m"><code>MM_DE</code></a> (CEC)</td>
<td>Multipopulation</td>
<td>Multitask · unconstrained / constrained</td>
<td>Fast memetic multiobjective differential evolution.</td>
<td><a href="https://doi.org/10.1109/CEC.2018.8477722" title="A Fast Memetic Multi-Objective Differential Evolution for Multi-Tasking Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Chen2018MM-DE,
  title      = {A Fast Memetic Multi-Objective Differential Evolution for Multi-Tasking Optimization},
  author     = {Chen, Yongliang and Zhong, Jinghui and Tan, Mingkui},
  booktitle  = {2018 IEEE Congress on Evolutionary Computation (CEC)},
  year       = {2018},
  pages      = {1-8},
  doi        = {10.1109/CEC.2018.8477722},
}
```

</details>
</td>
</tr>
<tr>
<td>2017</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-factorial/MO-MFEA/MO_MFEA.m"><code>MO_MFEA</code></a> (TCYB)</td>
<td>Multifactorial</td>
<td>Multitask · unconstrained / constrained</td>
<td>Multiobjective multifactorial evolution.</td>
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
<tr><th>Year ↓</th><th>Algorithm / source</th><th>Method</th><th>Task support / constraints</th><th>Highlights</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2026</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MMTO-TGT/MMTO_TGT.m"><code>MMTO_TGT</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Topology-guided knowledge transfer.</td>
<td><a href="https://doi.org/10.1109/TEVC.2026.3696355" title="Topology-Guided Knowledge Transfer for Multiobjective Multitask Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhang2026MMTO-TGT,
  title      = {Topology-Guided Knowledge Transfer for Multiobjective Multitask Optimization},
  author     = {Zhang, Tingyu and Wu, Xinyi and Gong, Wenyin and Li, Shuijia and Li, Yanchi and Qin, A. K.},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2026},
  doi        = {10.1109/TEVC.2026.3696355},
}
```

</details>
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MTDE-MKTA/MTDE_MKTA.m"><code>MTDE_MKTA</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Multiple knowledge types and transfer adaptation.</td>
<td><a href="https://doi.org/10.1109/TEVC.2024.3353319" title="Multiobjective Multitask Optimization With Multiple Knowledge Types and Transfer Adaptation">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

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
</td>
</tr>
<tr>
<td>2025</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Multi-population/MTEA-DCK/MTEA_DCK.m"><code>MTEA_DCK</code></a> (TSMC-S)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained / constrained</td>
<td>Diversity and convergence knowledge transfer.</td>
<td><a href="https://doi.org/10.1109/TSMC.2024.3520526" title="Multiobjective Multitask Optimization via Diversity- and Convergence-Oriented Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2025MTEA-DCK,
  title      = {Multiobjective Multitask Optimization via Diversity- and Convergence-Oriented Knowledge Transfer},
  author     = {Li, Yanchi and Li, Dongcheng and Gong, Wenyin and Gu, Qiong},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2025},
  volume     = {55},
  number     = {3},
  pages      = {2367-2379},
  doi        = {10.1109/TSMC.2024.3520526},
}
```

</details>
</td>
</tr>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-task/Many-task/KR-MTEA/KR_MTEA.m"><code>KR_MTEA</code></a> (INS)</td>
<td>Multipopulation</td>
<td>Multitask / many-task · unconstrained</td>
<td>Adaptive knowledge reuse. Supports single- and multiobjective problems.</td>
<td><a href="https://doi.org/10.1016/j.ins.2023.119568" title="Adaptive Multi-task Evolutionary Algorithm Based on Knowledge Reuse">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Cui2023Adaptive,
  title      = {Adaptive Multi-task Evolutionary Algorithm Based on Knowledge Reuse},
  author     = {Cui, Zhihua and Zhao, Ben and Zhao, Tianhao and Cai, Xingjuan and Chen, Jinjun},
  journal    = {Information Sciences},
  year       = {2023},
  volume     = {648},
  pages      = {119568},
  doi        = {10.1016/j.ins.2023.119568},
  month      = {08},
}
```

</details>
</td>
</tr>
<tr>
<td>2022</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Many-task/MO-EMaTO-MKT/MO_EMaTO_MKT.m"><code>MO_EMaTO_MKT</code></a> (TEVC)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained</td>
<td>Evolutionary Many-Task Optimization Based on Multi-Source Knowledge Transfer.</td>
<td><a href="https://doi.org/10.1109/TEVC.2021.3101697" title="Evolutionary Many-Task Optimization Based on Multi-Source Knowledge Transfer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liang2022EMaTO-MKT,
  title      = {Evolutionary Many-Task Optimization Based on Multi-Source Knowledge Transfer},
  author     = {Liang, Zhengping and Xu, Xiuju and Liu, Ling and Tu, Yaofeng and Zhu, Zexuan},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2022},
  volume     = {26},
  number     = {2},
  pages      = {319-333},
  doi        = {10.1109/TEVC.2021.3101697},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Many-task/MO-MaTDE/MO_MaTDE.m"><code>MO_MaTDE</code></a> (TETCI)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>An Adaptive Archive-Based Evolutionary Framework for Many-Task Optimization.</td>
<td><a href="https://doi.org/10.1109/TETCI.2019.2916051" title="An Adaptive Archive-Based Evolutionary Framework for Many-Task Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Chen2020MaTDE,
  title      = {An Adaptive Archive-Based Evolutionary Framework for Many-Task Optimization},
  author     = {Chen, Yongliang and Zhong, Jinghui and Feng, Liang and Zhang, Jun},
  journal    = {IEEE Transactions on Emerging Topics in Computational Intelligence},
  year       = {2020},
  volume     = {4},
  number     = {3},
  pages      = {369-384},
  doi        = {10.1109/TETCI.2019.2916051},
}
```

</details>
</td>
</tr>
<tr>
<td>2019</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Multi-task/Many-task/MO-SBO/MO_SBO.m"><code>MO_SBO</code></a> (AAAI)</td>
<td>Multipopulation</td>
<td>many-task · unconstrained / constrained</td>
<td>Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis.</td>
<td><a href="https://doi.org/10.1609/aaai.v33i01.33014295" title="Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Liaw2019SBO,
  title      = {Evolutionary Manytasking Optimization Based on Symbiosis in Biocoenosis},
  author     = {Liaw, Rung-Tzuo and Ting, Chuan-Kang},
  journal    = {Proceedings of the AAAI Conference on Artificial Intelligence},
  year       = {2019},
  volume     = {33},
  number     = {01},
  pages      = {4295-4303},
  doi        = {10.1609/aaai.v33i01.33014295},
  month      = {Jul.},
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
<tr><th>Year ↓</th><th>Algorithm / source</th><th>Method</th><th>Task support / constraints</th><th>Highlights</th><th>Publication</th><th>BibTeX</th></tr>
</thead>
<tbody>
<tr>
<td>2023</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Constraint%20Handling/CMOCSO/CMOCSO.m"><code>CMOCSO</code></a> (TEVC)</td>
<td>Swarm intelligence / constraint handling</td>
<td>Single-task · constrained</td>
<td>Competitive and cooperative multiobjective swarm search.</td>
<td><a href="https://doi.org/10.1109/TEVC.2022.3199775" title="A Competitive and Cooperative Swarm Optimizer for Constrained Multi-objective Optimization Problems">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Ming2023CMOCSO,
  title      = {A Competitive and Cooperative Swarm Optimizer for Constrained Multi-objective Optimization Problems},
  author     = {Ming, Fei and Gong, Wenyin and Li, Dongcheng and Wang, Ling and Gao, Liang},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2023},
  volume     = {27},
  number     = {5},
  pages      = {1313-1326},
  doi        = {10.1109/TEVC.2022.3199775},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Constraint%20Handling/CCMO/CCMO.m"><code>CCMO</code></a> (TEVC)</td>
<td>Constraint handling</td>
<td>Single-task · constrained</td>
<td>Coevolution for constrained multiobjective search.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Tian2021CCMO,
  title      = {A Coevolutionary Framework for Constrained Multiobjective Optimization Problems},
  author     = {Tian, Ye and Zhang, Tao and Xiao, Jianhua and Zhang, Xingyi and Jin, Yaochu},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2021},
  volume     = {25},
  number     = {1},
  pages      = {102-116},
}
```

</details>
</td>
</tr>
<tr>
<td>2021</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Non-dominated%20Sort/MSEA/MSEA.m"><code>MSEA</code></a> (TSMC-S)</td>
<td>Nondominated sorting</td>
<td>Single-task · unconstrained</td>
<td>Multistage search for diversity preservation.</td>
<td><a href="https://doi.org/10.1109/TSMC.2019.2956288" title="A Multistage Evolutionary Algorithm for Better Diversity Preservation in Multiobjective Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Tian2021MSEA,
  title      = {A Multistage Evolutionary Algorithm for Better Diversity Preservation in Multiobjective Optimization},
  author     = {Tian, Ye and He, Cheng and Cheng, Ran and Zhang, Xingyi},
  journal    = {IEEE Transactions on Systems, Man, and Cybernetics: Systems},
  year       = {2021},
  volume     = {51},
  number     = {9},
  pages      = {5880-5894},
  doi        = {10.1109/TSMC.2019.2956288},
}
```

</details>
</td>
</tr>
<tr>
<td>2020</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Non-dominated%20Sort/LMOCSO/LMOCSO.m"><code>LMOCSO</code></a> (TCYB)</td>
<td>Swarm intelligence</td>
<td>Single-task · unconstrained / constrained</td>
<td>Large-scale multiobjective competitive swarm search.</td>
<td><a href="https://doi.org/10.1109/TCYB.2019.2906383" title="Efficient Large-Scale Multiobjective Optimization Based on a Competitive Swarm Optimizer">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Tian2020LMOCSO,
  title      = {Efficient Large-Scale Multiobjective Optimization Based on a Competitive Swarm Optimizer},
  author     = {Tian, Ye and Zheng, Xiutao and Zhang, Xingyi and Jin, Yaochu},
  journal    = {IEEE Transactions on Cybernetics},
  year       = {2020},
  volume     = {50},
  number     = {8},
  pages      = {3696--3708},
  doi        = {10.1109/TCYB.2019.2906383},
}
```

</details>
</td>
</tr>
<tr>
<td>2018</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Decomposition/AR-MOEA/AR_MOEA.m"><code>AR_MOEA</code></a> (TEVC)</td>
<td>Indicator-based selection</td>
<td>Single-task · unconstrained / constrained</td>
<td>Adaptive reference points for multiobjective search.</td>
<td><a href="https://doi.org/10.1109/TEVC.2017.2749619" title="An Indicator-Based Multiobjective Evolutionary Algorithm With Reference Point Adaptation for Better Versatility">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Tian2018AR-MOEA,
  title      = {An Indicator-Based Multiobjective Evolutionary Algorithm With Reference Point Adaptation for Better Versatility},
  author     = {Tian, Ye and Cheng, Ran and Zhang, Xingyi and Cheng, Fan and Jin, Yaochu},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2018},
  volume     = {22},
  number     = {4},
  pages      = {609-622},
  doi        = {10.1109/TEVC.2017.2749619},
}
```

</details>
</td>
</tr>
<tr>
<td>2016</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Decomposition/RVEA/RVEA.m"><code>RVEA</code></a> (TEVC)</td>
<td>Reference-vector-guided evolution</td>
<td>Single-task · unconstrained / constrained</td>
<td>Reference-vector-guided evolution.</td>
<td><a href="https://doi.org/10.1109/TEVC.2016.2519378" title="A Reference Vector Guided Evolutionary Algorithm for Many-Objective Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Cheng2016RVEA,
  title      = {A Reference Vector Guided Evolutionary Algorithm for Many-Objective Optimization},
  author     = {Cheng, Ran and Jin, Yaochu and Olhofer, Markus and Sendhoff, Bernhard},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2016},
  volume     = {20},
  number     = {5},
  pages      = {773-791},
  doi        = {10.1109/TEVC.2016.2519378},
}
```

</details>
</td>
</tr>
<tr>
<td>2014</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Non-dominated%20Sort/NSGA-III/NSGA_III.m"><code>NSGA_III</code></a> (TEVC)</td>
<td>Nondominated sorting</td>
<td>Single-task · unconstrained / constrained</td>
<td>Reference-point-guided nondominated sorting.</td>
<td><a href="https://doi.org/10.1109/TEVC.2013.2281535" title="An Evolutionary Many-Objective Optimization Algorithm Using Reference-Point-Based Nondominated Sorting Approach, Part I: Solving Problems With Box Constraints">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Deb2014NSGA3,
  title      = {An Evolutionary Many-Objective Optimization Algorithm Using Reference-Point-Based Nondominated Sorting Approach, Part I: Solving Problems With Box Constraints},
  author     = {Deb, Kalyanmoy and Jain, Himanshu},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2014},
  volume     = {18},
  number     = {4},
  pages      = {577-601},
  doi        = {10.1109/TEVC.2013.2281535},
}
```

</details>
</td>
</tr>
<tr>
<td>2009</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Decomposition/MOEA-D-DE/MOEA_D_DE.m"><code>MOEA_D_DE</code></a> (TEVC)</td>
<td>Decomposition</td>
<td>Single-task · unconstrained / constrained</td>
<td>MOEA/D with differential evolution.</td>
<td><a href="https://doi.org/10.1109/TEVC.2008.925798" title="Multiobjective Optimization Problems With Complicated Pareto Sets, MOEA/D and NSGA-II">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Li2009MOEA-D-DE&NSGA-II-DE,
  title      = {Multiobjective Optimization Problems With Complicated Pareto Sets, MOEA/D and NSGA-II},
  author     = {Li, Hui and Zhang, Qingfu},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2009},
  volume     = {13},
  number     = {2},
  pages      = {284-302},
  doi        = {10.1109/TEVC.2008.925798},
}
```

</details>
</td>
</tr>
<tr>
<td>2007</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Non-dominated%20Sort/MO-CMA-ES/MO_CMA_ES.m"><code>MO_CMA_ES</code></a> (EC)</td>
<td>Evolution strategy</td>
<td>Single-task · unconstrained</td>
<td>Multiobjective covariance-matrix adaptation.</td>
<td><a href="https://doi.org/10.1162/evco.2007.15.1.1" title="Covariance Matrix Adaptation for Multi-objective Optimization">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Igel2007MO-CMA-ES,
  title      = {Covariance Matrix Adaptation for Multi-objective Optimization},
  author     = {Igel, Christian and Hansen, Nikolaus and Roth, Stefan},
  journal    = {Evolutionary Computation},
  year       = {2007},
  volume     = {15},
  number     = {1},
  pages      = {1-28},
  doi        = {10.1162/evco.2007.15.1.1},
}
```

</details>
</td>
</tr>
<tr>
<td>2007</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Decomposition/MOEA-D/MOEA_D.m"><code>MOEA_D</code></a> (TEVC)</td>
<td>Decomposition</td>
<td>Single-task · unconstrained / constrained</td>
<td>Decomposition-based multiobjective evolution.</td>
<td><a href="https://doi.org/10.1109/TEVC.2007.892759" title="MOEA/D: A Multiobjective Evolutionary Algorithm Based on Decomposition">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Zhang2007MOEAD,
  title      = {MOEA/D: A Multiobjective Evolutionary Algorithm Based on Decomposition},
  author     = {Zhang, Qingfu and Li, Hui},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2007},
  volume     = {11},
  number     = {6},
  pages      = {712-731},
  doi        = {10.1109/TEVC.2007.892759},
}
```

</details>
</td>
</tr>
<tr>
<td>2007</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Metric%20Selection/SMS-EMOA/SMS_EMOA.m"><code>SMS_EMOA</code></a> (EJOR)</td>
<td>Indicator-based selection</td>
<td>Single-task · unconstrained</td>
<td>Hypervolume-based environmental selection.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Beume2007SMS-EMOA,
  title      = {SMS-EMOA: Multiobjective Selection Based on Dominated Hypervolume},
  author     = {Nicola Beume and Boris Naujoks and Michael Emmerich},
  journal    = {European Journal of Operational Research},
  year       = {2007},
  volume     = {181},
  number     = {3},
  pages      = {1653-1669},
  issn       = {0377-2217},
}
```

</details>
</td>
</tr>
<tr>
<td>2002</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Non-dominated%20Sort/NSGA-II/NSGA_II.m"><code>NSGA_II</code></a> (TEVC)</td>
<td>Nondominated sorting</td>
<td>Single-task · unconstrained / constrained</td>
<td>Nondominated sorting and crowding distance.</td>
<td><a href="https://doi.org/10.1109/4235.996017" title="A Fast and Elitist Multiobjective Genetic Algorithm: Nsga-ii">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Deb2002NSGA2,
  title      = {A Fast and Elitist Multiobjective Genetic Algorithm: Nsga-ii},
  author     = {Deb, K. and Pratap, A. and Agarwal, S. and Meyarivan, T.},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2002},
  volume     = {6},
  number     = {2},
  pages      = {182-197},
  doi        = {10.1109/4235.996017},
}
```

</details>
</td>
</tr>
<tr>
<td>2002</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Non-dominated%20Sort/NSGA-II/NSGA_II_DE.m"><code>NSGA_II_DE</code></a> (TEVC)</td>
<td>Nondominated sorting</td>
<td>Single-task · unconstrained / constrained</td>
<td>Nondominated sorting and crowding distance.</td>
<td><a href="https://doi.org/10.1109/4235.996017" title="A Fast and Elitist Multiobjective Genetic Algorithm: Nsga-ii">Link</a></td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@article{Deb2002NSGA2,
  title      = {A Fast and Elitist Multiobjective Genetic Algorithm: Nsga-ii},
  author     = {Deb, K. and Pratap, A. and Agarwal, S. and Meyarivan, T.},
  journal    = {IEEE Transactions on Evolutionary Computation},
  year       = {2002},
  volume     = {6},
  number     = {2},
  pages      = {182-197},
  doi        = {10.1109/4235.996017},
}
```

</details>
</td>
</tr>
<tr>
<td>2001</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Non-dominated%20Sort/SPEA2/SPEA2.m"><code>SPEA2</code></a> (EUROGEN)</td>
<td>Nondominated sorting</td>
<td>Single-task · unconstrained / constrained</td>
<td>Strength Pareto environmental selection.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Zitzler2001SPEA2,
  title      = {SPEA2: Improving the Strength Pareto Evolutionary Algorithm For Multiobjective Optimization},
  author     = {Zitzler, E. and Laumanns, M. and Thiele, L.},
  booktitle  = {Evolutionary Methods for Design, Optimization and Control with Applications to Industrial Problems. Proceedings of the EUROGEN'2001. Athens. Greece, September 19-21},
  year       = {2001},
}
```

</details>
</td>
</tr>
<tr>
<td>2001</td>
<td><a href="../MTO/Algorithms/Multi-objective%20Single-task/Non-dominated%20Sort/SPEA2/SPEA2_DE.m"><code>SPEA2_DE</code></a> (EUROGEN)</td>
<td>Nondominated sorting</td>
<td>Single-task · unconstrained / constrained</td>
<td>Strength Pareto environmental selection.</td>
<td>—</td>
<td>
<details>
<summary>BibTeX</summary>

```bibtex
@inproceedings{Zitzler2001SPEA2,
  title      = {SPEA2: Improving the Strength Pareto Evolutionary Algorithm For Multiobjective Optimization},
  author     = {Zitzler, E. and Laumanns, M. and Thiele, L.},
  booktitle  = {Evolutionary Methods for Design, Optimization and Control with Applications to Industrial Problems. Proceedings of the EUROGEN'2001. Athens. Greece, September 19-21},
  year       = {2001},
}
```

</details>
</td>
</tr>
</tbody>
</table>

[↑ Contents](#contents)
