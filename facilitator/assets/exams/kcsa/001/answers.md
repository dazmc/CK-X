# KCSA Mock Exam 001 - Answers & Explanations

60 questions across the official KCSA domains. Pass mark: 75% (45/60).

## Overview of Cloud Native Security

### Question 1

What three properties make up the CIA triad of information security?

**Answer: A**

- A. Confidentiality, Integrity, Availability
- B. Control, Identity, Authentication
- C. Configuration, Isolation, Authorization
- D. Compliance, Inspection, Auditing

*The CIA triad - Confidentiality (only authorized access), Integrity (data is accurate and unaltered), Availability (systems are reachable when needed) - is the foundation model for evaluating security controls.*

### Question 2

What is 'defense in depth'?

**Answer: B**

- A. Defending only the network perimeter as strongly as possible
- B. Using multiple layered, independent security controls so the failure of any single one does not compromise the system
- C. Keeping all servers in physically deep underground data centers
- D. Deferring security decisions to a later phase of the project

*Defense in depth stacks layers (network policies, RBAC, pod security, image scanning, runtime monitoring...). An attacker who bypasses one layer still faces the next, limiting blast radius.*

### Question 3

What does the principle of least privilege mean?

**Answer: A**

- A. Giving users and workloads the minimum permissions they need, for the minimum time needed
- B. Using the fewest possible servers
- C. Restricting access to administrators only
- D. Encrypting everything with a single shared key

*Least privilege means every identity - human or workload - gets only the permissions required for its task. In Kubernetes this maps directly to narrowly scoped RBAC Roles instead of cluster-admin bindings.*

## Compliance and Security Frameworks

### Question 4

How is risk typically quantified in risk assessment?

**Answer: B**

- A. Risk = number of vulnerabilities × age of the system
- B. Risk = likelihood of a threat exploiting a vulnerability × impact if it succeeds
- C. Risk = cost of the infrastructure
- D. Risk = number of users affected divided by uptime

*Risk combines the probability a threat will exploit a vulnerability with the business impact of success. This lets teams prioritize: a high-impact but extremely unlikely event may rank below a moderate issue that is almost certain.*

## Kubernetes Threat Model

### Question 5

What is the primary purpose of threat modeling?

**Answer: A**

- A. To identify potential threats and attack surfaces early, before code is written or deployed
- B. To monitor production traffic for intrusions in real time
- C. To purchase cyber insurance
- D. To certify compliance with a regulation

*Threat modeling (e.g. STRIDE) systematically enumerates what can go wrong -spoofing, tampering, repudiation, information disclosure, denial of service, elevation of privilege - while design changes are still cheap.*

## Overview of Cloud Native Security

### Question 6

In the shared responsibility model for cloud security, what is the cloud provider responsible for?

**Answer: A**

- A. The security of the cloud itself - physical infrastructure, hypervisor, and managed service foundations
- B. The customer's data, identity management, and application configuration
- C. Writing the customer's application code
- D. Patch management of workloads running in customer containers

*The provider secures 'the cloud' (hardware, network, managed control plane), while customers secure what they put 'in the cloud' - data, access management, configurations, and workloads. Misconfigured customer resources remain the customer's responsibility.*

## Kubernetes Threat Model

### Question 7

What is the difference between a vulnerability and a threat?

**Answer: B**

- A. They are the same thing
- B. A vulnerability is a weakness; a threat is anything that could exploit that weakness to cause harm
- C. A threat is a weakness in software; a vulnerability is the attacker
- D. A vulnerability only exists in cloud environments

*A vulnerability is a latent weakness (e.g. an unpatched library). A threat is an actor or event that could exploit it. Risk emerges from the combination of threat, vulnerability, and impact.*

## Overview of Cloud Native Security

### Question 8

What is the core idea of a Zero Trust security model?

**Answer: B**

- A. Trust everything inside the corporate network perimeter
- B. Never trust, always verify - every request is authenticated and authorized regardless of origin
- C. Trust no employees with production access
- D. Remove all trust from third-party vendors only

*Zero Trust eliminates implicit trust based on network location. Each request is verified (identity, context, policy) - which aligns well with Kubernetes, where pod-to-pod traffic should be authenticated and authorized, not trusted because it is cluster-internal.*

