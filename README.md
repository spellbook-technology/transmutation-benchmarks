# Benchmarking popular Ruby JSON Serializers with Transmutation

Transmutation provides a very simple and elegant DSL that outperforms the majority of other serializers on the market. It also boasts consistent performance with small standard deviation.

\* _Benchmarks were ran on a MacBook Pro M1 Pro with the following Ruby version:_ `ruby 3.2.5 (2024-07-26 revision 31d0f1a2e7) +YJIT [arm64-darwin24]`

The following objects are used for serialization:

```ruby
organisation = Organisation.new(id: 1, name: "Example Inc.") # Serialize with no associations
user = User.new(id: 1, first_name: "John", last_name: "Doe", organisation_id: 1) # Serialize with many Posts
post = Post.new(id: 1, title: "Sample Post", body: "Sample Body", user_id: 1) # Serialize with one User
```

## Results

### Attributes

| Gem                                                                                       | IPS                | Comparison   | Allocations | Comparison |
|-------------------------------------------------------------------------------------------|-------------------:|-------------:|------------:|-----------:|
| [panko_serializer 0.8.3](https://github.com/yosiat/panko_serializer)                      |    438.094k ± 7.2% |     baseline |      1.016k |   baseline |
| [transmutation 0.5.1](https://github.com/spellbook-technology/transmutation)              |    414.671k ± 0.5% | 1.06x slower |      1.416k | 1.39x more |
| [active_model_serializers 0.10.15](https://github.com/rails-api/active_model_serializers) |    235.324k ± 1.0% | 1.86x slower |      2.368k | 2.33x more |
| [jsonapi-serializer 2.2.0](https://github.com/jsonapi-serializer/jsonapi-serializer)      |    214.195k ± 0.7% | 2.05x slower |      3.400k | 3.35x more |
| [representable 3.2.0](https://github.com/trailblazer/representable/)                      |    172.203k ± 0.5% | 2.54x slower |      4.304k | 4.24x more |
| [rabl 0.17.0](https://github.com/nesquena/rabl)                                           |    123.649k ± 1.9% | 3.54x slower |      5.856k | 5.76x more |
| [jbuilder 2.13.0](https://github.com/rails/jbuilder/tree/v2.13.0)                         |    102.347k ± 1.8% | 4.28x slower |      2.960k | 2.91x more |

Output for all serialization is:

```json
{"id":1,"name":"Example Inc.","logo_url":"https://example.com/logos/companies/1"}
```

With the exception of JSONAPI Serializer, as it follows the JSONAPI spec:

```json
{"data":{"id":"1","type":"organisation","attributes":{"id":1,"name":"Example Inc.","logo_url":"https://example.com/logos/companies/1"}}}
```

### Has one / Belongs to association

| Gem                                                                                       | IPS                | Comparison   | Allocations | Comparison |
|-------------------------------------------------------------------------------------------|-------------------:|-------------:|------------:|-----------:|
| [transmutation 0.5.1](https://github.com/spellbook-technology/transmutation)              |    173.083k ± 0.6% |     baseline |      2.832k |   baseline |
| [panko_serializer 0.8.3](https://github.com/yosiat/panko_serializer)                      |    143.980k ± 3.0% | 1.20x slower |      4.128k | 1.46x more |
| [representable 3.2.0](https://github.com/trailblazer/representable/)                      |     88.476k ± 0.9% | 1.96x slower |      6.184k | 2.18x more |
| [active_model_serializers 0.10.15](https://github.com/rails-api/active_model_serializers) |     68.124k ± 0.7% | 2.54x slower |      6.384k | 2.25x more |
| [rabl 0.17.0](https://github.com/nesquena/rabl)                                           |     65.739k ± 1.2% | 2.63x slower |      9.608k | 3.39x more |
| [jsonapi-serializer 2.2.0](https://github.com/jsonapi-serializer/jsonapi-serializer)      |     54.261k ± 0.7% | 3.19x slower |     12.368k | 4.37x more |
| [jbuilder 2.13.0](https://github.com/rails/jbuilder/tree/v2.13.0)                         |     45.384k ± 0.8% | 3.81x slower |      4.944k | 1.75x more |

Output for all serialization is:

```json
{"id":1,"title":"Sample Post","body":"Sample Body","user":{"id":1,"first_name":"John","full_name":"John Doe"}}
```

With the exception of JSONAPI Serializer, as it follows the JSONAPI spec:

```json
{"data":{"id":"1","type":"post","attributes":{"id":1,"title":"Sample Post","body":"Sample Body"},"relationships":{"user":{"data":{"id":"1","type":"user"}}}},"included":[{"id":"1","type":"user","attributes":{"id":1,"first_name":"John","full_name":"John Doe"},"relationships":{"posts":{"data":[{"id":"1","type":"post"},{"id":"3","type":"post"}]}}}]}
```

### Has many association

| Gem                                                                                       | IPS                | Comparison   | Allocations | Comparison  |
|-------------------------------------------------------------------------------------------|-------------------:|-------------:|------------:|------------:|
| [panko_serializer 0.8.3](https://github.com/yosiat/panko_serializer)                      |    262.858k ± 6.4% |     baseline |      1.376k |    baseline |
| [transmutation 0.5.1](https://github.com/spellbook-technology/transmutation)              |    120.482k ± 0.7% | 2.18x slower |      4.408k |  3.20x more |
| [representable 3.2.0](https://github.com/trailblazer/representable/)                      |     58.607k ± 2.8% | 4.49x slower |      9.640k |  7.01x more |
| [active_model_serializers 0.10.15](https://github.com/rails-api/active_model_serializers) |     47.181k ± 1.2% | 5.57x slower |      9.480k |  6.89x more |
| [jbuilder 2.13.0](https://github.com/rails/jbuilder/tree/v2.13.0)                         |     44.249k ± 1.8% | 5.94x slower |      6.208k |  4.51x more |
| [jsonapi-serializer 2.2.0](https://github.com/jsonapi-serializer/jsonapi-serializer)      |     40.580k ± 0.6% | 6.48x slower |     16.408k | 11.92x more |
| [rabl 0.17.0](https://github.com/nesquena/rabl)                                           |     31.059k ± 1.3% | 8.46x slower |     10.912k |  7.93x more |

Output for all serialization is:

```json
{"id":1,"first_name":"John","full_name":"John Doe","posts":[{"id":1,"title":"Post 1","body":"Sample body 1"},{"id":3,"title":"Post 3","body":"Sample body 3"}]}
```

With the exception of JSONAPI Serializer, as it follows the JSONAPI spec:

```json
{"data":{"id":"1","type":"user","attributes":{"id":1,"first_name":"John","full_name":"John Doe"},"relationships":{"posts":{"data":[{"id":"1","type":"post"},{"id":"3","type":"post"}]}}},"included":[{"id":"1","type":"post","attributes":{"id":1,"title":"Post 1","body":"Sample body 1"},"relationships":{"user":{"data":{"id":"1","type":"user"}}}},{"id":"3","type":"post","attributes":{"id":3,"title":"Post 3","body":"Sample body 3"},"relationships":{"user":{"data":{"id":"1","type":"user"}}}}]}
```

## How to run the benchmarks yourself

In order to run the benchmarks, you'll need to have Ruby and Bundler installed on your system. Once you've installed all the dependencies with `bundle install`, you can run the benchmarks with or without YJIT enabled.

- Run the benchmarks without YJIT enabled

    ```sh
    bundle exec ruby benchmark.rb
    ```

- Run the benchmarks with YJIT enabled

    ```sh
    bundle exec ruby --yjit benchmark.rb
    ```
