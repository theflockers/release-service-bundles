# create-advisory

Tekton task to create an advisory via an InternalRequest. The advisory data is pulled from the data JSON. The origin workspace from
the ReleasePlanAdmission and Application from the Snapshot are also used. The advisory is created in a GitLab repository.
Which repository to use is determined by the contents on the mapped repositories.
Only all `redhat-pending` or all `redhat-prod` repositories may be specified in `.data.mapping`

## Parameters

| Name                     | Description                                                                               | Optional | Default value               |
|--------------------------|-------------------------------------------------------------------------------------------|----------|-----------------------------|
| jsonKey                  | The json key containing the advisory data                                                 | Yes      | .releaseNotes               |
| releasePlanAdmissionPath | Path to the JSON file of the ReleasePlanAdmission in the data workspace                   | No       | -                           |
| snapshotPath             | Path to the JSON file of the Snapshot spec in the data workspace                          | No       | -                           |
| dataPath                 | Path to data JSON in the data workspace                                                   | No       | -                           |
| resultsDirPath           | Path to results directory in the data workspace                                           | No       | -                           |
| request                  | Type of request to be created                                                             | Yes      | create-advisory             |
| synchronously            | Whether the task should wait for InternalRequests to complete                             | Yes      | true                        |
| pipelineRunUid           | The uid of the current pipelineRun. Used as a label value when creating internal requests | No       | -                           |

## Changes in 4.4.3
* Pass the errata service account secret name to the InternalRequest based on stage or prod

## Changes in 4.4.2
* If the releaseNotes do not specify any CVEs fixed and the type is RHSA, fail the task
* If the releaseNotes specify CVEs fixed, proceed with type set to RHSA regardless of the passed type

## Changes in 4.4.1
* Fix linting issues in this task.

## Changes in 4.4.0
* Update task to use repository value from snapshot JSON insted of data JSON.

## Changes in 4.3.0
* Updated the base image used in this task

## Changes in 4.2.0
* The task now validates that the advisory type is one of RHSA, RHBA or RHEA.

## Changes in 4.1.0
* Updated the base image used in this task

## Changes in 4.0.1
* Use set -x in the task's script. That way we get more information in the log for debugging in case of failure

## Changes in 4.0.0
* The task now writes created artifacts to a results json file in the workspace

## Changes in 3.3.0
* Removed `releaseServiceConfigPath` parameter as it is no longer needed.

## Changes in 3.2.0
* remove `dataPath`, `snapshotPath` and `releasePlanAdmissionPath` default values

## Changes in 3.1.0
* This task now detects which secret to use for creating advisories based on the targeted quay repository.
* Only all `redhat-pending` or all `redhat-prod` repositories may be specified in `.data.mapping`

## Changes in 3.0.0
* Task renamed from create-advisory-internal-request to create-advisory

## Changes in 2.1.0
* The advisory_url is reported as task result
  * If the advisory was not created, the result will instead be the empty string

## Changes in 2.0.0
* The path to the ReleaseServiceConfig in the data workspace is now passed as a parameter
  * The advisory repo will be fetched from the ReleaseServiceConfig json

## Changes in 1.2.0
* The sign.configMapName is passed to the internal request so the signing key can be added to the advisory yaml

## Changes in 1.1.0
* The default value of jsonKey changed from .advisory to .releaseNotes

## Changes in 1.0.0
* The internalrequest CR is created with a label specifying the pipelinerun uid with the new pipelineRunUid parameter
  * This change comes with a bump in the image used for the task

## Changes in 0.1.0
* Updated hacbs-release/release-utils image to reference redhat-appstudio/release-service-utils image instead