## Kubernetes Threat Model

### Question 9

An attacker emails employees a link to a fake login page to steal credentials. What type of attack is this?

**Answer: B**

- A. SQL injection
- B. Social engineering (phishing)
- C. Cross-site scripting
- D. Denial of service

*Phishing is social engineering - manipulating people into revealing credentials or running malicious code. It bypasses technical controls entirely, which is why security awareness training matters alongside tooling.*

## Kubernetes Security Fundamentals

### Question 10

What do authentication and authorization represent respectively?

**Answer: A**

- A. Authentication is who you are; authorization is what you are allowed to do
- B. Authentication is what you can do; authorization is who you are
- C. Both refer to the same check performed at different times
- D. Authentication applies to users only; authorization applies to services only

*Authentication proves identity (login, certificates, tokens); authorization determines permissions (RBAC rules). They are distinct - a correctly authenticated user can still be denied an action by authorization.*

## Overview of Cloud Native Security

### Question 11

Which security property ensures that a party cannot deny having performed an action?

**Answer: C**

- A. Confidentiality
- B. Availability
- C. Non-repudiation
- D. Redundancy

*Non-repudiation - typically provided by digital signatures and tamper-evident audit logs - means an actor cannot plausibly deny their actions. It underpins accountability and forensic investigations.*

### Question 12

Which principle states that a system should remain secure even if its design and source code are public?

**Answer: B**

- A. The principle of least privilege
- B. Kerckhoffs's principle - security should rely on keys, not on secrecy of the design
- C. The principle of defense in depth
- D. The principle of shared responsibility

*Kerckhoffs's principle: a system needn't be secret to be secure - only its keys should be. Open-source security tooling (Kubernetes, Falco, Trivy) leans on many eyes auditing the design rather than obscurity.*

## Compliance and Security Frameworks

### Question 13

Which set correctly lists the phases of incident response?

**Answer: A**

- A. Prepare, Detect & Analyze, Contain, Eradicate & Recover, Post-Incident Activities
- B. Scan, Patch, Deploy, Monitor
- C. Identify, Protect, Detect, Respond only
- D. Plan, Build, Test, Launch

*The NIST incident response lifecycle: Preparation; Detection and Analysis; Containment; Eradication and Recovery; Post-Incident Activity (lessons learned). Preparation - runbooks, logging, backups - is what makes the rest fast.*

### Question 14

What is the difference between a vulnerability assessment and a penetration test?

**Answer: B**

- A. They are different names for the same activity
- B. A vulnerability assessment systematically identifies and rates known weaknesses; a penetration test actively attempts to exploit them to demonstrate real-world impact
- C. A penetration test is automated; a vulnerability assessment is manual
- D. A vulnerability assessment requires a production cluster; a pen test does not

*Assessments are broad, largely automated inventories of weaknesses (e.g. Trivy scans). Pen tests are focused, hands-on exploitation attempts that test whether those weaknesses are actually reachable and impactful.*

## Kubernetes Cluster Component Security

### Question 15

What is the difference between encryption at rest and encryption in transit?

**Answer: A**

- A. At rest protects stored data (e.g. etcd, volumes); in transit protects data moving across the network (e.g. TLS)
- B. At rest applies to backups only; in transit applies to live traffic only
- C. They are two names for TLS encryption
- D. At rest is handled by the application; in transit by the operating system

*Both are required for layered protection. In Kubernetes, encryption in transit covers API server and pod-to-pod traffic (TLS/mTLS); encryption at rest covers etcd (EncryptionConfiguration) and persistent volumes.*

## Compliance and Security Frameworks

### Question 16

What does GRC stand for in a security program?

**Answer: A**

- A. Governance, Risk, and Compliance
- B. Gateway, Routing, and Clusters
- C. Groups, Roles, and Controls
- D. Growth, Reliability, and Cost

*GRC is the organizational framework that ties together governance (policies and accountability), risk management (identify and treat risk), and compliance (meeting regulatory and contractual obligations).*

## Overview of Cloud Native Security

### Question 17

What do the '4Cs' of cloud native security stand for, and how do they relate to each other?

**Answer: A**

