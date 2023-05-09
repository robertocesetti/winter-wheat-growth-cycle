/*-------------------- Winter Wheat Growth Cycle --------------------*/

/* _-_-_-_-_-_-_-_-_-_-_ Params _-_-_-_-_-_-_-_-_-_-_ */


/* The percentage of nutrients in the soil (a value between 0 and 1) */
param soil_nutrients = 1;

/* Average daily water (mm) received by the plantation during its growth period (best conditions: 4-6mm) */
param daily_water = 5;

/* Average daily temperature (°C) during the growth cycle period (best conditions: 10-20°C) */
param temperature = 15;

/* Represents the amount of fertilizer applied per plant (best conditions: 2g) */
param fertilizer = 2;


/* _-_-_-_-_-_-_-_-_-_-_ Consts _-_-_-_-_-_-_-_-_-_-_ */


const max_tillers = 6;

const max_flowers = 2;

const max_kernels = 23;

const productive_tillers_rate = 0.5;

const daily_water_rate = 1/(1+(((daily_water-5))^4));

const temperature_rate = 1/(1+(((temperature-20)/5)^2));

const environmental_conditions = daily_water_rate * temperature_rate;

const fertilization_rate = 1/(1+(fertilizer-(2/soil_nutrients))^4);


/* _-_-_-_-_-_-_-_-_-_-_ Species _-_-_-_-_-_-_-_-_-_-_ */


/* Seeds */
species S;

/* Rotten seeds */
species RS;

/* Plants */
species P of [0, max_tillers];

/* Tillers */
species T of [0, max_flowers];

/* Florets */
species F of [0, max_kernels];

/* Kernels */
species K;


/* _-_-_-_-_-_-_-_-_-_-_ Rules _-_-_-_-_-_-_-_-_-_-_ */


/* The Seed produces Plant depending on soil nutrients */
rule seed_produces_plant {
	S -[(soil_nutrients)]-> P[max_tillers-1]
}

/* A seed is considered rotten if it does not have enough nutrients to produce Plants */
rule seed_rots {
	S -[(1-(soil_nutrients))]-> RS
}

/* Plants produce Tillers depending on environmental conditions */
rule plants_produce_tillers for i in [1, max_tillers] {
	P[i] -[environmental_conditions]-> T[max_flowers-1] | P[i-1]
}

/* Tillers produce Flowers */
rule tillers_produce_flowers for i in [1, max_flowers] {
	T[i] -[soil_nutrients * environmental_conditions * productive_tillers_rate]-> F[max_kernels-1] | T[i-1]
}

/* Flowers produce Kernels */
rule flowers_produce_kernels for i in [1, max_kernels] {
	F[i] -[fertilization_rate * environmental_conditions]-> K | F[i-1]
}


/* _-_-_-_-_-_-_-_-_-_-_ Measures _-_-_-_-_-_-_-_-_-_-_ */


measure seeds = #S;
measure rotten_seeds = #RS;
measure plants = #P[i for i in [0, max_tillers]];
measure tillers = #T[i for i in [0, max_flowers]];
measure flowers = #F[i for i in [0, max_kernels]];
measure kernels = #K;


/* _-_-_-_-_-_-_-_-_-_-_ Initial State _-_-_-_-_-_-_-_-_-_-_ */


system init = S<100>;