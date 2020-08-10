#!/bin/bash
PROJECT_ROOT=$(pwd)
source common.env
cd $(dirname "$0")

source .env

echo "SITE_BUCKET_NAME $SITE_BUCKET_NAME"
echo "DOMAIN_NAME $DOMAIN_NAME"
echo "HOSTED_ZONE_NAME $HOSTED_ZONE_NAME"
echo "CERTIFICATE_ARN $CERTIFICATE_ARN"

aws cloudformation create-stack --stack-name $STACK_NAME \
  --template-body file://aws-infrastructure.yml \
  --parameters \
    ParameterKey=SiteBucketName,ParameterValue=$SITE_BUCKET_NAME \
    ParameterKey=DomainName,ParameterValue=$DOMAIN_NAME \
    ParameterKey=HostedZoneName,ParameterValue=$HOSTED_ZONE_NAME \
    ParameterKey=CertificateARN,ParameterValue=$CERTIFICATE_ARN

if [ !( $? -eq 0 ) ]
then
  echo "Deploy failed."
  exit 1;
fi

# Wait until the stack creation is complete
echo "Waiting for stack create complete"
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

if [ !( $? -eq 0 ) ]
then
  echo "Waiting until rollback finishes to delete stack."
  aws cloudformation wait stack-rollback-complete --stack-name $STACK_NAME

  echo "Rolback finished. Deleting stack."
  aws cloudformation delete-stack --stack-name $STACK_NAME

  echo "Waiting until stack delete is done."
  aws cloudformation wait stack-rollback-complete --stack-name $STACK_NAME

  echo "Deploy failed."
  exit 1;
fi

echo "Syncing site files to: s3://$SITE_BUCKET_NAME/"
aws s3 sync dist/ s3://$SITE_BUCKET_NAME/
echo "Files synced successfully"

# echo "Invalidating cloudfront distribution"

# aws cloudfront create-invalidation --distribution-id $CLOUDFRONT_DIST --paths "/*"

echo "Done."