import json
import boto3

s3 = boto3.resource('s3')

bucketlist = []
for bucket in s3.buckets.all():
         bucketlist.append(bucket.name)
         print(bucketlist)

def lambda_handler(event, context): 
 
      for obj in bucketlist.objects.all():
        print(obj.key)

   
