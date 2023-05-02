/* Seeds */
species S;

/* Rotten seeds */
species RS;

const root_energy = 4;

/* Roots */
species R of [0, root_energy];

/* Tillers */
species T;

/* The percentage of nutrients in the soil (a value between 0 and 1) */
param soil_nutrients = 0.5;

/* Average daily temperature (°C) during the growth cycle period */
param temperature = 15;

/* Average daily water (mm) received by the plantation during its growth period */
param daily_water = 4;

const daily_water_rate = 1/(1+(((daily_water-5)/0.5)^4));

const temperature_rate = 1/(1+(((temperature-15)/5)^6));

/* The Seed produces Roots depending on soil nutrients */
rule seed_produces_root {
	S -[(soil_nutrients)]-> R[root_energy-1]
}

/* A seed is considered rotten if it does not have enough nutrients to produce roots */
rule seed_rots {
	S -[(1-(soil_nutrients))]-> RS
}

/* Roots produce Tillers depending on environmental conditions */
rule roots_produce_tiller for i in [1, root_energy] {
	R[i] -[temperature_rate * daily_water_rate]-> T | R[i-1]
}

measure seeds = #S;
measure rotten_seed = #RS;
measure roots = #R[i for i in [0, root_energy]];
measure tillers = #T;

system init = S<100>;