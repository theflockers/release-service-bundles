# publish-index-image

Publish a built FBC index image using skopeo

## Parameters

| Name | Description | Optional | Default value |
|------|-------------|----------|---------------|
| requestJsonResults | The JSON result of the IIB build internal request | No | |
| targetIndex | targetIndex signing image | No | |
| retries | Number of skopeo retries | Yes | "0" |
| publishingCredential | The credentials used to access the registry | Yes | "fbc-publishing-pull-secret" |
| requestUpdateTimeout | Max seconds waiting for the status update | Yes | 360 |

