# Benchmarking popular Ruby JSON Serializers with Transmutation

The serializers measured include:

- [RABL](https://github.com/nesquena/rabl/)
- [ActiveModel Serializers](https://github.com/rails-api/active_model_serializers)
- [Representable](https://github.com/trailblazer/representable)
- [FastJsonapi](https://github.com/Netflix/fast_jsonapi)
- [Jbuilder](https://github.com/rails/jbuilder)

## Usage

- Run the benchmarks

        bundle exec ruby benchmark.rb

## Results

(This is the condensed version, run the benchmarks to see the full results.)

```
Using Ruby version: 3.0.6-p216


Member tests:


  Ultra Simple: Member                   Warmups       Iterations    Iterations    Total Iterations   Comparison
                                         (i/100ms)     (i/s)         (std dev %)

  Jbuilder 2.12.0                             2.778k       44.201k   ± 9.6%           436.146k        4.11x slower
  Rabl 0.16.1                                 4.974k       48.854k   ±11.3%           482.478k        3.72x slower
  Representable 3.2.0                         5.280k       82.981k   ± 7.9%           823.680k        2.19x slower
  AMS 0.10.14                                 5.103k       83.705k   ± 8.6%           826.686k        2.17x slower
  FastJsonapi 1.5                             9.807k       96.873k   ±11.7%           961.086k        1.88x slower
  Transmutation 0.1.0                         9.852k      181.741k   ± 4.3%             1.823M


Memory Usage:


  Ultra Simple: Member                   Memory Usage   Comparison

  Transmutation 0.1.0                         1.756k
  FastJsonapi 1.5                             2.440k    1.39x more
  AMS 0.10.14                                 3.284k    1.87x more
  Jbuilder 2.12.0                             3.514k    2.00x more
  Representable 3.2.0                         4.156k    2.37x more
  Rabl 0.16.1                                 5.549k    3.16x more


Total wall clock time: 1m12.837s
```
