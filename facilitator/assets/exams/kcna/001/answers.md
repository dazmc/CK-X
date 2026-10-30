# KCNA Mock Exam 001 - Answers & Explanations

60 questions across the official KCNA domains. Pass mark: 75% (45/60).

## Kubernetes Fundamentals

### Question 1

How does the kubelet communicate with the container runtime on a node?

**Answer: B**

- A. Through the Docker Engine API directly
- B. Through the CRI (Container Runtime Interface), using runtimes such as containerd or CRI-O
- C. By exec'ing into the runtime container manually
- D. Through the etcd storage backend

*The kubelet talks to runtimes via the CRI gRPC interface. The built-in Docker support (dockershim) was removed in Kubernetes v1.24, so CRI-compatible runtimes like containerd and CRI-O are used instead.*

### Question 2

Which Kubernetes component is the central control-plane entry point that exposes the Kubernetes API?

**Answer: B**

- A. kube-scheduler
- B. kube-apiserver
- C. etcd
- D. kube-controller-manager

*The kube-apiserver is the front end for the control plane: it authenticates, authorizes, and validates all API requests, and is the only component that talks directly to etcd.*

### Question 3

Where does a Kubernetes cluster persist its entire state and configuration?

**Answer: B**

- A. In the kube-apiserver memory only
- B. In etcd, the distributed key-value store
- C. In a SQLite database on the master node
- D. In ConfigMaps on every worker node

*etcd is the cluster's source of truth - a consistent distributed key-value store. Every object, from Pods to RBAC rules, is persisted there via the API server.*

### Question 4

What is the smallest deployable unit that Kubernetes manages?

**Answer: B**

- A. A container image
- B. A Pod
- C. A Deployment
- D. A node

*A Pod is the smallest deployable unit: one or more tightly coupled containers sharing network and storage, scheduled together onto a node.*

### Question 5

A Pod has no nodeSelector or affinity rules. Which component decides which node it runs on?

**Answer: B**

- A. The kubelet on each node
- B. The kube-scheduler
- C. The cloud-controller-manager
- D. The kube-apiserver

*The kube-scheduler watches for unscheduled Pods and assigns them to nodes based on resource availability, taints/tolerations, affinity, and topology constraints. The kubelet then starts the Pod locally.*

### Question 6

Which kubectl command lists Pods across ALL namespaces?

**Answer: B**

- A. kubectl get pods -o wide
- B. kubectl get pods --all-namespaces
- C. kubectl get pods --recursive
- D. kubectl get pods -n default

*The -n/--namespace flag selects a namespace, and --all-namespaces (short -A) widens the query to every namespace. -o wide only adds extra output columns.*

### Question 7

What is the primary responsibility of the kubelet?

**Answer: B**

- A. Routing traffic between Services
- B. Acting as the node agent that ensures containers described in Pod specs are running and healthy
- C. Resolving cluster DNS queries
- D. Provisioning persistent volumes

*The kubelet runs on every node and is responsible for receiving Pod specs from the API server, starting/stopping containers via the runtime, and reporting node and Pod status.*

### Question 8

Which Service type exposes the Service on a port on every node's IP address?

**Answer: B**

- A. ClusterIP
- B. NodePort
- C. LoadBalancer
- D. ExternalName

*A NodePort service opens a port on every node and forwards external traffic to the backing Pods. ClusterIP is internal-only, LoadBalancer provisions a cloud load balancer, and ExternalName is a DNS CNAME alias.*

### Question 9

What does a Deployment manage directly?

**Answer: A**

- A. A ReplicaSet, which in turn manages the Pods
- B. The Pods directly, without any intermediate object
- C. The nodes the Pods run on
- D. The Service routing rules

*Deployments own ReplicaSets. The Deployment controller creates a new ReplicaSet during a rollout, while the ReplicaSet ensures the desired number of Pods exist.*

### Question 10

Which Kubernetes object is designed to store sensitive data such as passwords and TLS keys?

