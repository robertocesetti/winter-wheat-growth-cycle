/* The maximum amount of seed's nutrients */
param seed_nutrients = 4;

/* The maximum amount of root's energy */
param root_energy = 5;

/* Seeds have specific characteristics that, in this model, are expressed by a value between 0 and 4. This is a way to represent 4 different types of seeds */
species S of [0, seed_nutrients];

/* Rotten seeds */
species RS;

/* Roots produced from seeds, their amount of energy is equal to root_energy */
species R of [0, root_energy];

/* The probability that a seed rots is 1/70 = 0.014 */
const lambda_rot = 0.014;
const lambda_sib = 1.25;

/* The Seed produces Roots depending on seed_nutrients */
rule seed_produces_root for i in [0, seed_nutrients] {
	S[i] -[(lambda_sib^(i-(seed_nutrients-1)))]-> R[root_energy-1]
}

/* A seed is considered rotten if after a maximum of 70 days from sowing it has not produced roots */
rule seed_rots for i in [0, seed_nutrients] {
	S[i] -[((1-lambda_rot)^i)*lambda_sib]-> RS
}

measure roots = #R[i for i in [0, root_energy]];
measure seed = #S[i for i in [0, seed_nutrients]];
measure rotten_seed = #RS;

system init = S[0]<100> | S[1]<50> | S[2]<30> | S[3]<20>;