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
Using Ruby version: 3.2.5-p208


Member tests:


  Ultra Simple: Member                   Warmups       Iterations    Iterations    Total Iterations   Comparison
                                         (i/100ms)     (i/s)         (std dev %)

  Rabl 0.17.0                                 7.419k       73.857k   ± 2.3%           741.900k        3.79x slower
  Jbuilder 2.13.0                             7.484k       74.472k   ± 2.3%           748.400k        3.76x slower
  Representable 3.2.0                        11.941k      118.882k   ± 1.6%             1.194M        2.36x slower
  AMS 0.10.15                                15.668k      156.607k   ± 1.4%             1.567M        1.79x slower
  FastJsonapi 1.5                            18.463k      186.237k   ± 0.6%             1.865M        1.50x slower
  Transmutation 0.5.1                        28.332k      280.215k   ± 0.9%             2.805M


Memory Usage:


  Ultra Simple: Member                   Memory Usage   Comparison

  Transmutation 0.5.1                         1.216k
  FastJsonapi 1.5                             1.896k    1.56x more
  AMS 0.10.15                                 2.080k    1.71x more
  Jbuilder 2.13.0                             2.600k    2.14x more
  Representable 3.2.0                         4.104k    3.38x more
  Rabl 0.17.0                                 5.864k    4.82x more


Total wall clock time: 1m12.266s
```