**Answer: B**

- A. ConfigMap
- B. Secret
- C. PersistentVolumeClaim
- D. ServiceAccount

*Secrets store and inject sensitive data (base64-encoded, with encryption at rest if configured). ConfigMaps hold non-sensitive configuration, PVCs request storage, and ServiceAccounts identify processes within the cluster.*

### Question 11

What is the default type of a Kubernetes Service?

**Answer: B**

- A. NodePort
- B. ClusterIP
- C. LoadBalancer
- D. Headless

*Services default to ClusterIP, which exposes the Service on an internal virtual IP reachable only within the cluster. You must explicitly request NodePort or LoadBalancer.*

### Question 12

Which resource object is used to define HTTP/HTTPS routing rules such as hostnames and path-based routing?

**Answer: A**

- A. Ingress
- B. NetworkPolicy
- C. Endpoint
- D. CustomResourceDefinition

*An Ingress object defines HTTP(S) routing rules (hosts, paths, TLS) and is fulfilled by an Ingress controller such as ingress-nginx. NetworkPolicies control traffic allow/deny, not routing.*

### Question 13

How does a Service find the Pods it routes traffic to?

**Answer: B**

- A. By matching Pod names listed in an endpoint file
- B. By its label selector matching the labels on Pods
- C. By the namespace the Pods belong to
- D. By the node the Pods run on

*A Service has a selector (e.g. spec.selector: { app: web }) that matches Pod labels. The endpoints controller continuously updates the Endpoints/EndpointSlice object with the IPs of matching Pods.*

### Question 14

What is a PersistentVolume (PV)?

**Answer: A**

- A. A piece of storage in the cluster, provisioned by an admin or dynamically, that outlives individual Pods
- B. A directory on the node that is recreated when the Pod restarts
- C. A cache directory inside a container
- D. A replica of etcd storage

*A PV is a cluster-level storage resource with a lifecycle independent of any Pod. Pods consume storage indirectly through PersistentVolumeClaims.*

### Question 15

What does a StorageClass with volumeBindingMode: WaitForFirstConsumer do?

**Answer: B**

- A. Binds the PersistentVolumeClaim immediately when it is created
- B. Delays binding until a Pod using the claim is scheduled, so the volume can be placed in the right zone
- C. Deletes the claim when the Pod stops using it
- D. Converts the volume to a hostPath mount

*WaitForFirstConsumer defers volume binding until a consumer Pod is scheduled, which avoids cross-zone volume attachment issues and enables topology-aware provisioning.*

### Question 16

Which workload controller runs a Pod to successful completion exactly once (e.g. a batch job)?

**Answer: B**

- A. Deployment
- B. Job
- C. DaemonSet
- D. StatefulSet

*A Job runs Pods until they complete successfully, retrying on failure. Deployments keep Pods running forever, DaemonSets run one Pod per node, and StatefulSets manage identity-bound long-running Pods.*

### Question 17

Which workload controller guarantees that exactly one Pod of a given template runs on every node in the cluster?

**Answer: A**

- A. DaemonSet
- B. StatefulSet
- C. Deployment
- D. ReplicaSet

*DaemonSets ensure one Pod per node (including nodes added later). They are commonly used for node agents such as log collectors and monitoring exporters.*

### Question 18

What is the purpose of taints and tolerations?

**Answer: B**

- A. To attract specific Pods to a node
- B. To repel Pods from a node unless the Pod explicitly tolerates the taint
- C. To balance Pods across availability zones
- D. To limit how much CPU a Pod may use

*A taint on a node repels Pods that don't tolerate it (e.g. the built-in node.kubernetes.io/not-ready taint). Tolerations in a Pod spec allow it to be scheduled onto tainted nodes.*

### Question 19

What does kubectl apply -f manifest.yaml do?

**Answer: B**

