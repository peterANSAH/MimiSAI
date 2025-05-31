<div style="font-size: 16px; text-align: justify;">

# MimiSAI

MimiSAI is a Mimi-based emulator that generates the delta temperatures needed to perturb SSPs under 
Stratospheric Aerosol Injection. This model - a subset of my ongoing project - is designed to be coupled
with the Finite Amplitude Impulse Response Climate Model  (**FAIR**) to produce reasonable temperatures, that can then be fed into Integrated Assessment Models.
MimiSAI conforms to key constraints in most SAI simulations. These include maintaining global average temperatures, equator to pole, and 
pole to pole temperature gradients constant for a given period. As such, it may not be suitable for Arctic and other regional SAI scenarios. I am yet to incorporate responses from regional scenarios. 

The model is tuned using data from the "Assessing Responses and Impacts of Solar intervention on the Earth system with Stratospheric Aerosol Injection (ARISE-SAI)" <sup>[1]</sup>. 
The injection data in the base model corresponds to ARISE-SAI <sup>[1]</sup>, but users can specify their injection files via the data directory (/data) to generate corresponding perturbations. 
**Note** 2035 is currently the default first injection year. However, you can modify this to suit your experiment. 
MimiSAI is still under development, and further modifications and improvements should be expected in the near future.


## Emulator Chain

**Injection → Associated SO<sub>2</sub> response → Associated SO<sub>4</sub> response → Associated AOD response (ERF response) → Temperature perturbation**

I model the associated SO₂ response (above the background SSP) post-injection as:

At time $t_1: I_1$  
At time $t_2: I_2 + \epsilon I_1$  
At time $t_3: I_3 + \epsilon I_2 + \epsilon^2 I_1$  
At time $t_4: I_4 + \epsilon I_3 + \epsilon^2 I_2 + \epsilon^3 I_1$  
⋮  
At time $t_n$:  
$I_n = \epsilon I_{n-1} + \epsilon^2 I_{n-2} + \epsilon^3 I_{n-3} + \cdots + \epsilon^{n-1} I_1$

Thus, at any timestamp ($n$):

$$
S_n = \sum_{k=0}^{n-1} \epsilon^{k} I_{n-k}
$$

Where $I$ is the injection amount and $\epsilon$ is a **serial correlation coefficient**, denoting the impact of past injections.

Temperature perturbation due to the AOD response is simulated using the semi-finite diffusion approach deployed in most simple climate emulators, and also adopted in <sup>[2]</sup>. <sup>[2]</sup> simulated the impulse response (h_(SAI) as:

$$
h_{SAI}(t) = \mu (\sqrt{\frac{1}{\pi t \tau}} - e^{\frac{t}{\tau}}{erfc}\left( \sqrt{\frac{t}{\tau}} \right))
$$

And the temperature perturbation from the convolution:
$$
T(t) = \sum_{j=1}^{t} \left[ h_{SAI}(j) g(t - j) \right]
$$

Where $\tau$ is a timescale, $t$ is time in years, $g$ is AOD above the background (SSP), $\mu$ is a scale factor in °C/AOD, and $T$ is temperature above the background (SSP). Unlike<sup>[2]</sup>, who used monthly resolved data, $\tau$ and $\mu$ were derived using yearly data for the optimization.

## INSTALLATION
The minimum requirement to run MimiSAI is Julia and Mimi. To install the latest version of Julia, refer to [Julia](http://julialang.org/downloads/). In Julia, install Mimi with: 

```julia
using Pkg

Pkg.add("Mimi")    
```


Then install MimiSAI:


```julia
Pkg.activate("/somepath") #First activate a path to avoid package conflicts - this is considered good practice).

Pkg.add(url="https://github.com/peterANSAH/MimiSAI")  
```

# USAGE

```julia
using MimiSAI
                
m = MimiSAI.get_model()
                
run(m)
```

To explore outputs via the Mimi interface:
```julia
using Mimi

explore(m)
```
To save a given component variable:

```julia
getdataframe(model, :component name, :variable) |> save("/path") 
```
Example:
```julia
getdataframe(model, :tempresponse, :T_sai) |> save("/path")    
```

# REFERENCES
[1] Richter, J., Visioni, D., MacMartin, D., Bailey, D., Rosenbloom, N., Lee, W., ... & Lamarque, J. F. (2022). Assessing Responses and Impacts of Solar climate intervention on the Earth system with stratospheric aerosol injection (ARISE-SAI). EGUsphere, 2022, 1-35.

[2] Farley, J., MacMartin, D. G., Visioni, D., & Kravitz, B. (2024). Emulating inconsistencies in stratospheric aerosol injection. Environmental Research: Climate, 3(3), 035012.

# ACKNOWLEGDEMENT
[1] The functions for reading input data in `helper.jl` are adapted from [MimiFUND](https://github.com/fund-model/MimiFUND.jl/blob/master/src/helper.jl) (Copyright © 1994–2019 David Anthoff and Richard S.J. Tol).

[2] Warm regards to Dr. Daniele Visioni for granting access to the ARISE injection data, sharing other useful resources, and providing helpful feedback.
</div>


