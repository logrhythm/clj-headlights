# clj-headlights

[![Build Status](https://travis-ci.org/logrhythm-oss/clj-headlights.svg?branch=master)](https://travis-ci.org/logrhythm-oss/clj-headlights)
[![Clojars Project](https://img.shields.io/clojars/v/logrhythm/clj-headlights.svg)](https://clojars.org/logrhythm/clj-headlights)

Clj-headlights is a toolset for [Apache Beam](https://beam.apache.org/) to use Clojure code and construct pipelines.

It is not intended as a full replacement for the [Beam Java SDK](https://beam.apache.org/documentation/sdks/java/), nor a complete abstraction layer. As a clj-headlights user, you are expected to know [the Beam programming model](https://beam.apache.org/documentation/programming-guide/). Its intent is to make Clojure play nice enough with the official SDK and provide helpers for tedious operations.

## Usage

Latest stable version
```clojure
[logrhythm/clj-headlights "0.3.2"]
```

To get the latest build in from the master branch (may contain breaking changes)

```clojure
[logrhythm/clj-headlights "master-SNAPSHOT"]
```

### Examples

```clojure
(defn split-words [line]
  (str/split line #" "))

(defn word-starts-with? [word substr]
  (str/starts-with? word substr))

(let [pipeline (hl/create (hl/options {:job-name "wordcount"}))]
  (-> pipeline
      (io/resource-string->pcollection "read-file" "file://file.txt")
      (hl/df-mapcat "split-words" #'split-words)
      (hl/df-filter "only-f-words" [#'word-starts-with? "f"])
      (hl/df-map "count-chars" #'count)))
```

You can find example projects in the [examples](./examples) directory, and in the [test/clj_headlights/examples](test/clj_headlights/examples) directory.

## Documentation

See official documentation at https://logrhythm-oss.github.io/clj-headlights/

## Versioning

Versioned based on the major and minor versions of the Beam API, plus a patch version for our version.

## Installing local versions

`lein with-profile uberjar install`

## Publish workflow

You'll need to generate a deploy key on clojars and save it somewhere safe. We have one in CloudAI gopass currently.


After committing and tagging with the version in project.clj being a release version and not a snapshot, run the following:


```
# Be sure JAVA_HOME points to a java 8 installation due to Beam restrictions.
lein with-profile uberjar deploy clojars
```

## Copyright and license

Copyright 2019 LogRhythm, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