- A. Creates the resources imperatively and never updates them afterwards
- B. Declaratively creates or updates resources so the cluster matches the file's desired state
- C. Deletes everything defined in the file
- D. Validates the file without contacting the API server

*kubectl apply is the declarative approach: it sends the manifest to the API server, creating or updating the object (adding the last-applied-configuration annotation for three-way diffs).*

### Question 20

Which API group and version should be used for a Deployment in a current Kubernetes cluster?

**Answer: C**

- A. extensions/v1beta1
- B. apps/v1beta2
- C. apps/v1
- D. v1

*Deployments are GA under apps/v1. The legacy extensions/v1beta1 and apps/v1beta2 APIs were deprecated and removed - deployments, statefulsets, daemonsets, and replicasets all live in the apps/v1 group.*

### Question 21

What is a namespace in Kubernetes?

**Answer: B**

- A. A physical hardware partition of the cluster
- B. A virtual partition within a single cluster for logically isolating related resources
- C. A separate Kubernetes cluster
- D. A network segment with its own IP range

*Namespaces provide virtual isolation inside one cluster - useful for separating environments or teams and for scoping resource quotas and RBAC. They do not provide hard network or hardware isolation.*

### Question 22

What does kube-proxy do on each node?

**Answer: B**

- A. Resolves Service DNS names
- B. Programs networking rules (iptables or IPVS) so Service virtual IPs reach the correct Pods
- C. Schedules Pods onto the node
- D. Stores the cluster state in etcd

*kube-proxy maintains the node's networking rules so traffic to a Service's virtual IP is load-balanced to the matching Pod endpoints. Cluster DNS is handled by CoreDNS, not kube-proxy.*

### Question 23

In a Pod spec, what does imagePullPolicy: Never instruct the kubelet to do?

**Answer: B**

- A. Always pull the latest image from the registry
- B. Use only an image already present on the node; never contact a registry
- C. Pull the image once and cache it forever
- D. Pull the image only from a private registry

*imagePullPolicy: Never means the kubelet must find the image locally on the node, otherwise the container fails to start (ErrImageNeverPull). This is common in air-gapped or preloaded-node setups.*

### Question 24

What is the difference between a container's resource requests and limits?

**Answer: B**

- A. Requests are the maximum the container may use; limits are the guaranteed minimum
- B. Requests are the minimum guaranteed amount used for scheduling; limits are the maximum the container may consume
- C. Requests are for CPU only; limits apply only to memory
- D. There is no difference - they are interchangeable fields

*requests define the minimum guaranteed resources (used by the scheduler to place the Pod); limits define the hard ceiling - exceeding the memory limit kills the container (OOMKilled), while exceeding the CPU limit throttles it.*

### Question 25

How do you ensure a Pod is only scheduled onto nodes with a specific label, such as disk=ssd?

**Answer: A**

- A. Set a nodeSelector in the Pod spec matching the node label
- B. Add an annotation to the Service
- C. Create a ResourceQuota in the namespace
- D. Taint every other namespace

*A nodeSelector (e.g. nodeSelector: { disk: ssd }) constrains scheduling to nodes carrying that label. For more expressive rules (set-based matching, preferred rules), use node affinity.*

### Question 26

How does kubectl describe pod differ from kubectl logs?

**Answer: A**

- A. kubectl describe shows object details and recent events; kubectl logs shows the output of the container process
- B. They are identical commands
- C. kubectl describe shows only logs; kubectl logs shows only events
- D. kubectl describe works offline; kubectl logs requires the API server

*kubectl describe renders the full object spec plus status and the last events from the namespace - invaluable for diagnosing scheduling and probe failures - while kubectl logs streams the container's stdout/stderr.*

## Container Orchestration

### Question 27

What is the default update strategy of a Kubernetes Deployment?

**Answer: A**

- A. RollingUpdate
- B. Recreate
- C. Blue-green
- D. Canary

