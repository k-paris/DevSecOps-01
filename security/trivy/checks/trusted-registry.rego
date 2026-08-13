# METADATA
# title: Require approved GHCR registry
# description: Kubernetes workloads must use images from ghcr.io/k-paris/
# schemas:
#   - input: schema["kubernetes"]
# custom:
#   id: CUSTOM-K8S-001
#   severity: MEDIUM
#   input:
#     selector:
#       - type: kubernetes

package user.kubernetes.CUSTOM_K8S_001

deny[res] {
    input.kind == "Deployment"

    container := input.spec.template.spec.containers[_]

    not startswith(container.image, "ghcr.io/k-paris/")

    msg := sprintf(
        "Container '%s' uses unapproved image '%s'. Allowed registry prefix is ghcr.io/k-paris/",
        [container.name, container.image],
    )

    res := result.new(msg, container)
}
