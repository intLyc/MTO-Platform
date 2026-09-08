function arrival = KR_AMTEA_Arrivals(tasks, maxFE, seed)
% Sample integer FE arrivals using Eq. (21), then shift the earliest arrival to zero.
% A private random stream reproduces arrivals without consuming the platform RNG.
stream = RandStream('mt19937ar', 'Seed', seed);
arrival = randi(stream, maxFE, 1, tasks);
arrival = arrival - min(arrival);
end
