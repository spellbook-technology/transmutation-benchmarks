# Benchmarking popular Ruby JSON Serializers with Transmutation

Transmutation provides a very simple and elegant DSL that outperforms the majority of other serializers on the market. It also boasts consistent performance with small standard deviation.

## Results

### Attributes

| Gem                                                                                       | IPS                | Comparison   | Allocations | Comparison |
|------------------------------------------------------------------------------------------ | -----------------: | -----------: | ----------: | ---------: |
| [panko_serializer 0.8.3](https://github.com/yosiat/panko_serializer)                      |    434.661k ±10.6% |     baseline |    856.000  |   baseline |
| [transmutation 0.5.1](https://github.com/spellbook-technology/transmutation)              |    434.563k ± 0.7% | 1.00x slower |      1.256k | 1.47x more |
| [active_model_serializers 0.10.15](https://github.com/rails-api/active_model_serializers) |    232.612k ± 3.5% | 1.87x slower |      2.080k | 2.43x more |
| [jsonapi-serializer 2.2.0](https://github.com/jsonapi-serializer/jsonapi-serializer)      |    217.774k ± 1.6% | 2.00x slower |      3.160k | 3.69x more |
| [representable 3.2.0](https://github.com/trailblazer/representable)                       |    168.576k ± 3.7% | 2.58x slower |      4.144k | 4.84x more |
| [rabl 0.17.0](https://github.com/nesquena/rabl)                                           |    121.153k ± 4.5% | 3.59x slower |      5.696k | 6.65x more |
| [jbuilder 2.13.0](https://github.com/rails/jbuilder)                                      |     88.500k ± 6.0% | 4.91x slower |      2.600k | 3.04x more |

\* _Run with the following Ruby version:_ `ruby 3.2.5 (2024-07-26 revision 31d0f1a2e7) +YJIT [arm64-darwin24]`

Output for all serialization is:

```json
{"id":1,"first_name":"John","full_name":"John Doe"}
```

With the exception of JSONAPI Serializer, as it follows the JSONAPI spec:

```json
{"data":{"id":"1","type":"user","attributes":{"id":1,"first_name":"John","full_name":"John Doe"}}}
```

### Has one / Belongs to association

Coming soon.

### Has many association

Coming soon.

## Usage

- Run the benchmarks

    ```sh
    bundle exec ruby benchmark.rb
    ```

- With YJIT enabled

    ```sh
    bundle exec ruby --yjit benchmark.rb
    ```
