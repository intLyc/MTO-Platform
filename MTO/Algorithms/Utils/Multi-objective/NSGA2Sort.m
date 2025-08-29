function [rank, FrontNo, CrowdDis] = NSGA2Sort(population)
CVs = sum(max(0, population.Cons), 2);
FrontNo = NDSort(population.Objs, CVs, inf);
CrowdDis = CrowdingDistance(population.Objs, FrontNo);
[~, rank] = sortrows([FrontNo', -CrowdDis']);
end
