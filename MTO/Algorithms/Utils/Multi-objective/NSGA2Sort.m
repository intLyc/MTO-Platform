function [rank, FrontNo, CrowdDis] = NSGA2Sort(population)
FrontNo = NDSort(population.Objs, population.CVs, inf);
CrowdDis = CrowdingDistance(population.Objs, FrontNo);
[~, rank] = sortrows([FrontNo', -CrowdDis']);
end
