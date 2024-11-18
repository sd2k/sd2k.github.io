+++
title = "Announcing augurs - a time series toolkit for Rust"
date = 2024-11-18
+++

I'm excited to announce [`augurs`][augu.rs], a time series toolkit for Rust.

`augurs` is a collection of crates that provide a set of tools for working with time series data.
Functionality includes:

- [forecasting] using [exponential smoothing] (ETS), [multiple seasonal decomposition][mstl] (MSTL) and [Prophet][prophet] models
- [outlier detection][outlier] using [DBSCAN][dbscan] and [median absolute deviation][mad] (MAD) algorithms
- [dynamic time warping][dtw-module] ([DTW][dtw]) for distance and distance matrix calculations
- [time series clustering][clustering] using [DBSCAN][dbscan]
- [seasonality detection][seasons] using [periodograms]

It's still a work in progress, but I think it's about time it was shared with the world.

[Take a look at the demo][demo] to see what you can do!

## What is a time series?

A time series is a sequence of data points indexed by time. Imagine a series of temperature readings taken every hour for a year.
The data points are indexed by the time of the reading, and the values are the temperature at that time.

## Why might you use this?

Time series data is everywhere, and while there are tons of tools for working with it in Python or R, there's not a whole lot available in Rust.

This crate is designed to fill that gap, as well as provide bindings for other languages (currently Javascript and Python)
to make it easier to use in environments like the web.

There are lots of real world use cases for time series data. Here are a few examples:

- projecting data into the future for planning
  e.g. predicting future temperature or sales data for planning
- detecting _anomalies_ (when time series don't behave as expected) so you can be alerted
  - e.g. you have a sensor which emits temperature readings every minute, and you want to know
    when the temperature is unusually high or low
- finding _outliers_ (when one time series is much different from the rest)
  - e.g. you have a Kubernetes `ReplicaSet` emitting metrics from each pod and you want to know
    when one pod is misbehaving
- finding groups of series which behave similarly

All of this is doable in `augurs`!

Also, anecdotally it feels faster than other implementations of the same algorithms. There are some benchmarks in the repository, but they don't
compare to other implementations - they're mainly just to make sure it's fast enough and to help with profiling. If anyone is interested in comparing
to other implementations (e.g. `statsforecast` or R, on which some of augurs' implementations are based), I'd be happy to add them to the benchmarks.

## Why is it called augurs?

The word [augur] can mean 'to predict', and I initially only intended the project to contain forecasting functionality, so it was pretty ideal. Plus the [augu.rs] domain was available and it was too good a chance to pass up!

## How do I use it?

The best way to get started is to look at the [documentation][augu.rs]. The [Rust API docs][docsrs]) are also fairly thorough, but unfortunately the
same can't yet be said of the [Javascript][npm] or [Python][pypi] bindings. Watch this space!

Here's a quick example of how you might use `augurs` for in-sample forecasting with the Prophet model:

```rust
use augurs::prophet::{wasmstan::WasmstanOptimizer, Prophet, TrainingData};

// Define the training data.
let ds = vec![
    1704067200, 1704871384, 1705675569, 1706479753, 1707283938, 1708088123, 1708892307,
    1709696492, 1710500676, 1711304861, 1712109046, 1712913230, 1713717415,
];
let y = vec![
    1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0,
];
let data = TrainingData::new(ds, y.clone())?;

// Create an optimizer. This one uses Stan compiled to WASM!
let wasmstan = WasmstanOptimizer::new();
// Create our model.
let mut prophet = Prophet::new(Default::default(), wasmstan);
// Fit the model. We could provide other optimization options if we wanted.
prophet.fit(data, Default::default())?;

// Get in-sample predictions.
// We could get out-of-sample predictions too by passing a `PredictionData` instead of `None`.
let predictions = prophet.predict(None)?;
println!("Predicted values: {:#?}", predictions.yhat);
```

If you're interested in contributing, the [GitHub] repository is the best place to start. Feature requests and bug reports are also welcome!

[exponential smoothing]: https://otexts.com/fpp3/expsmooth.html
[mstl]: https://robjhyndman.com/publications/mstl/
[prophet]: https://facebook.github.io/prophet/
[dbscan]: https://en.wikipedia.org/wiki/DBSCAN
[mad]: https://en.wikipedia.org/wiki/Median_absolute_deviation
[dtw]: https://en.wikipedia.org/wiki/Dynamic_time_warping
[periodograms]: https://www.sktime.net/en/stable/api_reference/auto_generated/sktime.param_est.seasonality.SeasonalityPeriodogram.html

[clustering]: https://docs.rs/augurs/latest/augurs/clustering/index.html
[dtw-module]: https://docs.rs/augurs/latest/augurs/dtw/index.html
[forecasting]: https://docs.rs/augurs/latest/augurs/forecaster/index.html
[outlier]: https://docs.rs/augurs/latest/augurs/outlier/index.html
[seasons]: https://docs.rs/augurs/latest/augurs/seasons/index.html

[augur]: https://www.collinsdictionary.com/dictionary/english/augur

[augu.rs]: https://augu.rs
[demo]: https://demo.augu.rs
[github]: https://github.com/grafana/augurs
[docsrs]: https://docs.rs/augurs/latest/augurs/
