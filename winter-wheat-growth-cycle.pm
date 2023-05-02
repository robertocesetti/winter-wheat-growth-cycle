/* Seeds */
species S;

/* Rotten seeds */
species RS;

/* Roots */
species R;

/* The percentage of nutrients in the soil (a value between 0 and 1) */
param soil_nutrients = 0.5;

/* The Seed produces Roots depending on soil nutrients */
rule seed_produces_root {
	S -[(soil_nutrients)]-> R
}

/* A seed is considered rotten if it does not have enough nutrients to produce roots */
rule seed_rots {
	S -[(1-(soil_nutrients))]-> RS
}

measure roots = #R;
measure seeds = #S;
measure rotten_seed = #RS;

system init = S<100>;