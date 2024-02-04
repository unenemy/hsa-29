AWS Lambda configuration
- at least 256 MB memory
- at least 10 secs timeout
- add Layer with image-magick installed
- configure the trigger as s3:ObjectCreated:*
- make sure to have the bucket called 'hsa-29-output' for results to be uploaded into
- make sure to give it write access to the S3 bucket for output and read access for input
- make sure to give access for logs writing to CloudWatch

To prepare zip package run:

```
bundle install
zip -r deployment-package.zip lambda_function.rb vendor
```

Bundled zip with ruby gems dependencies is included in the root of the repo.