*Deployments default to RollingUpdate, gradually replacing old Pods with new ones while respecting maxUnavailable and maxSurge. Recreate must be requested explicitly; blue-green and canary are application-level patterns built on top of Kubernetes primitives.*

### Question 28

During a Deployment rollout, what does maxUnavailable: 0 with maxSurge: 1 accomplish?

**Answer: B**

- A. Pauses the rollout until an operator resumes it
- B. Never drops below the desired replica count - it creates one extra Pod first and removes old Pods only once new ones are ready
- C. Deletes all old Pods before starting new ones
- D. Limits the rollout to one node

*maxUnavailable: 0 keeps every replica available throughout the rollout, while maxSurge: 1 allows one extra Pod to be created temporarily. The result is a zero-downtime update.*

### Question 29

A Pod managed by a Deployment is deleted. What causes it to be replaced?

**Answer: B**

- A. The kube-scheduler detects the missing Pod
- B. The ReplicaSet controller notices the current replica count is below the desired count and creates a new Pod
- C. The kubelet on the node restarts the container
- D. The Ingress controller reschedules it

*Each Deployment owns a ReplicaSet that continuously reconciles: if live Pods fall below the replicas field, it creates more. The scheduler only places already-created Pods; it doesn't create them.*

### Question 30

What does kubectl scale deployment web --replicas=5 do?

**Answer: B**

- A. Increases the CPU limit on the web Pods to 5 cores
- B. Updates the Deployment's replicas field so the ReplicaSet creates or removes Pods to reach 5
- C. Creates 5 separate Deployments named web
- D. Scales the underlying node count to 5

*Scaling changes the desired replica count in the Deployment spec. The ReplicaSet controller then adds or deletes Pods to converge on that number.*

### Question 31

What drives the decisions of a Horizontal Pod Autoscaler (HPA)?

**Answer: B**

- A. The number of nodes in the cluster
- B. Observed metrics such as CPU or memory utilization compared to a target value
- C. The time of day
- D. The number of etcd keys

*The HPA periodically samples metrics (CPU/memory from metrics-server, or custom/external metrics) and scales replicas so the observed utilization matches the target. It scales horizontally (more Pods), not vertically.*

### Question 32

What is the purpose of a readiness probe?

**Answer: B**

- A. To restart a container that has crashed
- B. To determine whether the container is ready to accept traffic - until it passes, the Pod's IP is excluded from Service endpoints
- C. To measure how long the container took to start
- D. To terminate the container when memory is exhausted

*A failing readiness probe removes the Pod from Service endpoints so no traffic is sent until the application is actually able to serve. Liveness probes, by contrast, trigger container restarts.*

### Question 33

What happens when a liveness probe fails repeatedly?

**Answer: B**

- A. The Pod is removed from the Service endpoints only
- B. The container is killed and restarted by the kubelet according to the restart policy
- C. The Pod is rescheduled onto another node immediately
- D. The rollout is automatically rolled back

*Liveness failures cause the kubelet to restart the container (the classic fix for deadlocked or hung applications). To avoid the same fate during startup, use a startup probe. Readiness failures only divert traffic.*

### Question 34

Why would you add a startup probe to a container?

**Answer: B**

- A. To speed up the startup of slow applications
- B. To give a slow-starting application time to initialize without the liveness probe killing it
- C. To replace the readiness probe entirely
- D. To probe the node's health

*A startup probe runs until it succeeds, and liveness/readiness probes don't begin until it passes. This protects applications that need a long initialization period from being restarted by an impatient liveness probe.*

### Question 35

Which workload controller should be used for a database that needs a stable network identity and stable persistent storage across restarts?

**Answer: C**

- A. Deployment
- B. DaemonSet
- C. StatefulSet
- D. Job

*StatefulSets provide stable, ordinal pod names (mysql-0, mysql-1...), stable DNS names, and per-pod PersistentVolumeClaims - exactly what stateful workloads like databases need.*

### Question 36

In a Helm chart, what is the purpose of values.yaml?

**Answer: B**

