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

  Jbuilder 2.12.0                             5.911k       60.089k   ± 3.1%           602.922k        3.99x slower
  Rabl 0.16.1                                 6.622k       67.408k   ± 3.4%           675.444k        3.56x slower
  Representable 3.2.0                        11.261k      112.929k   ± 1.0%             1.137M        2.13x slower
  AMS 0.10.14                                11.591k      116.718k   ± 1.3%             1.171M        2.06x slower
  FastJsonapi 1.5                            13.295k      132.862k   ± 1.2%             1.330M        1.81x slower
  Transmutation 0.2.0                        24.231k      240.027k   ± 2.3%             2.399M


Memory Usage:


  Ultra Simple: Member                   Memory Usage   Comparison

  Transmutation 0.2.0                         1.836k
  FastJsonapi 1.5                             2.440k    1.33x more
  AMS 0.10.14                                 3.284k    1.79x more
  Jbuilder 2.12.0                             3.514k    1.91x more
  Representable 3.2.0                         4.156k    2.26x more
  Rabl 0.16.1                                 5.549k    3.02x more


Total wall clock time: 1m12.329s
```