- A. Code, Containers, Clusters, Cloud - concentric layers where each outer layer must be secured independently rather than trusted to protect the inner one
- B. Configuration, Compliance, Cost, Control
- C. Compute, Caching, Connectivity, Cronjobs
- D. Credentials, Certificates, Chains, Cryptography

*The 4Cs (Code, Containers, Clusters, Cloud) model cloud native security as nested trust layers: the cloud provider secures the cloud, operators secure the cluster, the platform secures images and runtimes, and developers secure the code. Securing one layer never replaces the others - it is defense in depth applied to the whole stack.*

## Compliance and Security Frameworks

### Question 18

Why should you perform regular security training and phishing simulations for staff?

**Answer: B**

- A. They are only required for compliance checkboxes
- B. Because people are a primary attack vector; practiced staff measurably reduce successful phishing compromise rates
- C. They replace the need for network security
- D. They only matter for the security team, not developers

*Human factors are exploitable by design of social engineering. Regular training and simulations build the reflexes that technical controls cannot - reporting suspicious email rather than clicking - making them a control, not just compliance theatre.*

## Kubernetes Cluster Component Security

### Question 19

Which kube-apiserver flag enables RBAC authorization?

**Answer: A**

- A. --authorization-mode=Node,RBAC
- B. --enable-rbac=true
- C. --auth-provider=rbac
- D. --access-control=rbac

*API servers should run with --authorization-mode=Node,RBAC (Node authorizer for kubelets plus RBAC for everything else). ABAC is legacy and hard to manage; webhook authorizers are used for policy engines like OPA.*

## Kubernetes Security Fundamentals

### Question 20

What is a risk of leaving automountServiceAccountToken enabled (the default) for every Pod?

**Answer: B**

- A. The Pod cannot reach the API server
- B. Every Pod receives an API token it may not need - a compromised Pod can use it to call the Kubernetes API with the ServiceAccount's permissions
- C. The Pod starts slower
- D. ServiceAccount tokens cannot be rotated when enabled

*By default every Pod gets a token mounted at /var/run/secrets/kubernetes.io/serviceaccount. Workloads that never talk to the API should set automountServiceAccountToken: false, shrinking the blast radius if the Pod is compromised.*

### Question 21

Which built-in Kubernetes feature creates short-lived, automatically rotated ServiceAccount tokens?

**Answer: A**

- A. The TokenRequest API (bound service account tokens)
- B. manually created Secrets of type kubernetes.io/service-account-token
- C. etcd lease keys
- D. Client certificate rotation via kubelet