- A. It documents the chart's license
- B. It provides default configuration values that users can override at install/upgrade time
- C. It lists the cluster's nodes
- D. It stores Secrets in plain text

*values.yaml holds the chart's default configuration. Users override these values (via -f files or --set flags) to customize an installation without editing the templates.*

### Question 37

What is a Helm release?

**Answer: B**

- A. A new version of the Kubernetes API
- B. A single installed instance of a chart, with its own name, history, and state
- C. The container image tag of an application
- D. A Helm repository URL

*Every helm install creates a release - a named, tracked instance of a chart. You can upgrade, roll back (helm rollback), or uninstall releases independently, and Helm stores their history in the cluster.*

### Question 38

What does helm upgrade --install myapp ./chart do?

**Answer: B**

- A. Always creates a duplicate installation alongside the existing one
- B. Installs the chart if the release doesn't exist, otherwise upgrades the existing release in place - making it safe for CI pipelines
- C. Downgrades Kubernetes itself
- D. Uninstalls the release before reinstalling it

*The --install flag makes the command idempotent: it installs when absent and upgrades when present. This one-liner is the standard pattern for automated continuous delivery pipelines.*

### Question 39

What is the effect of a ResourceQuota on a namespace?

**Answer: B**

- A. It limits the number of namespaces a user can create
- B. It caps the total amount of compute resources (or object counts) that all objects in the namespace may request
- C. It quarantines a namespace during incidents
- D. It reserves resources exclusively for the namespace on every node

*ResourceQuotas enforce ceilings per namespace - e.g. a maximum total CPU/memory or maximum number of Pods - which is the standard way to stop one team or environment from consuming the whole cluster.*

### Question 40

Which component provides the resource usage data (CPU/memory) that kubectl top and the HPA rely on?

**Answer: B**

- A. etcd
- B. metrics-server
- C. kube-proxy
- D. CoreDNS

*metrics-server collects resource usage metrics from the kubelets on each node and exposes them via the metrics API. Without it, kubectl top fails and CPU/memory-based HPAs cannot function.*

### Question 41

Which type of probe simply checks whether a TCP connection to a container's port succeeds?

**Answer: B**

- A. HTTP GET probe
- B. TCP socket probe
- C. exec probe
- D. liveness probe

*A TCP probe opens a socket to the specified port and succeeds if the connection is established. HTTP probes check for a successful status code; exec probes run a command inside the container.*

### Question 42

What is the purpose of a PodDisruptionBudget (PDB)?

**Answer: B**

- A. To prevent a node from running too many Pods
- B. To limit how many Pods may be voluntarily disrupted at once (e.g. during node drains or cluster upgrades) so the application stays available
- C. To set CPU and memory budgets for a Pod
- D. To reserve budget for future node autoscaling

*A PDB guards against voluntary disruptions: cluster upgrades and kubectl drain will respect it and only evict as many Pods as allowed. It does not protect against node failures or crashes ( involuntary disruptions).*

### Question 43

You run kubectl rollout status deployment/web. What are you checking?

**Answer: B**

- A. The rollout history of the Deployment
- B. Whether the in-progress rollout has completed and all new Pods are available
- C. The resource usage of the new Pods
- D. Whether the Deployment's image was pulled successfully

*rollout status watches the live state of a rollout and reports when the new ReplicaSet has reached the desired, available replicas - commonly used to gate CI/CD pipelines on successful deployments.*

## Cloud Native Application Delivery

### Question 44

What is the primary goal of Continuous Integration (CI)?

**Answer: B**

- A. To deploy directly to production on every commit
- B. To integrate and verify developers' changes frequently and automatically so integration problems are found early
- C. To write documentation continuously
- D. To replace manual code reviews

*CI means merging changes into a shared mainline many times a day, with every merge automatically built and tested. The payoff is early detection of integration defects, not automatic production deployment.*

### Question 45

What is the core principle of GitOps?

**Answer: B**

