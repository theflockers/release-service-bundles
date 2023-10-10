# rh-push-to-registry-redhat-io pipeline

Tekton pipeline to release content to registry.redhat.io registry.

## Parameters

| Name | Description | Optional | Default value |
|------|-------------|----------|---------------|
| release | The namespaced name (namespace/name) of the Release custom resource initiating this pipeline execution | No | - |
| releaseplan | The namespaced name (namespace/name) of the releasePlan | No | - |
| releaseplanadmission | The namespaced name (namespace/name) of the releasePlanAdmission | No | - |
| snapshot | The namespaced name (namespace/name) of the snapshot | No | - |
| enterpriseContractPolicy | JSON representation of the policy to be applied when validating the enterprise contract | No | - |
| enterpriseContractPublicKey | Public key to use for validation by the enterprise contract | Yes | k8s://openshift-pipelines/public-key |
| tagPrefix | The prefix used to build the tag in - format | yes | "" |
| timestampFormat | Timestamp format used to build the tag when tagPrefix is set | yes | %s |
| tag | The default tag to use when mapping file does not contain a tag | No | - |
| addGitShaTag | When pushing the snapshot components, also push a tag with the image git sha | Yes | true |
| addSourceShaTag | When pushing the snapshot components, also push a tag with the image source sha | Yes | true |
| addTimestampTag | When pushing the snapshot components, also push a tag with the current timestamp | Yes | false |
| postCleanUp | Cleans up workspace after finishing executing the pipeline | Yes | true |
| verify_ec_task_git_url | The git repo url of the verify-enterprise-contract task | No | - |
| verify_ec_task_git_revision | The git repo revision the verify-enterprise-contract task | No | - |
| verify_ec_task_git_pathInRepo | The location of the verify-enterprise-contract task in its repo | No | - |
