+++
title = "jk - Configuration as code with TypeScript"
date = 2019-05-19T10:21:00Z
updated = 2019-05-19T10:21:00Z
tags = ["jk", "configuration", "go", "javascript", "typescript"]
[author]
  name = "Damien Lespiau"
+++

> **Of all the problems we have confronted, the ones over which the most brain
> power, ink, and code have been spilled are related to managing
> configurations** — [Borg, Omega, and Kubernetes - Lessons learned from three
> container-management systems over a decade][bok]  

**tl;dr**: [`jk`][jk] is a javascript runtime tailored for writing
configuration files. The abstraction and expressive power of a programming
language makes writing configuration easier and more maintainable by allowing
developers to think at a higher level.

For instance, let's pretend we want to deploy a `billing` micro-service on a
Kubernetes cluster. The micro-service could be defined asq:

```yaml
service:
  name: billing
  description: Provides the /api/billing endpoints for frontend.
  maintainer: damien@weave.works
  namespace: billing
  port: 80
  image: quay.io/acmecorp/billing:master-fd986f62
  ingress:
    path: /api/billing
```

From this definition, we can generate Kubernetes `Namespace`, `Deployment`,
`Service` and `Ingress` objects.

{{< tabs >}}
  {{% tab title="billing-ns.yaml" %}}

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: billing
```

  {{% /tab %}}
  {{% tab title="billing-deploy.yaml" %}}

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: billing
  name: billing
  namespace: billing
spec:
  revisionHistoryLimit: 2
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        app: billing
    spec:
      containers:
      - image: quay.io/acmecorp/billing:master-fd986f62
        name: billing
        ports:
        - containerPort: 80
```

  {{% /tab %}}
  {{% tab title="billing-svc.yaml" %}}

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: billing
  name: billing
  namespace: billing
spec:
  ports:
  - port: 80
  selector:
    app: billing
```

  {{% /tab %}}
  {{% tab title="billing-ingress.yaml" %}}

```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
  name: billing
  namespace: billing
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: billing
          servicePort: 80
        path: /api/billing
```

  {{% /tab %}}
{{< /tabs >}}

Building on this example, one can imagine encoding a lot more in the high
level micro-service definition: Grafana dashboards, Prometheus alerts and
scrape configuration, horizontal pod auto-scaler configuration, ...

What's interesting to me is that such an approach shifts writing
configuration file to be a familiar API problem: developers in charge of the
platform get to choose what they want to present to their users, can encode
best practices and hide details of their their Kubernetes cluster in a
library.

For the curious minds, the `jk` script used to generate these Kubernetes
objects can be found in the [jk repository][jk-micro-service].

## The configuration problem

From where I sit, all I can see is a sea of configuration files: Kubernetes
objects, Ansible playbooks, Terraform HCL, CloudFormation templates,
Dockerfiles, travis and circle CI task definitions, ... They are all more or
less structured, often akin to objects with properties (string → any maps
really) with YAML or JSON as textual representation.

Over the years, a lingering feeling has arisen, exacerbated by the arrival of
Kubernetes: exposing this amount of configuration without abstraction power
is neither scalable nor maintainable.

To be more concrete, let's take can a couple of examples:

- A moderately sized Kubernetes cluster can easily hundreds of objects
expressed as YAML files. Imagine scaling this both vertically (dev, staging,
prod clusters) and horizontally (many clusters). It's natural to be wanting
to share the common configuration between those clusters definitions and have
well defined ways to make this configuration evolve over time.

- For organizations using micro-services, very quickly the need arises to
abstract away or factorize the full extend of what it means to be a service
and use a high level definition from which can be derived the details. To
stay concrete if we have `billing` service offering an API on port `80`, we
don't need much more information than that to deploy the service to a
Kubernetes cluster and can encode the details of what it means in a
generation step.

Many attempts have been made to solve this, often siloed to a particular
piece of software: [Ansible][ansible] comes with a [full programming
language][ansible-playbooks] embed as YAML constructs, [Hiera][hiera]
implements object merging for Puppet and even YAML itself has [anchors and
references][yaml-aliases] to reduce duplication. More interestingly, domain
specific languages have appeared in recent years such as [jsonnet][jsonnet]
or [Dhall][dhall] (and its [Kubernetes support][dhall-kubernetes]).

Instead of going into too many details about the problem space here, I'll
refer to the eloquently written [Declarative Application Management in
Kubernetes][k8s-declarative] by Brian Grant.

## `jk` - Built for configuration

So we're building [`jk`][jk] in an attempt to help advance the configuration
management discussion. It offers a different take on existing solutions:

- **`jk` is a generation tool**. We believe in a strict separation of
configuration data and how that data is being used. For instance we do not
take an opinionated view on how you should deploy applications to a cluster
and leave that design choice between your hands. In a sense, `jk` is a pure
function transforming a set of input into configuration files.

- **`jk` uses a general purpose language**: javascript. The configuration
domain attracts a lot of people interested in languages and the result is
many new Domain Specific Languages (DSLs). We do not believe those new
languages offer more expressive power than javascript and their tooling is
generally lagging behind: unit test frameworks, linters, refactoring tools,
IDE support, static typing, libraries, ...

- **`jk` is hermetic**. Hermeticity as [defined by
jsonnet][jsonnet-hermeticity] is the property to produce the same output
given the same input no matter the machine the program is being run on. This
seems like a great property for a tool generating configuration files. We
achieve this with a custom v8-based runtime exposing as little as possible
from the underlying OS. For instance you cannot access the process
environment variables nor read file anywhere on the filesystem with `jk`.

- **`jk` is fast!** By being an embedded DSL and using v8 under the hood,
we're significantly faster than the usual interpreters powering DSLs. For
instance the go jsonnet interpreter is taking 7-8s to render the prometheus
operator Kubernetes objects on my machine!

## Hello, World!

The `jk` ["Hello, World!" example][jk-alice] generates a YAML file from a js
object:

```js
// Alice is a developer.
const alice = {
  name: 'Alice',
  beverage: 'Club-Mate',
  monitors: 2,
  languages: [
    'python',
    'haskell',
    'c++',
    '68k assembly', // Alice is cool like that!
  ],
};

