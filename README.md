# MimiSAI
MimiSAI is a Mimi-based emulator that generates the delta temperatures needed to perturb SSPs under Stratospheric Aerosol Injection. 
This model - a subset of my ongoing project - is designed to be coupled with the Finite Amplitude Impulse Response Simple Climate Model (**FAIR**) to produce reasonable temperatures, that can then be fed into Integrated Assessment Models.
MimiSAI conforms to key constraints in most SAI simulations. These include maintaining global average temperatures, equator to pole, and pole to pole temperatures gradients constant for a given period.
As such, it may not be suitable for Arctic and other regional SAI scenarios. It is yet incoporate regional scenarios. 

The model is tuned using data from the "Assessing Responses and Impacts of Solar intervention on the Earth system with Stratospheric Aerosol Injection (ARISE-SAI)". 
The injection data in the base model corresponds to ARISE-SAI-1.5, but users can specify their injection files via the data directory (/data) to generate corresponding perturbations. 
**Note** 2035 is currently the default first injection year. However, you can modify this to suit your experiment. 
MimiSAI is still under development, and further modifications and improvements should be expected in the near future.

# Emulator Chain 
**Injection → Associated SO<sub>2</sub>response → Associated SO<sub>4</sub> response  → Associated AOD response (ERF response)  →  Temperature perturbation**

I model SO2 response post-injection as:
\
At time $t_1$: $I_1$  
At time $t_2$: $I_2 + \epsilon I_1$  
At time $t_3$: $I_3 + \epsilon I_2 + \varepsilon^2 I_1$  
At time $t_4$: $I_4 + \epsilon I_3 + \epsilon^2 I_2 + \epsilon^3 I_1$  
.  
.  
At time $t_n$:  
$I_n = \epsilon I_{n-1} + \epsilon^2 I_{n-2} + \epsilon^3 I_{n-3} + \cdots + \epsilon^{n-1} I_1$ \
Thus, at any timestamp (n), $S_n = \sum_{k=0}^{n-1} \epsilon^{k} I_{n-k}$. Where I is injection amount, and \varepsilon is a serial correlation coefficient denoting how past injections affect the current state. 