*The TokenRequest API issues time-bound tokens (via the kubelet's projected volumes or kubectl create token) that expire and rotate automatically - a major improvement over long-lived manually created token Secrets.*

### Question 22

What is the default traffic behavior of a namespace with no NetworkPolicies applied?

**Answer: B**

- A. All ingress and egress traffic is denied
- B. All traffic is allowed - policies must explicitly be created to restrict it
- C. Only DNS traffic is allowed
- D. Ingress is allowed, egress is denied

*Kubernetes is permissive by default: with no NetworkPolicy selecting a Pod, all ingress and egress is allowed. The standard hardening baseline is a default-deny policy, then explicit allow rules for what's needed.*

### Question 23

What is a default-deny NetworkPolicy and why is it a hardening baseline?

**Answer: B**

- A. A policy that denies all egress to the internet only
- B. A policy selecting all Pods that denies all ingress (and often egress) unless another policy explicitly allows it - turning the network from allow-all to deny-by-default
- C. A policy that blocks the kubelet from talking to the API server
- D. A built-in policy applied automatically to every namespace

*A default-deny policy (empty podSelector with policyTypes Ingress and Egress, no rules) stops all traffic to selected Pods. Allow policies are then layered on top, so lateral movement by an attacker is blocked unless explicitly permitted.*

### Question 24

How does Pod Security Admission (PSA) apply pod security standards?

**Answer: B**

- A. By mutating Pod specs to remove dangerous settings
- B. Via namespace labels in the form pod-security.kubernetes.io/<mode>: <level>, with modes enforce, audit, and warn
- C. By requiring a custom resource definition per namespace
- D. By blocking all Pods unless signed with a certificate

*PSA is built into the API server and configured per namespace with labels like pod-security.kubernetes.io/enforce: restricted. Enforce rejects non-compliant Pods, while audit and warn only log or warn, letting you tighten gradually.*

## Kubernetes Threat Model

### Question 25

An attacker compromises a workload and creates a hidden Deployment so their reverse-shell Pod is re-created whenever it is deleted. Which Kubernetes mechanism have they abused to maintain persistence?

**Answer: A**

- A. The reconciliation loop of controllers - the desired state stored in the API server keeps re-creating the resource
- B. DNS caching on the node
- C. The Pod's restartPolicy alone
- D. Container image layer caching

*Persistence in Kubernetes means writing desired state (a Deployment, Job, or CRD) into the API server: controllers continuously reconcile, so deleting the visible Pod accomplishes nothing. Detection relies on audit logs for unexpected creates; response includes restricting RBAC/admission rights and investigating how the API credentials were obtained.*

## Kubernetes Security Fundamentals

### Question 26

Which Pod Security Standard level would you enforce for most application namespaces?

**Answer: C**

- A. privileged, so operators are never blocked
- B. baseline, for a pragmatic minimum
- C. restricted, once workloads are compliant with modern hardening best practices
- D. No level - PSS should not be enforced

*restricted is the target for application namespaces: runAsNonRoot, no privilege escalation, seccomp RuntimeDefault, dropped capabilities. Teams usually roll out warn/audit first, fix workloads, then enforce restricted.*

### Question 27

What happened to PodSecurityPolicy (PSP)?

**Answer: B**

- A. It is still the recommended approach
- B. It was deprecated and removed in Kubernetes v1.25, replaced by Pod Security Admission and external policy engines
- C. It was renamed to NetworkPolicy
- D. It moved to a separate CNCF project unchanged

*PSP was deprecated in 1.21 and removed in 1.25. Its replacement stack: built-in Pod Security Admission for the standard levels, plus OPA/Gatekeeper or Kyverno for custom policy needs.*

## Kubernetes Cluster Component Security

### Question 28

By default, how are Secrets stored in etcd?

**Answer: B**

- A. Encrypted with AES automatically
- B. As base64-encoded plain text - readable by anyone with direct etcd access unless encryption at rest is configured
- C. Encrypted with the KMS provider's key
- D. Stored outside etcd in a separate secure store

*Secrets are only base64-encoded, which is encoding, not encryption. Anyone who can read etcd (or a backup of it) sees every Secret. Enable encryption at rest (EncryptionConfiguration with aescbc or a KMS v2 provider) to fix this.*

### Question 29

Which Kubernetes object configures encryption at rest for API resources in etcd?

**Answer: B**

- A. A Secret of type encryption.k8s.io
- B. An EncryptionConfiguration resource passed to the API server via --encryption-provider-config
- C. A ConfigMap in kube-system
- D. A StorageClass with encrypted: true

*The API server is started with --encryption-provider-config pointing to an EncryptionConfiguration that defines providers (aescbc, kms v2, secretbox, identity) and the resources to encrypt, such as secrets and configmaps.*

### Question 30

What does the Node authorization mode do?

**Answer: A**

- A. Authorizes kubelet read/write access only to the API objects belonging to Pods scheduled on that node
- B. Disables all authorization for kubelets
- C. Authorizes nodes to join the cluster automatically
- D. Manages NodeSelector labels automatically

*The Node authorizer lets each kubelet access only its own node's resources (Pods, Secrets mounted to those Pods, etc.). It runs alongside RBAC via --authorization-mode=Node,RBAC and is a key part of restricting node compromise.*

## Compliance and Security Frameworks

### Question 31

Which tool is commonly used to assess a Kubernetes cluster against the CIS Kubernetes Benchmark?

**Answer: A**

- A. kube-bench
- B. Trivy
- C. Falco
- D. Cosign

*kube-bench runs the CIS Benchmark checks against control plane nodes and workers, reporting misconfigured settings (weak authorization modes, insecure flags). Trivy scans images, Falco monitors runtime behavior, and Cosign signs artifacts.*

## Platform Security

### Question 32

What is the role of an admission controller such as OPA/Gatekeeper or Kyverno?

**Answer: B**

- A. To schedule Pods onto suitable nodes
- B. To intercept and validate (or mutate) API requests after authentication and authorization, enforcing policy before objects are created
- C. To scan images for vulnerabilities at runtime
- D. To encrypt etcd backups

*Admission controllers run in the API request path. Kyverno and Gatekeeper validate (reject non-compliant objects) or mutate (default security settings) resources - e.g. requiring labels, blocking privileged Pods, or restricting registries.*

## Kubernetes Threat Model

### Question 33

What is a trust boundary in a Kubernetes cluster?

**Answer: A**

- A. Any line where data or execution crosses into a different security domain - such as pod-to-pod traffic, container-to-host kernel, API client-to-apiserver, or apiserver-to-etcd - requiring an explicit, controlled interface
- B. The border between namespaces, which Kubernetes enforces as a hard security boundary by default
- C. The division between YAML and JSON manifest formats
- D. Only the perimeter between the internet and the data center

*Trust boundaries mark where code crosses into another security domain and must be re-verified: network policies gate pod-to-pod traffic, authentication/authorization gate API access, mTLS gates etcd access, and container runtimes gate the host kernel. Namespace labels alone are logical groupings - default-deny policies and PSA are what make them real boundaries.*

## Kubernetes Cluster Component Security

### Question 34

Which apiserver flag should be disabled or carefully controlled on production control planes?

**Answer: B**

- A. --secure-port
- B. --anonymous-auth (should be false unless a webhook authorizer handles unauthenticated requests)
- C. --etcd-servers
- D. --service-cluster-ip-range

*--anonymous-auth=true (the default in many setups) allows unauthenticated requests - combined with permissive RBAC bindings to system:anonymous, this is a classic path to cluster compromise. Production should disable it or tightly control its authorization.*

### Question 35

How should access to the etcd cluster be restricted?

**Answer: B**

- A. Expose etcd on the public internet with strong passwords
- B. Limit it to control-plane components via mutual TLS and network restrictions, since full etcd read access equals full cluster compromise
- C. Give every node read/write access for resilience
- D. Run etcd without authentication to reduce latency

*etcd holds every object including Secrets, so read access to it is effectively total cluster compromise. Harden with mutual TLS client certificates, firewall rules limiting peers, and separate encryption keys.*

### Question 36

What is the purpose of an audit policy in Kubernetes?

**Answer: B**

- A. To scan images for CVEs
- B. To define which API requests are logged (metadata, request body, or none), producing an audit trail for security investigations
- C. To chargeback teams for API usage
- D. To validate Pod security standards

*The audit policy (passed to the API server via --audit-policy-file) classifies requests by verb/resource and log level. A well-tuned policy captures who did what and when - essential for detecting privilege escalation - without drowning storage in noise.*

### Question 37

Why is running the control plane on a private network (not exposed to the internet) a key hardening step?

**Answer: B**

- A. It improves API performance
- B. It removes the control plane and etcd from direct internet exposure, so attacks require network access first
- C. It reduces cloud costs
- D. It is only needed for air-gapped environments

*The API server should be reachable only from trusted networks (VPN, bastion, private link). Internet-exposed control planes get brute-forced and scanned constantly - private endpoints plus authenticated access shrink the attack surface dramatically.*

### Question 38

How does OIDC authentication integrate with Kubernetes?

**Answer: B**

- A. It replaces RBAC with attribute-based rules
- B. It lets the API server validate tokens issued by an external identity provider (e.g. Okta, Azure AD), mapping user identity and groups to RBAC bindings
- C. It only works for ServiceAccount tokens
- D. It disables the need for TLS on the API server

*With --oidc-issuer-url and related flags, the API server trusts tokens from an external IdP. Users authenticate via kubectl plugins (e.g. kubelogin) and their identity/groups appear in RBAC - centralizing human access management with SSO and MFA.*

## Kubernetes Threat Model

### Question 39

What is a container escape, and why does running as root inside the container increase its impact?

**Answer: B**

- A. When a container is rescheduled onto a different node; privileges are irrelevant to the impact
- B. When a process breaks out of container isolation onto the host or neighboring containers; with root inside the container, kernel exploits and misconfigurations (privileged mode, host mounts, retained capabilities) far more easily yield root on the node
- C. When a container image fails to pull from its registry
- D. When DNS resolution fails between two pods

*Containers share the host kernel, so any isolation failure can expose the node and every workload on it. Root plus dangerous settings (privileged, hostPath, CAP_SYS_ADMIN) removes most friction for an attacker. Mitigations: runAsNonRoot, dropped capabilities, minimal attack surface, and sandboxed runtimes.*

## Kubernetes Cluster Component Security

### Question 40

Which statement correctly describes securing the kube-scheduler and kube-controller-manager?

**Answer: B**

- A. They must be exposed publicly so external autoscalers can reach them
- B. They should use least-privilege identities and be reachable only by the control plane - they act exclusively through the API server, never directly on nodes
- C. They require root SSH access from every worker node
- D. They each maintain their own copy of the cluster database

*Scheduler and controller-manager only read and write API objects through the API server; they hold no node-level access. Bind them to loopback/private endpoints with narrowly scoped RBAC. An attacker who controls them can influence scheduling and workload lifecycle, but etcd (the real prize) stays behind the API server's mTLS.*

### Question 41

Which practice most directly reduces the risk of a container escape to the host?

**Answer: B**

- A. Always pulling the newest image tag
- B. Using sandboxed container runtimes (such as gVisor or Kata Containers) that place a stronger boundary between container processes and the host kernel, combined with keeping the runtime patched
- C. Enabling privileged mode so the runtime has unrestricted kernel access
- D. Mounting the host filesystem into every container

*Standard runtimes share the host kernel, making kernel vulnerabilities an escape path. Sandboxed runtimes (user-space kernels or micro-VMs) shrink what a kernel exploit can reach. Privileged mode and host mounts do the opposite - they erase the boundary entirely.*

## Kubernetes Threat Model

### Question 42

Why is running a privileged container considered the single riskiest workload setting?

**Answer: B**

- A. Privileged containers consume more CPU
- B. It disables nearly all container isolation (cgroups, device access, capabilities), so a container escape is effectively a full host compromise
- C. They cannot be scheduled by the kube-scheduler
- D. They require a paid Kubernetes license

*privileged: true grants all capabilities and exposes host devices - the kernel boundary that containers rely on is effectively removed. If that container is compromised, the attacker owns the node. Block it via PSS baseline/restricted or policy engines.*

### Question 43

What risk do hostNetwork, hostPID, and hostIPC settings introduce?

**Answer: B**

- A. They slow down the container
- B. They share the node's network stack, process space, or IPC namespace with the container - enabling traffic sniffing, host process access, and escape aids
- C. They are required for all stateful applications
- D. They only affect DNS resolution

*Sharing host namespaces erodes container isolation: hostNetwork allows packet sniffing and binding host ports; hostPID exposes every process on the node (including other containers'); hostIPC shares inter-process communication. PSS baseline blocks all three.*

## Kubernetes Security Fundamentals

### Question 44

What is seccomp used for in container security?

**Answer: B**

- A. It encrypts container filesystems
- B. It restricts the system calls a container's processes may make, reducing kernel attack surface
- C. It scans images for vulnerabilities
- D. It manages container DNS

*Seccomp (Secure Computing Mode) filters syscalls at the kernel boundary. The RuntimeDefault profile blocks rarely needed, dangerous syscalls, and the restricted PSS requires it (seccompProfile.type: RuntimeDefault). Custom profiles can go further for specific apps.*

## Platform Security

### Question 45

How does a service mesh improve security between microservices?

**Answer: B**

- A. By encrypting data at rest inside etcd
- B. By giving each workload a short-lived identity and enforcing mutual TLS plus authorization policies on service-to-service traffic, without changing application code
- C. By replacing the need for RBAC in the cluster
- D. By scanning container images before deployment

*A service mesh (Istio, Linkerd) terminates mTLS between sidecars, issues workload identities (SPIFFE-style), and applies Layer-7 authorization policies. Services then authenticate and encrypt every call - even across trust zones - while policy lives in the mesh rather than in each codebase.*

## Kubernetes Security Fundamentals

### Question 46

What is the difference between a Role and a ClusterRole?

**Answer: B**

- A. Role is for nodes; ClusterRole is for users
- B. A Role grants permissions within a single namespace; a ClusterRole is cluster-scoped (all namespaces, or cluster-level resources like nodes)
- C. ClusterRole is simply a Role replicated to every node
- D. Roles can only be created by cluster-admins; ClusterRoles by namespace admins

*Namespace-scoped permission uses a Role + RoleBinding. ClusterRole + ClusterRoleBinding grants cluster-wide access (or to non-namespaced resources). A ClusterRole can also be bound inside one namespace via a RoleBinding - a common least-privilege pattern.*

### Question 47

A workload needs to read Secrets in its own namespace only. What is the least-privilege RBAC setup?

**Answer: B**

- A. Bind cluster-admin to the Pod's ServiceAccount
- B. Create a Role limited to get/list on secrets in that namespace and bind it to the ServiceAccount with a RoleBinding
- C. Create a ClusterRole allowing get/list on all secrets cluster-wide
- D. Grant the default ServiceAccount edit in all namespaces

*A namespaced Role (verbs: get,list; resources: secrets) bound via RoleBinding confines the workload to exactly what it needs. Cluster-wide secret read access would let a compromised workload exfiltrate every Secret in the cluster.*

## Kubernetes Threat Model

### Question 48

How should an application read its database password at runtime?

**Answer: C**

- A. Bake it into the container image at build time
- B. Pass it as an environment variable in the Pod spec, committed to Git
- C. Mount it from a Kubernetes Secret (ideally via an external secret store operator) rather than embedding it in code or images
- D. Hard-code it in the application's config file and rely on network isolation

*Never bake secrets into images or manifests. Mount Secret volumes (or sync from an external manager like External Secrets Operator) so credentials are injectable, rotatable, and auditable without rebuilding - and prefer files over env vars, which leak via process listings and logs.*

## Platform Security

### Question 49

What is the purpose of Falco in a Kubernetes security stack?

**Answer: B**

- A. To enforce network policies
- B. To perform runtime threat detection by monitoring syscalls and kernel events for anomalous behavior (e.g. unexpected shell in a container)
- C. To scan container images before deployment
- D. To manage TLS certificates

*Falco is a CNCF runtime security tool: it observes syscall and kernel activity against behavioral rules (unexpected process, file access, network connection) and alerts on deviations - catching what pre-deployment scanning and policies cannot.*

## Kubernetes Threat Model

### Question 50

How do ResourceQuotas and LimitRanges support multi-tenant cluster security?

**Answer: B**

- A. They encrypt tenant data
- B. They cap aggregate resource consumption and set per-object defaults/limits, preventing noisy-neighbor denial of service between tenants
- C. They create separate control planes per tenant
- D. They replace the need for NetworkPolicies

*Quotas stop one namespace from consuming all cluster resources (a denial-of-service risk to other tenants); LimitRanges enforce per-Pod defaults and maximums so runaway workloads can't starve neighbors. Combined with namespaces and network policies, they form Kubernetes multi-tenancy boundaries.*

## Kubernetes Security Fundamentals

### Question 51

Why should workload identities avoid using the 'default' ServiceAccount?

**Answer: B**

- A. The default ServiceAccount cannot mount tokens
- B. The default ServiceAccount is shared by every Pod in the namespace that doesn't specify one - its permissions would silently apply to all of them
- C. It cannot be bound to Roles
- D. It is removed in recent Kubernetes versions

*Each namespace has one default ServiceAccount. If RBAC is ever granted to it, every Pod without an explicit ServiceAccount inherits those rights. Create a dedicated ServiceAccount per workload and never grant it permissions.*

## Kubernetes Cluster Component Security

### Question 52

What does the kubelet's anonymous authentication risk refer to, and how is it mitigated?

**Answer: A**

- A. Kubelets can be configured to allow unauthenticated read of Pod specs via the read-only port - mitigate by disabling it (0) or firewalling it, and enabling webhook authorization
- B. Kubelets always allow anonymous writes
- C. It only applies to Windows nodes
- D. It is fixed by enabling RBAC on the API server alone

*The kubelet's read-only port (10255) historically served Pod specs - including env vars with secrets - unauthenticated. Hardening: set --read-only-port=0, enable --anonymous-auth=false with webhook authorization, and restrict the authenticated port (10250) with kubelet TLS bootstrapping and x509 client certs.*

## Kubernetes Security Fundamentals

### Question 53

What is the security benefit of namespace-level multi-tenancy combined with RBAC and NetworkPolicies?

**Answer: B**

- A. It reduces the number of clusters needed to zero
- B. It creates logical boundaries so one team's compromise cannot read or reach another's workloads - API access is scoped and traffic is segmented
- C. Namespaces automatically encrypt tenant traffic
- D. It removes the need for ServiceAccounts

*Namespaces are the Kubernetes tenancy unit: RBAC RoleBindings scope API access per namespace, NetworkPolicies segment traffic, and Quotas bound resource use. Together they approximate isolation boundaries - though hard multi-tenancy may still warrant separate clusters.*

## Platform Security

### Question 54

Where in the software delivery lifecycle should container image vulnerability scanning occur?

**Answer: B**

- A. Only in production, after incidents occur
- B. In CI when images are built, again at admission (policy enforcement), and continuously in running registries
- C. Once per year during an audit
- D. Scanning is unnecessary for base images

*Shift-left scanning catches CVEs in CI before images ship; admission controllers block non-compliant images from running; continuous registry scanning catches newly disclosed CVEs in already-stored images. All three layers together close the loop.*

### Question 55

What does image signing (e.g. with cosign/Sigstore) provide?

**Answer: B**

- A. It encrypts the image contents
- B. It cryptographically attests that an image came from a trusted source and hasn't been altered, allowing verifiers to reject unsigned or tampered images
- C. It compresses images for faster pulls
- D. It replaces vulnerability scanning

*Cosign signatures (stored alongside images in OCI registries) prove provenance and integrity. Admission policies can require valid signatures from trusted keys/identities, so only vetted images - not just anything from a public registry - can run.*

### Question 56

What is the goal of the SLSA framework?

**Answer: B**

- A. To standardize log formats across clouds
- B. To define escalating levels of build integrity and provenance, preventing tampering with the software supply chain from source to deployment
- C. To certify individual developers
- D. To manage container orchestration

*SLSA (Supply-chain Levels for Software Artifacts) defines build levels: from basic provenance (SLSA 1) up to two-person reviewed, hermetic, reproducible builds (SLSA 4) - making it verifiable how an artifact was built and by whom.*

### Question 57

What is an SBOM (Software Bill of Materials)?

**Answer: A**

- A. A list of a software's components and dependencies, enabling rapid assessment of exposure when a new CVE is disclosed
- B. A summary of billing for cloud services
- C. A document describing the build pipeline's stages
- D. An inventory of cluster nodes

*An SBOM (formats like SPDX, CycloneDX) inventories every component in an artifact. When Log4j-style CVEs hit, you query the SBOM to instantly find every image containing the vulnerable library - instead of guessing.*

### Question 58

Why should images be referenced by digest (sha256:...) rather than tag in production?

**Answer: B**

- A. Digests pull faster than tags
- B. Tags are mutable and can be repointed at different (even malicious) content; digests are content-addressed and immutable
- C. Digests are required by Kubernetes
- D. Tags cannot be used with private registries

*Anyone who can push can overwrite a tag (the classic 'tag mutability' attack). A digest is a hash of the exact image content - if the bytes change, the digest changes - so deployments referencing digests are guaranteed to run precisely what was reviewed.*

### Question 59

Why are minimal images (distroless, alpine-based, slim variants) a security best practice?

**Answer: B**

- A. They always run faster
- B. They remove shells, package managers, and unused binaries, shrinking the attack surface and the number of vulnerable packages
- C. They do not require scanning
- D. They are always smaller than 10MB

*A distroless image contains only the app and its runtime - no shell for attackers to spawn, no apt/yum to install tools, fewer packages to contain CVEs. Combined with read-only root filesystems and non-root users, this dramatically limits post-exploitation options.*

### Question 60

How should a cluster restrict which images are allowed to run?

**Answer: B**

- A. Rely on developers' good judgment
- B. Use an admission controller (OPA/Gatekeeper or Kyverno) to enforce policy: only images from approved registries, with required signatures and acceptable scan results
- C. Disable image pulls entirely
- D. Only allow images from Docker Hub

*Admission policy turns supply-chain rules into enforcement: allowlist registries, require cosign signatures, block images with critical CVEs, forbid :latest. Kyverno or Gatekeeper validate every image reference at Pod creation time.*
