# deploy.sh
#!/bin/bash

SHA1=$1

# Deploy image to Docker Hub
docker push thedpd/api-peer:$SHA1

# Create new Elastic Beanstalk version
EB_BUCKET=peerbelt
DOCKERRUN_FILE=$SHA1-Dockerrun.aws.json
#sed "s/<TAG>/$SHA1/" < Dockerrun.aws.json.template > $DOCKERRUN_FILE
aws --profile peer s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$DOCKERRUN_FILE
aws --profile peer elasticbeanstalk create-application-version --application-name zeCHAT --version-label $SHA1 --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE

# Update Elastic Beanstalk environment to new version
aws --profile peer elasticbeanstalk update-environment --environment-name PROD --version-label $SHA1
