# CKA Practice Lab - techiescamp Guide - Answers & Explanations

> **Source & license.** Questions adapted from [PRACTICE_QUESTIONS.md](https://github.com/techiescamp/cka-certification-guide/blob/main/PRACTICE_QUESTIONS.md) of the [techiescamp/cka-certification-guide](https://github.com/techiescamp/cka-certification-guide) repo (credited to Techiescamp / DevOpsCube). **Note:** unlike the other sources used by this simulator, this repo carries an *All Rights Reserved* license (Copyright 2024 Techiescamp) rather than an open-source license - the questions here are adapted with attribution for personal exam practice; contact `contact@devopscube.com` for any other use.
>
> The source is a 35-question set; these 10 were selected after checking all of them against cka-001..007 to avoid duplicates (source Q2, Q6/Q7/Q33, Q9-Q12, Q14-Q18, Q20-Q21, Q24, Q26, Q30-Q31, Q35 all already appear in earlier labs; Q23/Q29 require SSH to nodes, which this simulator's kubectl-only environment forbids).
>
> Adapted to this simulator: dedicated namespaces instead of `default` where the source leaves it implicit, pinned images (`nginx:1.27`, `busybox:1.36`), files under `/tmp/exam/`, Question 6 merges source Q15+Q16 (claim on the default StorageClass + a pod consuming it) so it binds regardless of the class's binding mode, Question 10 grades the extracted lines into `/tmp/exam/outputs/`, and Question 7's deny-direction is validated at spec level because the lab cluster's CNI does not enforce NetworkPolicy.

## Question 1: Role bound to a user (with `can-i` scoping)

### Solution

```bash
kubectl create namespace rbac-test   # already exists from setup

kubectl create role pod-manager \
  --verb=get,list,watch,create,delete \
  --resource=pods \
  -n rbac-test

kubectl create rolebinding pod-manager-binding \
  --role=pod-manager \
  --user=alice \
  -n rbac-test

# verify like the validation does
kubectl auth can-i get pods    -n rbac-test --as=alice   # yes
kubectl auth can-i delete pods -n rbac-test --as=alice   # yes
kubectl auth can-i get secrets -n rbac-test --as=alice   # no
kubectl auth can-i list pods   -n default   --as=alice   # no
```

The Role must hold **exactly** one rule on `pods` with exactly those five verbs - adding `secrets` or a second rule fails the validation, because the question says "and nothing else". The binding's subject kind must be `User` (not `ServiceAccount`).

## Question 2: ServiceAccount token mount

### Solution

```bash
kubectl create serviceaccount app-sa -n sa-token

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sa-pod
  namespace: sa-token
spec:
  serviceAccountName: app-sa
  containers:
    - name: sa-pod
      image: nginx:1.27
EOF

kubectl -n sa-token wait pod/sa-pod --for=condition=Ready --timeout=120s

# verify the token is mounted...
kubectl -n sa-token exec sa-pod -- ls /var/run/secrets/kubernetes.io/serviceaccount/
# ...and that it really belongs to app-sa (decode the JWT payload)
kubectl -n sa-token exec sa-pod -- sh -c \
  'cut -d. -f2 /var/run/secrets/kubernetes.io/serviceaccount/token | tr "_-" "/+" | base64 -d'
#   "sub":"system:serviceaccount:sa-token:app-sa"
```

Since Kubernetes 1.24 no Secret is created for the token, but the kubelet still auto-mounts the **projected** token volume whenever `serviceAccountName` points at a ServiceAccount (unless `automountServiceAccountToken: false`). The validation checks the decoded `sub` claim, so an empty or wrong token fails.

## Question 3: Apply a prepared Kustomize base

### Solution

```bash
# preview what the kustomization produces (namespace gets injected, label added)
kubectl kustomize /tmp/exam/kustomize/base

# apply it - this is the one command the question is really about
kubectl apply -k /tmp/exam/kustomize/base

# verify
kubectl -n kustomize-demo get deploy,svc
kubectl -n kustomize-demo get deploy webapp -o jsonpath='{.metadata.namespace}{"\n"}'
```

Why not `kubectl apply -f /tmp/exam/kustomize/base/`? That would land the resources in `default` (the raw manifests have no namespace) and the validation explicitly rejects stray copies there. Only the kustomization's `namespace: kustomize-demo` (plus the `app.kubernetes.io/managed-by` label) gets applied.

## Question 4: Init container writing to a shared volume

### Solution

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: init-pod
  namespace: init-shared
spec:
  volumes:
    - name: shared-vol
      emptyDir: {}
  initContainers:
    - name: init-container
      image: busybox:1.36
      command: ["sh", "-c", "echo \"Init complete\" > /shared/init.txt"]
      volumeMounts:
        - name: shared-vol
          mountPath: /shared
  containers:
    - name: main-container
      image: nginx:1.27
      volumeMounts:
        - name: shared-vol
          mountPath: /usr/share/data
EOF

kubectl -n init-shared wait pod/init-pod --for=condition=Ready --timeout=120s
kubectl -n init-shared exec init-pod -- cat /usr/share/data/init.txt
# Init complete
```

Both containers must reference the **same** `emptyDir` volume - the classic pattern for an init container to hand a file to the main container. The validation also requires the init container's terminated exit code to be `0` and the exact command text.

## Question 5: ConfigMap and Secret as environment variables

### Solution

```bash
kubectl create configmap app-config \
  --from-literal=APP_ENV=production \
  --from-literal=LOG_LEVEL=info \
  -n env-demo

kubectl create secret generic db-secret \
  --from-literal=DB_PASSWORD=supersecret \
  -n env-demo

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: config-pod
  namespace: env-demo
spec:
  containers:
    - name: config-pod
      image: nginx:1.27
      envFrom:
        - configMapRef:
            name: app-config
      env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: DB_PASSWORD
EOF

kubectl -n env-demo exec config-pod -- env | grep -E 'APP_ENV|LOG_LEVEL|DB_PASSWORD'
```

The question deliberately splits the two mechanisms: **all** ConfigMap keys via `envFrom`, but the single Secret key via an explicit `env` entry with `secretKeyRef` (the validation fails if you use `envFrom` on the Secret).

## Question 6: PVC on the default StorageClass + consuming pod

### Solution

```bash
# 1. find the default class (k3s: local-path)
kubectl get storageclass
# NAME          PROVISIONER            AGE   DEFAULT
# local-path    rancher.io/local-path  ...   (default)

cat <<'EOF' | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
  namespace: dynamic-storage
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  # no storageClassName -> admission sets it to the default (or name it explicitly)
---
apiVersion: v1
kind: Pod
metadata:
  name: storage-pod
  namespace: dynamic-storage
spec:
  containers:
    - name: nginx
      image: nginx:1.27
      volumeMounts:
        - name: data
          mountPath: /data
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: dynamic-pvc
EOF

kubectl -n dynamic-storage get pvc dynamic-pvc   # Bound
kubectl -n dynamic-storage get pod storage-pod   # Running
```

Omitting `storageClassName` lets the DefaultStorageClass admission plugin fill in the default. The pod matters because k3s's `local-path` class may defer provisioning until a consumer exists (WaitForFirstConsumer); with the pod in place the claim binds either way. The validation also checks the bound PV carries the `pv.kubernetes.io/provisioned-by` annotation - a hand-written static PV would fail.

## Question 7: Default-deny NetworkPolicy

### Solution

```bash
cat <<'EOF' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: secure
spec:
  podSelector: {}          # ALL pods in the namespace
  policyTypes:
    - Ingress
    - Egress
  # no ingress:/egress: sections at all -> nothing allowed
EOF

kubectl -n secure get netpol deny-all -o yaml
```

The three graded properties: `podSelector: {}` (empty = select everything), **both** policy types listed, and zero allow rules. Note that merely listing `policyTypes` without rules is exactly what makes it a deny-all - adding `ingress: [{}]` (an empty rule) would allow everything again.

*(Deny behavior is validated at spec level only - the lab cluster's CNI does not enforce NetworkPolicy.)*

## Question 8: Fix the pod's image reference (ImagePullBackOff)

### Solution

```bash
kubectl -n image-pull describe pod bad-image | grep -A2 Failed
#   Failed to pull image "nginx:1.27-typo": ... not found

# pods allow in-place image updates:
kubectl -n image-pull set image pod/bad-image bad-image=nginx:1.27
# (or: kubectl -n image-pull edit pod bad-image  ->  fix the image)

kubectl -n image-pull wait --for=condition=Ready pod/bad-image --timeout=120s
```

Unlike most of a Pod's spec, `containers[].image` **is** mutable on a running/created pod, so no delete-and-recreate is needed. If you do recreate it, keep the name `bad-image`, the namespace, and exactly one container with that name - the validation checks all three.

## Question 9: Pending pod fixed at the node (identity preserved)

### Solution

```bash
kubectl -n pending-lab describe pod pending-pod | grep -A3 Events
#   Warning  FailedScheduling  0/3 nodes are available: 3 node(s) didn't match Pod's node affinity/selector.

# the fix is on the node, not the pod:
kubectl label node k3d-cluster-agent-1 workload=batch

kubectl -n pending-lab get pod pending-pod -o wide   # Running on k3d-cluster-agent-1
```

The pod must never be touched: its **UID is recorded at setup** and compared during validation, so `kubectl delete` + recreate fails even if the new pod looks identical. Editing the pod's `nodeSelector` away would also be a spec change - labelling the node is the only solution that satisfies the constraint. (Node labels are chosen here rather than the source's generic "investigate" list because taints/quota/affinity variants were already covered by cka-002 Q7, cka-005 Q11 and cka-006 Q4.)

## Question 10: Extract one container's logs to a file

### Solution

```bash
mkdir -p /tmp/exam/outputs

kubectl logs multi-app -n logs -c app --tail=100 \
  > /tmp/exam/outputs/multi-app-logs.txt

wc -l /tmp/exam/outputs/multi-app-logs.txt   # 100
head -1 /tmp/exam/outputs/multi-app-logs.txt # app-line-51
grep sidecar /tmp/exam/outputs/multi-app-logs.txt   # (nothing)
```

Both details are graded: `-c app` (without it kubectl refuses on a multi-container pod, and pulling from the wrong container or mixing them fails the content check) and `--tail=100` (the pod's `app` container has written 150 stable lines, so the file must start at `app-line-51`, not `app-line-1`).