- A. Developers push changes directly to production clusters with kubectl
- B. Git is the single source of truth for the desired state, and automated agents reconcile the cluster to match it
- C. Every deployment requires manually merging pull requests on the cluster
- D. Git repositories are hosted inside the Kubernetes cluster

*In GitOps the desired state of the system lives in Git; an agent (Argo CD or Flux) continuously compares the actual cluster state with the repo and applies differences. This gives auditability, rollback via git revert, and self-healing.*

### Question 46

Which of these is a CNCF Graduated GitOps continuous-delivery tool that reconciles Kubernetes clusters with manifests in Git?

**Answer: B**

- A. Jenkins
- B. Argo CD
- C. Travis CI
- D. SonarQube

*Argo CD (CNCF Graduated) is a declarative GitOps CD tool for Kubernetes. Jenkins and Travis CI are general CI systems (push-based), and SonarQube is a code-quality platform.*

### Question 47

In a push-based CI/CD pipeline versus a GitOps (pull-based) model, what is the key difference?

**Answer: B**

- A. Push-based requires Git; GitOps does not use Git
- B. In GitOps, the in-cluster agent pulls the desired state from Git - the CI system never needs cluster credentials
- C. Pull-based is slower because humans apply the changes
- D. There is no practical difference; only the naming changed

*With GitOps, reconciliation is pulled from inside the cluster by an agent, so the CI pipeline doesn't need kubernetes secrets or direct cluster access - a smaller credential blast radius plus a full audit trail in Git.*

### Question 48

What is progressive delivery?

**Answer: B**

- A. Deploying to production progressively over several weeks without metrics
- B. Gradually rolling out a new version to a small slice of users, measuring key metrics, and expanding only if the metrics stay healthy
- C. Shipping features one file at a time
- D. Deploying each microservice to its own cluster

*Progressive delivery (canary releases, feature flags, automated analysis) limits the blast radius of a release and uses live metrics as a gate before full rollout - with automatic rollback when signals degrade.*

### Question 49

What is the defining characteristic of a blue-green deployment?

**Answer: B**

- A. Traffic is gradually shifted by percentage
- B. Two full environments (old and new) run side by side, and traffic switches between them atomically - rollback means switching back
- C. Only two microservices are ever deployed
- D. The database schema is never migrated

*Blue-green keeps two identical environments and flips a single switch (e.g. a Service selector or Ingress weight) from the old version to the new one. Instant rollback is the main benefit; the cost is running double capacity.*

### Question 50

How does a canary release work?

**Answer: B**

- A. All users get the new version at once, then it is rolled back if issues appear
- B. A small percentage of traffic is routed to the new version while most users stay on the old one; metrics determine expansion or rollback
- C. The new version is only released on weekends
- D. Two clusters are kept permanently in sync

*A canary exposes only a small slice of traffic to the new version first. If error rates or latency stay healthy, the rollout expands; if not, traffic returns to the stable version with minimal impact.*

### Question 51

What does the principle of immutable infrastructure mean?

**Answer: B**

- A. Servers must never be patched or rebooted
- B. Instead of modifying running servers or containers in place, you build new images/artifacts and replace instances
- C. All data must be stored in read-only volumes
- D. Infrastructure objects cannot be deleted once created

*Immutable infrastructure means replacing rather than patching in place: build a new container image, roll it out, discard the old instances. This eliminates configuration drift and makes rollbacks trivial and reliable.*

### Question 52

What is the role of an artifact registry in a cloud native delivery pipeline?

**Answer: B**

- A. To compile source code into binaries
- B. To store versioned, immutable artifacts such as container images and Helm charts so deployments are reproducible
- C. To monitor running applications
- D. To manage developer identities

*A registry (e.g. Harbor, ECR, GHCR) stores versioned container images and charts. Deployments reference immutable digests, giving reproducibility, provenance, and a place to run vulnerability scans before promotion.*

### Question 53

