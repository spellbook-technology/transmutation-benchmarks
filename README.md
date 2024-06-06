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

  Jbuilder 2.12.0                             5.565k       59.920k   ± 1.1%           601.020k        3.89x slower
  Rabl 0.16.1                                 6.714k       67.264k   ± 2.4%           678.114k        3.47x slower
  Representable 3.2.0                        11.305k      112.898k   ± 1.9%             1.130M        2.06x slower
  AMS 0.10.14                                11.615k      116.661k   ± 1.0%             1.173M        2.00x slower
  FastJsonapi 1.5                            12.368k      133.234k   ± 1.5%             1.336M        1.75x slower
  Transmutation 0.3.0                        23.365k      233.096k   ± 0.5%             2.336M


Memory Usage:


  Ultra Simple: Member                   Memory Usage   Comparison

  Transmutation 0.3.0                         1.836k
  FastJsonapi 1.5                             2.440k    1.33x more
  AMS 0.10.14                                 3.284k    1.79x more
  Jbuilder 2.12.0                             3.514k    1.91x more
  Representable 3.2.0                         4.156k    2.26x more
  Rabl 0.16.1                                 5.549k    3.02x more


Total wall clock time: 1m12.329s
```