// Instruct to write the alice object as a YAML file.
export default [
  { value: alice, file: `developers/${alice.name.toLowerCase()}.yaml` },
];
```

Run this example with:

```console
$ jk generate -v alice.js
wrote developers/alice.yaml
```

This results in the `developers/alice.yaml` file:

```yaml
beverage: Club-Mate
languages:
- python
- haskell
- c++
- 68k assembly
monitors: 2
name: Alice
```

## Libraries

`jk` separates a generic runtime and its standard library (`@jkcfg/std`) from
domain specific libraries. For instance the [Kubernetes
library][jk-kubernetes] (`@jkcfg/kubernetes`) offer facilities to create
Kubernetes objects.

The runtime and its standard library offers core features:

- Recent v8 and ECMAScript support.
- Import ES6 modules from files & npm packages.
- Generate YAML, JSON, HCL and text files from Javascript objects.
- Read YAML and JSON files as Javascript objects.
- Serialization/deserialization of js objects to/from strings.
- [Input parameters](https://jkcfg.github.io/#/documentation/std-param).
- [List directories and files](https://jkcfg.github.io/#/documentation/std-fs).
- [Logging facilities](https://jkcfg.github.io/#/documentation/std-log).

On top of this core feature, anyone can develop and publish libraries to
provide user-friendly APIs for a particular piece of software. This is where
opinions and API design discussions can be unleashed.

The [`@jkcfg/kubernetes`][jk-kubernetes] library provides such a layer for
Kubernetes. The current state is very much a work in progress but it's
already useful:

- Provides TypeScript typings generated from the [OpenAPI
Spec][k8s-openapi-spec] (`@jkcfg/kubernetes/api`).
- [Kustomize-like overlays][jk-k8s-overlays]
- [Helm-like charts][jk-k8s-charts]

## Typing with TypeScript

## Templating vs object merging

## Text templating

While `jk` is mainly about generating and manipulating structured
configuration, it can certainly be used for text templating.

## To code, or not to code: that is the question

## Status and Future work

Albeit being still young, We believe `jk` is already useful enough to be a
contender in the space. There's a lot of space

- **Helm integration**: we'd like `jk` to be able to render Helm charts
client side and exposed as js objects for further manipulation.
- **Jsonnet integration**: similarly, it should be possible to consume
existing jsonnet programs.
- **Native TypeScript support**: Currently developers need to run the `tsc`
transpiler by hand. We should be able to make `jk` consume TypeScript files
natively a la [deno][deno].
- **Kubernetes strategic merging**: the merging primitives are currently
quite basic and we'd like to extend the object merging capabilities of the
standard library to implement Kubernetes [strategic merging][k8s-merge].
- Expose **typing generation for `CustomResources`**.
- More **helper libraries** to generate Grafana dashboards, custom resource for
the Prometheus operator, ...
- Produce **more examples**: it's easy to feel a bit overwhelmed when facing
a new language and paradigm. More examples should hopefully be useful to make
the discovery of `jk` easier.

## Try it yourself!

It's easy to download `jk` from the [github release page][jk-releases] and
[try it yourself][jk-quickstart]. You can also peruse through the (currently
small amount of) [`examples`][jk-examples].

[ansible]: https://www.ansible.com/
[ansible-playbooks]: https://docs.ansible.com/ansible/latest/user_guide/playbooks.html#
[dap]: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/architecture/declarative-application-management.md
[deno]: https://github.com/denoland/deno
[dhall]: https://github.com/dhall-lang/dhall-lang
[dhall-kubernetes]: https://github.com/dhall-lang/dhall-kubernetes
[hiera]: https://wikitech.wikimedia.org/wiki/Puppet_Hiera
[jk]: https://github.com/jkcfg/jk
[jk-alice]: https://github.com/jkcfg/jk/tree/master/examples/quick-start/alice
[jk-examples]: https://github.com/jkcfg/jk/tree/master/examples
[jk-kubernetes]: https://github.com/jkcfg/kubernetes
[jk-k8s-overlays]: https://github.com/jkcfg/kubernetes/tree/master/examples/overlay
[jk-k8s-charts]: https://github.com/jkcfg/kubernetes/tree/master/examples/chart
[jk-micro-service]: https://github.com/jkcfg/jk/tree/master/examples/kubernetes/micro-service
[jk-quickstart]: https://github.com/jkcfg/jk/tree/master/examples/quick-start/alice
[jk-releases]: https://github.com/jkcfg/jk/releases
[jsonnet]: https://jsonnet.org/
[jsonnet-hermeticity]: https://jsonnet.org/articles/design.html
[k8s-declarative]: https://github.com/kubernetes/community/blob/master/contributors/design-proposals/architecture/declarative-application-management.md
[k8s-merge]: https://github.com/kubernetes/community/blob/master/contributors/devel/sig-api-machinery/strategic-merge-patch.md
[k8s-openapi-spec]: https://github.com/kubernetes/kubernetes/tree/master/api/openapi-spec
[yaml-aliases]: https://medium.com/@kinghuang/docker-compose-anchors-aliases-extensions-a1e4105d70bd
[bok]: https://queue.acm.org/detail.cfm?id=2898444
