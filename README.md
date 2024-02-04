AWS Lambda configuration
- at least 256 MB memory
- at least 10 secs timeout
- add Layer with image-magick installed
- configure the trigger as s3:ObjectCreated:*
- make sure to have the bucket called 'hsa-29-output' for results to be uploaded into

Bundled zip with ruby gems dependencies is in the root of the repo.