What does Infrastructure as Code (IaC) mean?

**Answer: B**

- A. Writing application logic inside VM images
- B. Managing and provisioning infrastructure through machine-readable definitions stored in version control, applied repeatably and automatically
- C. Manually clicking through a cloud provider's web console
- D. Compiling infrastructure into container images

*IaC expresses infrastructure (networks, clusters, Kubernetes manifests, Terraform configs) as versioned declarative definitions. This makes environments reproducible, reviewable via pull requests, and recoverable.*

## Cloud Native Architecture

### Question 54

According to the CNCF, what best describes a cloud native application?

**Answer: B**

- A. Any application hosted on a public cloud vendor's servers
- B. An application built from loosely coupled, resilient, manageable, observable microservices, packaged in containers and managed by agile processes
- C. An application written exclusively in Go
- D. A monolithic application deployed on Kubernetes

*The CNCF defines cloud native as using loosely coupled, resilient, manageable, observable microservices, typically containerized and orchestrated (Kubernetes), supported by agile infrastructure and delivery practices.*

### Question 55

In the twelve-factor app methodology, where should configuration that varies between deployments (credentials, URLs) be stored?

**Answer: B**

- A. Hard-coded in the source code
- B. In environment variables (or config injected via the environment)
- C. In the container image
- D. On a shared network drive

*Factor III (Config) says strict separation of config from code: store environment-specific values in the environment (in Kubernetes, injected via ConfigMaps and Secrets), so the same build runs unchanged across dev, staging, and prod.*

### Question 56

What is the difference between declarative and imperative APIs?

**Answer: B**

- A. Declarative APIs tell the system HOW to do each step; imperative APIs state the desired END STATE
- B. Declarative APIs state the desired end state and the system works out how to achieve it; imperative APIs specify each action to perform
- C. They are the same concept with different names
- D. Declarative APIs only work with YAML; imperative APIs only work with JSON

*Kubernetes is declarative: you submit the desired state (a Pod spec) and controllers continuously reconcile toward it. Imperative commands (kubectl create/run) specify individual actions with no ongoing reconciliation.*

### Question 57

What does a service mesh provide?

**Answer: B**

- A. A physical cable between microservices
- B. Infrastructure-level traffic management, security (mTLS), and observability between services, without changing application code
- C. A replacement for the Kubernetes control plane
- D. A container image build system

*A service mesh (e.g. Istio, Linkerd) adds a sidecar-based layer that handles service-to-service traffic (routing, retries, circuit breaking), mutual TLS, and telemetry - independently of application code and language.*

### Question 58

What are the three commonly cited pillars of observability?

**Answer: A**

- A. Metrics, logs, and traces
- B. CPU, memory, and disk
- C. Alerts, dashboards, and reports
- D. Events, audits, and dumps

*Metrics (numeric time series), logs (discrete event records), and traces (request paths across services) together make a system's internal state understandable from the outside - the standard observability triad.*

### Question 59

What is the purpose of the circuit breaker pattern in a microservices architecture?

**Answer: B**

- A. To physically cut power to failing services
- B. To stop calls to a failing service after repeated failures, preventing cascading failures across the system and giving it time to recover
- C. To encrypt traffic between services
- D. To balance traffic evenly regardless of service health

*A circuit breaker 'opens' after a failure threshold, failing fast instead of hammering a struggling dependency. This stops timeouts from cascading through callers; it then half-opens to test whether the service has recovered.*

### Question 60

What is a key advantage of a microservices architecture over a monolith?

**Answer: B**

- A. Microservices always require less total code
- B. Each service can be developed, deployed, and scaled independently, so teams can ship and scale parts of the system separately
- C. Microservices eliminate the need for APIs
- D. A single deployment pipeline covers the entire system

*Microservices trade deployment complexity for independence: teams own services end-to-end, deploy on their own cadence, and scale hot components independently. The costs - network boundaries, distributed data, eventual consistency - are the trade-off.*
